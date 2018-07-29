//
//  TNGlobalDefine.h
//  TimeNotes
//
//  Created by caohouhong on 2018/7/24.
//  Copyright © 2018年 caohouhong. All rights reserved.
//


#ifndef TNGlobalDefine_h
#define TNGlobalDefine_h
//大小尺寸（宽、高）
#define TNScreenWidth                     [[UIScreen mainScreen] bounds].size.width
#define TNScreenHeight                    [[UIScreen mainScreen] bounds].size.height
//statusBar高度
#define TNStatusBarHeight                 [UIApplication sharedApplication].statusBarFrame.size.height
//navBar高度
#define TNNavigationBarHeight             [[UINavigationController alloc] init].navigationBar.frame.size.height
//TabBar高度  iPhoneX 高度为83
#define TNTabBarHeight                    ((TNStatusBarHeight > 20.0f) ? 83.0f : 49.0f)
//nav顶部高度
#define TNTopFullHeight                   (TNStatusBarHeight + TNNavigationBarHeight)



#endif /* TNGlobalDefine_h */
