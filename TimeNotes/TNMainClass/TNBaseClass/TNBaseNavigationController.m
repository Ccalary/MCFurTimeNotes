//
//  TNBaseNavigationController.m
//  TimeNotes
//
//  Created by caohouhong on 2018/7/25.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "TNBaseNavigationController.h"

@interface TNBaseNavigationController ()

@end

@implementation TNBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO; //设置了之后自动下沉64
    self.navigationBar.barTintColor = [UIColor tn_themeColor];
    self.navigationBar.tintColor = [UIColor whiteColor]; // 左右颜色
    // 中间title颜色
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                 NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.viewControllers count] > 0){
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(tn_back)];
        viewController.navigationItem.leftBarButtonItem = backItem;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)tn_back{
    [self popViewControllerAnimated:YES];
}

@end
