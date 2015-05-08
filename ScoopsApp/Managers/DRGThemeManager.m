//
//  DRGThemeManager.m
//  ScoopsApp
//
//  Created by David Regatos on 08/05/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGThemeManager.h"

@import UIKit.UIColor;
@import UIKit.UIFont;


@implementation DRGThemeManager

#pragma mark - Colors

+ (UIColor *)colorOfType:(ThemeColorType)type {
    UIColor *color = nil;
    switch (type) {
        case ThemeColorType_BlueFacebook:
            color = [UIColor colorWithRed:37./255.0 green:57./255.0 blue:129./255.0 alpha:1.0];
            break;
        case ThemeColorType_BrownBackground:
            color = [UIColor colorWithRed:221./255.0 green:209./255.0 blue:199./255.0 alpha:1.0];
            break;
        case ThemeColorType_LightGreen:
            color = [UIColor colorWithRed:194./255.0 green:207./255.0 blue:178./255.0 alpha:1.0];
            break;
        case ThemeColorType_NormalGreen:
            color = [UIColor colorWithRed:141./255.0 green:181./255.0 blue:128./255.0 alpha:1.0];
            break;
        case ThemeColorType_DarkGreen:
            color = [UIColor colorWithRed:126./255.0 green:137./255.0 blue:135./255.0 alpha:1.0];
            break;
        default:
            color = [UIColor blackColor];
            break;
    }
    return color;
}

+ (UIFont *)defaultFontType:(ThemeFontType)type withSize:(float)fontSize {
    UIFont *font = nil;
    switch (type) {
        case ThemeFontType_Logo:
            font = [UIFont fontWithName:@"Noteworthy-Bold" size:fontSize];
            break;
        case ThemeFontType_Normal:
            font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
            break;
        default:
            font = [UIFont systemFontOfSize:fontSize];
            break;
    }
    return font;
}

@end
