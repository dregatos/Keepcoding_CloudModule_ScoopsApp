//
//  NSDictionary+Additions.m
//  EdCoApp
//
//  Created by David Regatos on 27/05/14.
//  Copyright (c) 2014 edCo. All rights reserved.
//

#import "NSDictionary+Additions.h"

@implementation NSDictionary (Additions)

-(NSDictionary *)removeNullValues{
    NSMutableDictionary *mutDictionary = [self mutableCopy];
    NSMutableArray *keysToDelete = [NSMutableArray array];
    [mutDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj == [NSNull null]) {
            [keysToDelete addObject:key];
        }
    }];
    [mutDictionary removeObjectsForKeys:keysToDelete];
    return [mutDictionary copy];
}

- (id)validatedValueForKey:(NSString *)key {
    id value = [self valueForKey:key];
    if (value == [NSNull null]) {
        value = nil;
    }
    return value;
}

+ (NSDictionary *) catchNSNullValues:(NSDictionary *) dic {
    
    NSMutableDictionary *mdic = [[NSMutableDictionary alloc] init];
    for (id key in mdic) {
        if ([mdic[key] isKindOfClass:[NSNull class]]) {
            NSLog(@"Null value catched");
        } else if (!mdic[key]) {
            NSLog(@"Nil obj catched");
        }
    }
    
    return [mdic copy];
}

@end
