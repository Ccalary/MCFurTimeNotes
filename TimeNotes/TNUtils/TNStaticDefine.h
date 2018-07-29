
//
//  TNStaticDefine.h
//  TimeNotes
//
//  Created by caohouhong on 2018/7/28.
//  Copyright © 2018年 caohouhong. All rights reserved.
//
#import <UIKit/UIKit.h>
#ifndef TNStaticDefine_h
#define TNStaticDefine_h

/** Model */
static NSString *const ENTITYNAME_ORDER = @"Order"; // 这里必须是coreData里表的名字
static NSString *const ENTITYNAME_NOTES = @"Notes";

/** Notification */
/** 预约提醒添加成功 */
static NSString *const NOTIFICATION_ADD_ORDER_SUCCESS = @"NOTIFICATION_ADD_ORDER_SUCCESS";

static NSString *const NOTIFICATION_NOTES_CHANGED_SUCCESS = @"NOTIFICATION_NOTES_CHANGED_SUCCESS";

#endif /* TNStaticDefine_h */
