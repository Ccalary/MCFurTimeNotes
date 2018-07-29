//
//  TNOrderViewController.m
//  TimeNotes
//
//  Created by caohouhong on 2018/7/25.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "TNOrderViewController.h"
#import "TNOrderTableViewCell.h"
#import "TNLocalNotification.h"
#import "TNOrderAddViewController.h"
#import "TNBaseNavigationController.h"
#import "AppDelegate.h"
#import "Order+CoreDataClass.h"
#import <CoreData/CoreData.h>
#import "TNLocalNotification.h"

@interface TNOrderViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *emptyView;
@end

@implementation TNOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOrderSuccess) name:NOTIFICATION_ADD_ORDER_SUCCESS object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

- (UIView *)emptyView {
    if (!_emptyView){
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TNScreenWidth, TNScreenHeight - TNTopFullHeight - TNTabBarHeight)];
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.text = @"未添加预约提醒";
        tipsLabel.textColor = [UIColor grayColor];
        tipsLabel.font = [UIFont boldSystemFontOfSize:24];
        [_emptyView addSubview:tipsLabel];
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.emptyView);
            make.top.offset((TNScreenHeight - TNTopFullHeight - TNTabBarHeight)/2.0-10);
        }];
    }
    return _emptyView;
}

- (void)setUpView {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add"] style:UIBarButtonItemStylePlain target:self action:@selector(nav_rightBtnAction)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TNScreenWidth, TNScreenHeight - TNTopFullHeight - TNTabBarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    TNOrderTableViewCell *cell = (TNOrderTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TNOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    __weak typeof (self) weakSelf = self;
    cell.block = ^(BOOL isOn, NSUInteger row) {
        Order *order = self.dataArray[row];
        order.on = isOn ? @"1" : @"0";
        [weakSelf reloadRowAtRow:row];
    };
    cell.orderModel = self.dataArray[indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

// 刷新某一行
- (void)reloadRowAtRow:(NSUInteger)row{
    NSArray *position = @[[NSIndexPath indexPathForRow:row inSection:0]];
    [self.tableView reloadRowsAtIndexPaths:position withRowAnimation:UITableViewRowAnimationNone];
}

// 加载数据
- (void)requestData{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    //创建查询请求--类似于网络请求NSURLRequest
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ENTITYNAME_ORDER];
  
    //查询条件--可选
    //就是需要LXStudent中gender的值必须为"男"
//    NSPredicate *name = [NSPredicate predicateWithFormat:@"gender = %@", @"男"];
//    request.predicate = name;
    
    //对结果进行排序--可选
//    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
//    request.sortDescriptors = @[timeSort];
    
    //发送查询请求，并返回结果
    NSError *error = nil;
    NSArray *resArray = [context executeFetchRequest:request error:&error];    
    self.dataArray = [NSMutableArray arrayWithArray:resArray];
    
    for (Order *order in self.dataArray) {
        NSTimeInterval nowTimestamp = [[NSDate date] timeIntervalSince1970];
        double timeDif = [[NSString stringWithFormat:@"%@",order.timestamp] doubleValue] - nowTimestamp;
        if (timeDif < 60){
            [self deleteOrder:order];
            [self.dataArray removeObject:order];
        }
    }
    if (error) {
        NSLog(@"error = %@", error);
    }
    [TNLocalNotification removeAllNotification];
    [self.tableView reloadData];
    if (self.dataArray.count == 0){
        [self.view addSubview:self.emptyView];
    }else {
         [self.emptyView removeFromSuperview];
    }
}

// 删除
- (void)deleteOrder:(Order *)order {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    ///读取所有的实体
    NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITYNAME_ORDER inManagedObjectContext:context];
    ///创建请求
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    
    ///创建条件
    NSString *str = [NSString stringWithFormat:@"creatTime=%@",order.creatTime];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    [request setPredicate:predicate];
    
    ///获取符合条件的结果
    NSArray *resultArray = [context executeFetchRequest:request error:nil];
    if (resultArray.count>0) {
        for (Order *ord in resultArray) {
            ///删除实体
            [context deleteObject:ord];
            NSLog(@"删除Order:%@",ord.creatTime);
        }
        ///保存结果并且打印
        [delegate saveContext];
    }else{
        NSLog(@"没有符合条件的结果");
    }
}


- (void)nav_rightBtnAction {
    TNOrderAddViewController *addVC = [[TNOrderAddViewController alloc] init];
    TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:addVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)addOrderSuccess {
    [self requestData];
}

@end
