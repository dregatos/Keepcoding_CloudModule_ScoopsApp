//
//  NSString+Validation.m
//  HackerBooks2
//
//  Created by David Regatos on 17/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

+ (BOOL)isEmpty:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return value == nil || value == (id)[NSNull null] || [value isEqualToString:@""] ||
    ([value respondsToSelector:@selector(length)] && [value length] == 0);
}

@end
