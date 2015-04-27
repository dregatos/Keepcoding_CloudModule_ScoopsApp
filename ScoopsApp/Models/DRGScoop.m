//
//  DRGScoop.m
//  ScoopsApp
//
//  Created by David Regatos on 27/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGScoop.h"

@implementation DRGScoop

- (instancetype)initWithHeadline:(NSString *)headline
                            lead:(NSString *)lead
                            body:(NSString *)body
                          author:(NSString *)author
                            date:(NSDate *)createdAt
                        andPhoto:(UIImage *)photo {
    
    if (self = [super init]) {
        _headline = headline;
        _lead = lead;
        _body = body;
        _author = author;
        _createdAt = createdAt;
        _photo = photo;
    }
    
    return self;
}
@end
