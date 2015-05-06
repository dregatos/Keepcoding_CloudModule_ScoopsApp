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

// Unmutable
@property (nonatomic, readonly) NSString *scoopID;
@property (nonatomic, readonly) NSString *authorId;
@property (nonatomic, readonly) CLLocationCoordinate2D location;
@property (nonatomic, readonly) NSDate *createdAt;

@property (nonatomic, copy) NSString *headline;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *authorName;

@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) NSData *photoData;            // not used
@property (nonatomic, strong) UIImage *photo;               

@property (nonatomic, strong) NSURL *photoThumbnailURL;
@property (nonatomic, strong) NSData *photoThumbnailData;   // not used
@property (nonatomic, strong) UIImage *photoThumbnail;      // not used

@property (nonatomic, getter = isPublished) BOOL published;

#pragma mark - JSON

+ (NSDictionary *)dictionaryFromScoop:(DRGScoop *)scoop;

+ (instancetype)scoopFromDictionary:(NSDictionary *)dict;

- (instancetype)initFromDictionary:(NSDictionary *)dict;

#pragma mark - Init

+ (instancetype)scoopWithHeadline:(NSString *)headline
                             lead:(NSString *)lead
                             body:(NSString *)body
                       authorName:(NSString *)authorName;

- (instancetype)initWithHeadline:(NSString *)headline
                            lead:(NSString *)lead
                            body:(NSString *)body
                        authorId:(NSString *)authorId
                      authorName:(NSString *)authorName
                       published:(BOOL)published;

@end
