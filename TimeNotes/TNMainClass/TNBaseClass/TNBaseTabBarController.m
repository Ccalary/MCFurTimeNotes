//
//  TNBaseTabBarController.m
//  TimeNotes
//
//  Created by caohouhong on 2018/7/25.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "TNBaseTabBarController.h"
#import "TNBaseNavigationController.h"
#import "TNMainViewController.h"
#import "TNUsercenterViewController.h"
#import "TNOrderViewController.h"

@interface TNBaseTabBarController ()

@end

@implementation TNBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UITabBar appearance].tintColor = [UIColor tn_themeColor];
    [self tn_addChildViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tn_addChildViewControllers{
    
    [self tn_addChildrenVC:[[TNMainViewController alloc] init] title:@"首页" tabImageName:@"t_main" ];
    [self tn_addChildrenVC:[[TNOrderViewController alloc] init] title:@"预约" tabImageName:@"t_clock"];
    [self tn_addChildrenVC:[[TNUsercenterViewController alloc] init] title:@"个人中心" tabImageName:@"t_usercenter"];
}

- (void)tn_addChildrenVC:(UIViewController *)childVC title:(NSString *)title tabImageName:(NSString *)imageName{
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    childVC.tabBarItem.selectedImage =  [UIImage imageNamed:imageName];
    childVC.title = title;
    TNBaseNavigationController *baseNavigationController = [[TNBaseNavigationController alloc] initWithRootViewController:childVC];
    
    [self addChildViewController:baseNavigationController];
}

@end
