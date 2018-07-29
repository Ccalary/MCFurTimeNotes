//
//  AppDelegate.h
//  TimeNotes
//
//  Created by caohouhong on 2018/7/24.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

