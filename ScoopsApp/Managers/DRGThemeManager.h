//
//  DRGThemeManager.h
//  ScoopsApp
//
//  Created by David Regatos on 08/05/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import Foundation;

@class UIColor;
@class UIFont;

typedef enum ThemeColorType : NSUInteger {
    ThemeColorType_BlueFacebook = 1,
    ThemeColorType_BrownBackground,
    ThemeColorType_LightGreen,
    ThemeColorType_NormalGreen,
    ThemeColorType_DarkGreen

    
} ThemeColorType;

typedef enum ThemeFontType : NSUInteger {
    ThemeFontType_Normal = 1,
    ThemeFontType_Logo,
    
} ThemeFontType;

@interface DRGThemeManager : NSObject

+ (UIColor *)colorOfType:(ThemeColorType)type;
+ (UIFont *)defaultFontType:(ThemeFontType)type withSize:(float)fontSize;

@end

