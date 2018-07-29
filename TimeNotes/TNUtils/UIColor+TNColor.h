//
//  UIColor+TNColor.h
//  TimeNotes
//
//  Created by caohouhong on 2018/7/24.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (TNColor)
+ (UIColor *)tn_themeColor;
+ (UIColor *)tn_backgroundColor;
+ (UIColor *)tn_colorWithHex:(NSInteger)hex;
+ (UIColor *)tnColorWithColorType:(int)type;
@end
