//
//  DRGReader.m
//  ScoopsApp
//
//  Created by David Regatos on 27/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGReader.h"

@implementation DRGReader

#pragma mark - Init

+ (instancetype)readerFromFacebook:(NSDictionary *)fbDic {
    return [[self alloc] initReaderFromFacebook:fbDic];
}

- (instancetype)initReaderFromFacebook:(NSDictionary *)fbDic {
    
    if (self = [super init]) {
        _fbID = fbDic[@"id"] ? fbDic[@"id"] : @"";
        _name = fbDic[@"name"] ? fbDic[@"name"] : @"";
        _email = fbDic[@"email"] ? fbDic[@"email"] : @"";
        _gender = fbDic[@"gender"] ? fbDic[@"gender"] : @"";
        // picture url
        NSString *pictureURLStr = fbDic[@"picture"][@"data"][@"url"];
        if (pictureURLStr && ![pictureURLStr isEqualToString:@""]) {
            _pictureURL = [NSURL URLWithString:pictureURLStr];
        }
    }
    
    return self;
}

#pragma mark - Overwritten

- (NSString *)description {
    return [NSString stringWithFormat:@"\n<**** %@ ****\n fbID: %@\n name: %@\n gender: %@\n email: %@\n pictureURL: %@>", [self class], self.fbID, self.name, self.gender, self.email, self.pictureURL.absoluteString];
}

- (BOOL)isEqual:(id)object {
    
    if ([object isKindOfClass:[DRGReader class]]) {
        return [self.fbID isEqualToString:((DRGReader *)object).fbID];
    }
    
    return [super isEqual:object];
}

- (NSUInteger)hash {
    return [_fbID hash] ^ [_name hash];
}

@end
