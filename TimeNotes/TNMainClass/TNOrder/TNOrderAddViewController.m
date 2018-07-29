//
//  TNOrderAddViewController.m
//  TimeNotes
//
//  Created by caohouhong on 2018/7/27.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "TNOrderAddViewController.h"
#import "TNTagViewController.h"
#import "AppDelegate.h"
#import "Order+CoreDataClass.h"
#import <CoreData/CoreData.h>

@interface TNOrderAddViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *detailStr;
@property (nonatomic) BOOL isOn;
@end

@implementation TNOrderAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加预约";
    self.view.backgroundColor = [UIColor tn_backgroundColor];
    _dataArray = @[@"标签",@"稍后提醒"];
    self.detailStr = @"预约";
    [self tn_drawView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (void)tn_drawView {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(nav_leftBtnAction)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"存储" style:UIBarButtonItemStylePlain target:self action:@selector(nav_rightBtnAction)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TNScreenWidth, TNScreenHeight - TNTopFullHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor tn_backgroundColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, TNScreenWidth, 200)];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    // 1.3设置datePickr的地区语言, zh_Han后面是s的就为简体中文,zh_Han后面是t的就为繁体中文
    [_datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Han"]];
    // 1.4监听datePickr的数值变化
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    // 2.3 将转换后的日期设置给日期选择控件
    [_datePicker setDate:[NSDate date]];
    
    [self.tableView setTableHeaderView:_datePicker];
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
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
      
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    if (indexPath.row == 0){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = self.detailStr;
    }else if (indexPath.row == 1){
        UISwitch *rightSwitch = [[UISwitch alloc] init];
        [rightSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = rightSwitch;
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0){
        TNTagViewController *vc = [[TNTagViewController alloc] init];
        vc.tagStr = self.detailStr;
        [self.navigationController pushViewController:vc animated:YES];
        __weak typeof (self) weakSelf = self;
        vc.block = ^(NSString *text) {
            weakSelf.detailStr = text;
            [weakSelf.tableView reloadData];
        };
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)dateChanged:(UIDatePicker *)picker {
    
}

- (void)switchAction:(UISwitch *)mSwitch {
    self.isOn = mSwitch.isOn;
}

// 取消
- (void)nav_leftBtnAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 存储
- (void)nav_rightBtnAction {
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appdelegate.persistentContainer.viewContext;
    Order *order = [NSEntityDescription insertNewObjectForEntityForName:ENTITYNAME_ORDER inManagedObjectContext:context];

    order.timestamp = [NSString stringWithFormat:@"%f",[self.datePicker.date timeIntervalSince1970]];
    order.on = (self.isOn) ? @"1" : @"0";
    order.content = self.detailStr;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *creatTime = [formatter stringFromDate:[NSDate date]];
    order.creatTime = creatTime;
    
    NSError *error = nil;
    [context save:&error];
    if (error){
        NSLog(@"error,%@",error);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_ORDER_SUCCESS object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
