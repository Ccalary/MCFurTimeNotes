//
//  UIColor+TNColor.m
//  TimeNotes
//
//  Created by caohouhong on 2018/7/24.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "UIColor+TNColor.h"

@implementation UIColor (TNColor)
//MARK:- Theme
+ (UIColor *)tn_themeColor{
    return [UIColor tn_colorWithHex:0x34d3d2];
}

+ (UIColor *)tn_backgroundColor{
    return [UIColor tn_colorWithHex:0xf2f2f2];
}

//MARK:- Method
+ (UIColor *)tn_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alpha];
}

+ (UIColor *)tn_colorWithHex:(NSInteger)hex
{
    return [UIColor tn_colorWithHex:hex alpha:1.0];
}

+ (UIColor*)tn_randomColor
{
    return [UIColor colorWithRed:(arc4random()%255)*1.0f/255.0
                           green:(arc4random()%255)*1.0f/255.0
                            blue:(arc4random()%255)*1.0f/255.0 alpha:1.0];
}

+ (UIColor *)tnColorWithColorType:(int)type {
    UIColor *color = [UIColor tn_themeColor];
    switch (type) {
        case 0:
            color = [UIColor tn_colorWithHex:0x22b959];
            break;
        case 1:
            color = [UIColor tn_colorWithHex:0x1a98fc];
            break;
        case 2:
            color = [UIColor tn_colorWithHex:0xf194bc];
            break;
        case 3:
            color = [UIColor tn_colorWithHex:0xb9402e];
            break;
        case 4:
            color = [UIColor tn_colorWithHex:0x7b85fc];
            break;
        case 5:
            color = [UIColor tn_colorWithHex:0xfd9226];
            break;
        case 6:
            color = [UIColor tn_colorWithHex:0x9343fb];
            break;
        default:
            color = [UIColor tn_themeColor];
            break;
    }
    return color;
}
@end
