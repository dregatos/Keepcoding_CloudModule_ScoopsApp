//
//  NSDictionary+Additions.h
//  EdCoApp
//
//  Created by David Regatos on 27/05/14.
//  Copyright (c) 2014 edCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Additions)

+ (NSDictionary *)catchNSNullValues:(NSDictionary *) dic;

- (NSDictionary *)removeNullValues;
- (id)validatedValueForKey:(NSString *)key;

@end
