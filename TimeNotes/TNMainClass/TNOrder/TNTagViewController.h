//
//  TNTagViewController.h
//  TimeNotes
//
//  Created by caohouhong on 2018/7/27.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^textBlock)(NSString *text);
@interface TNTagViewController : UIViewController
@property (nonatomic, copy) textBlock block;
@property (nonatomic, strong) NSString *tagStr;
@end
