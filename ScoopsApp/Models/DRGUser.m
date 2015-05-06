//
//  DRGReader.m
//  ScoopsApp
//
//  Created by David Regatos on 27/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGUser.h"
#import "NSDictionary+Additions.h"

/* JSON Properties */
#define ID      @"id"
#define NAME    @"name"
#define EMAIL   @"email"
#define GENDER  @"gender"
#define PHOTO1  @"picture"
#define PHOTO2  @"data"
#define PHOTO3  @"url"


@implementation DRGUser

#pragma mark - Init

+ (instancetype)userFromFacebook:(NSDictionary *)fbDic {
    return [[self alloc] initUserFromFacebook:fbDic];
}

- (instancetype)initUserFromFacebook:(NSDictionary *)fbDic {
    
    if (self = [super init]) {
        
        fbDic = [fbDic removeNullValues];

        _fbID = fbDic[ID] ? fbDic[ID] : @"";
        _name = fbDic[NAME] ? fbDic[NAME] : @"";
        _email = fbDic[EMAIL] ? fbDic[EMAIL] : @"";
        _gender = fbDic[GENDER] ? fbDic[GENDER] : @"";
        // picture url
        NSString *pictureURLStr = fbDic[PHOTO1][PHOTO2][PHOTO3];
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
    
    if ([object isKindOfClass:[DRGUser class]]) {
        return [self.fbID isEqualToString:((DRGUser *)object).fbID];
    }
    
    return [super isEqual:object];
}

- (NSUInteger)hash {
    return [_fbID hash] ^ [_name hash];
}

@end
