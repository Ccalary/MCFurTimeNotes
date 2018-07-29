//
//  TNMainViewController.m
//  TimeNotes
//
//  Created by caohouhong on 2018/7/25.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "TNMainViewController.h"
#import "TNMainTableViewCell.h"
#import "TNAddNotesVC.h"
#import "TNBaseNavigationController.h"
#import "AppDelegate.h"
#import "Notes+CoreDataClass.h"
#import <CoreData/CoreData.h>
#import "TNBaseTableView.h"

@interface TNMainViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) TNBaseTableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
//保存原始数据
@property (strong, nonatomic) NSMutableArray *dataArray;
//保存搜索数据
@property (nonatomic, strong) NSMutableArray *searchArray;
//是否是搜索状态
@property (nonatomic, assign) BOOL isSearch;
@end

@implementation TNMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notesChange) name:NOTIFICATION_NOTES_CHANGED_SUCCESS object:nil];
    [self tn_drawView];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)tn_drawView {
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add"] style:UIBarButtonItemStylePlain target:self action:@selector(nav_rightBtnAction)];
    
    self.dataArray = [NSMutableArray array];
    self.searchArray = [NSMutableArray array];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, TNScreenWidth , 55)];
    self.searchBar.placeholder = @"搜索";
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    [self.view addSubview:self.searchBar];
    
    _tableView = [[TNBaseTableView alloc] initWithFrame:CGRectMake(0, 55, TNScreenWidth, TNScreenHeight - TNTabBarHeight - TNTopFullHeight - 55) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
//    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.searchBar.mas_bottom);
//        make.bottom.left.right.mas_equalTo(self.view);
//    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    是否搜索状态
    if (_isSearch){
        return _searchArray.count;
    }else {
        return _dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    TNMainTableViewCell *cell = (TNMainTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TNMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_isSearch){
         cell.notesModel = self.searchArray[indexPath.row];
    }else {
        cell.notesModel = self.dataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

//走了左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){//删除操作
        Notes *notes = self.dataArray[indexPath.row];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
        [context deleteObject:notes];
        [context save:nil];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        //删除某行并配有动画
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//更改左滑后的字体显示
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果系统是英文，会显示delete,这里可以改成自己想显示的内容
    return @"删除";
}


- (void)requestData {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    //创建查询请求--类似于网络请求NSURLRequest
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ENTITYNAME_NOTES];
    //对结果进行排序--可选
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"dateStr" ascending:NO];
    request.sortDescriptors = @[timeSort];
    //发送查询请求，并返回结果
    NSError *error = nil;
    NSArray *resArray = [context executeFetchRequest:request error:&error];
    self.dataArray = [NSMutableArray arrayWithArray:resArray];
    
    if (error) {
        NSLog(@"error = %@", error);
    }
    
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate
//取消按钮的点击事件
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //取消搜索状态
    _isSearch = NO;
    searchBar.text = @"";
    //关闭键盘
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}

//当搜索框内的文本改变时激发该方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self filterBySubstring:searchText];
}
//点击search按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self filterBySubstring:searchBar.text];
    //关闭键盘
    [searchBar resignFirstResponder];
}

//过滤
- (void)filterBySubstring:(NSString *)substr{
    //设置搜索状态
    _isSearch = YES;
    //定义搜索谓词
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", substr];
    [self.searchArray removeAllObjects];
    if (substr.length == 0){
        [self.searchArray addObjectsFromArray:self.dataArray];
    }else {
        //使用谓词过滤NSArray
        for (Notes *model in self.dataArray){
            NSLog(@"%@-%@-%@",model.title,model.dateStr,model.content);
            if ([model.title containsString:substr] || [model.content containsString:substr] || [model.dateStr containsString:substr]){
                [self.searchArray addObject:model];
                NSLog(@"加入的：%@",model.title);
            }
        }
    }
    //让表格重新加载数据
    [self.tableView reloadData];
}

- (void)nav_rightBtnAction {
    TNAddNotesVC *vc = [[TNAddNotesVC alloc] init];
    TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

// 笔记有更改
- (void)notesChange {
    [self requestData];
}

@end
