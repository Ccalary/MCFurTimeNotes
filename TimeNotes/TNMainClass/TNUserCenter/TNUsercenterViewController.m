//
//  TNUsercenterViewController.m
//  TimeNotes
//
//  Created by caohouhong on 2018/7/25.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "TNUsercenterViewController.h"
#import "TNOrderAddViewController.h"
#import "TNBaseNavigationController.h"
@interface TNUsercenterViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tnTableView;
@property (nonatomic, strong) NSArray *sourceArray;
@end

@implementation TNUsercenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sourceArray = @[@"添加预约",@"联系我们",@"版本号"];
    [self tn_drawView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)tn_drawView {
    
    UIImageView *headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_bg"]];
    headerView.frame = CGRectMake(0, 0, TNScreenWidth, 300);
    
    UIImageView *header = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
    header.layer.cornerRadius = 40;
    header.layer.masksToBounds = YES;
    header.layer.borderWidth = 3;
    header.layer.borderColor = [UIColor tn_themeColor].CGColor;
    [headerView addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80);
        make.center.mas_equalTo(headerView);
    }];
    
    UILabel *helloLabel = [[UILabel alloc] init];
    helloLabel.text = @"嗨，欢迎你的到来";
    helloLabel.textColor = [UIColor grayColor];
    [headerView addSubview:helloLabel];
    [helloLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-20);
        make.centerX.mas_equalTo(headerView);
        
    }];
    
    _tnTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -TNStatusBarHeight, TNScreenWidth, TNScreenHeight - TNTabBarHeight + TNStatusBarHeight) style:UITableViewStyleGrouped];
    _tnTableView.delegate = self;
    _tnTableView.dataSource = self;
    _tnTableView.tableHeaderView = headerView;
    [self.view addSubview:_tnTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.sourceArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.sourceArray[indexPath.row]];
    if (indexPath.row == self.sourceArray.count - 1){//
        cell.detailTextLabel.text = [NSString stringWithFormat:@"v%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            TNOrderAddViewController *addVC = [[TNOrderAddViewController alloc] init];
            TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:addVC];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 1:
        {
            [self makeCall];
        }
            
            break;
        case 2:
            
            break;
        default:
            break;
    }
}

- (void)makeCall {
    //10.0之后好像拨打电话会有两秒的延迟，此方法可以秒打
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10) {
        NSString *phone = [NSString stringWithFormat:@"tel://13773047057"];
        NSURL *url = [NSURL URLWithString:phone];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                NSLog(@"phone success");
            }];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

@end
