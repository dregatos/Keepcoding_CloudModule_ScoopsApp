//
//  DRGScoop.h
//  ScoopsApp
//
//  Created by David Regatos on 27/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import Foundation;
@import UIKit.UIImage;
@import CoreLocation;

@interface DRGScoop : NSObject

@property (nonatomic, copy) NSString *scoopID;      // Assigned by the server after inserting a new scoop
@property (nonatomic, copy) NSString *headline;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, readonly) NSString *authorId;

@property (nonatomic, readonly) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSDate *createdAt;

@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) NSData *photoData;

@property (nonatomic, getter = isPublished) BOOL published;

#pragma mark - JSON

+ (NSDictionary *)dictionaryFromScoop:(DRGScoop *)scoop;

+ (instancetype)scoopFromDictionary:(NSDictionary *)dict;

- (instancetype)initFromDictionary:(NSDictionary *)dict;

#pragma mark - Init

+ (instancetype)scoopWithHeadline:(NSString *)headline
                             lead:(NSString *)lead
                             body:(NSString *)body
                         authorId:(NSString *)authorId
                       authorName:(NSString *)authorName
                        published:(BOOL)published;

- (instancetype)initWithHeadline:(NSString *)headline
                            lead:(NSString *)lead
                            body:(NSString *)body
                        authorId:(NSString *)authorId
                      authorName:(NSString *)authorName
                       published:(BOOL)published;

@end
