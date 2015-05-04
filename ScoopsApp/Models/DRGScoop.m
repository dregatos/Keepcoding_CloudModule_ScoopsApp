//
//  DRGScoop.m
//  ScoopsApp
//
//  Created by David Regatos on 27/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGScoop.h"
#import "NSString+Validation.h"

// JSON
#define ID          @"id"
#define HEADLINE    @"headline"
#define LEAD        @"lead"
#define BODY        @"body"
#define AUTHORID    @"authorId"
#define AUTHORNAME  @"authorname"
#define CREATEDAT   @"__createdAt"
#define PUBLISHED   @"published"

@interface DRGScoop ()

@property (nonatomic, readwrite) NSString *authorId;

@end

@implementation DRGScoop

#pragma mark - JSON

+ (NSDictionary *)dictionaryFromScoop:(DRGScoop *)scoop {
    return @{ID:scoop.scoopID ? scoop.scoopID : @"",
             HEADLINE:scoop.headline ? scoop.headline : @"",
             LEAD:scoop.lead ? scoop.lead : @"",
             BODY:scoop.body ? scoop.body : @"",
             AUTHORID:scoop.authorId ? scoop.authorId : @"",
             AUTHORNAME:scoop.authorName ? scoop.authorName : @"",
             PUBLISHED:[NSNumber numberWithBool:scoop.isPublished]};
}

+ (instancetype)scoopFromDictionary:(NSDictionary *)dict {
    return [[self alloc] initFromDictionary:dict];
}

- (instancetype)initFromDictionary:(NSDictionary *)dict {
    
    if (self = [super init]) {
        _scoopID = dict[ID] ? dict[ID] : @"";
        _headline = dict[HEADLINE] ? dict[HEADLINE] : @"";
        _lead = dict[LEAD] ? dict[LEAD] : @"";
        _body = dict[BODY] ? dict[BODY] : @"";
        _authorId = dict[AUTHORID] ? dict[AUTHORID] : @"";
        _authorName = dict[AUTHORNAME] ? dict[AUTHORNAME] : @"";
        _published = [dict[PUBLISHED] integerValue] == 1 ? YES : NO;
        _createdAt = dict[CREATEDAT]; // ? dict[CREATEDAT] : @"";
    }
    
    return self;
}

#pragma mark - Init

+ (instancetype)scoopWithHeadline:(NSString *)headline
                             lead:(NSString *)lead
                             body:(NSString *)body
                       authorName:(NSString *)authorName {
    
    return  [[self alloc] initWithHeadline:headline
                                      lead:lead
                                      body:body
                                  authorId:@""
                                authorName:authorName
                                 published:NO];
}

- (instancetype)initWithHeadline:(NSString *)headline
                            lead:(NSString *)lead
                            body:(NSString *)body
                        authorId:(NSString *)authorId
                      authorName:(NSString *)authorName
                       published:(BOOL)published {
    
    if (self = [super init]) {
        _headline = headline;
        _lead = lead;
        _body = body;
        _authorId = authorId;
        _authorName = authorName;
        _published = published;
    }
    
    return self;
}

@end
