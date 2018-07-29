//
//  TNLocalNotification.m
//  TimeNotes
//
//  Created by caohouhong on 2018/7/27.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "TNLocalNotification.h"
#import <UserNotifications/UserNotifications.h>

@implementation TNLocalNotification
// 注册本地通知
+ (void)registerNotificationWithTitle:(NSString *)titleStr content:(NSString *)contentStr notiID:(NSString *)notiId startDate:(NSDate *)date repeats:(BOOL)repeats{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:titleStr arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:contentStr arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    NSTimeInterval time = [date timeIntervalSinceNow]; // 多少秒后
    if (time < 60){
        return;
    }
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:time repeats:repeats];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:notiId content:content trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
        NSLog(@"成功添加推送ID:%@",notiId);
    }];
    
}

// 移除本地通知
+ (void)removeLocalNotificationWithID:(NSString *)notiId {
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        for (UNNotificationRequest *req in requests){
            NSLog(@"存在的ID:%@\n",req.identifier);
        }
       NSLog(@"移除currentID:%@",notiId);
    }];
    
    [center removePendingNotificationRequestsWithIdentifiers:@[notiId]];
}

// 移除所有
+ (void)removeAllNotification {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllPendingNotificationRequests];
}


+ (void)checkUserNotificationEnable { // 判断用户是否允许接收通知
    __block BOOL isOn = NO;
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.notificationCenterSetting == UNNotificationSettingEnabled) {
            isOn = YES;
            NSLog(@"打开了通知");
        }else {
            isOn = NO;
            NSLog(@"关闭了通知");
        }
    }];
}

// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改  iOS版本 >=8.0 处理逻辑
+ (void)goToAppSystemSetting {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:url options:@{} completionHandler:nil];
        }
    }
}

@end
