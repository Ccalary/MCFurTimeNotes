//
//  TNLocalNotification.h
//  TimeNotes
//
//  Created by caohouhong on 2018/7/27.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNLocalNotification : NSObject
// 注册本地通知
+ (void)registerNotificationWithTitle:(NSString *)titleStr content:(NSString *)contentStr notiID:(NSString *)notiId startDate:(NSDate *)date repeats:(BOOL)repeats;
// 移除本地通知
+ (void)removeLocalNotificationWithID:(NSString *)notiId;

// 移除所有
+ (void)removeAllNotification;

+ (void)checkUserNotificationEnable;
@end
