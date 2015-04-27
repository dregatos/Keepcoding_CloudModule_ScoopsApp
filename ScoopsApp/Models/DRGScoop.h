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

@property (nonatomic, copy) NSString *headline;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *author;

@property (nonatomic, readonly) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSDate *createdAt;

@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) NSData *photoData;

- (instancetype)initWithHeadline:(NSString *)headline
                            lead:(NSString *)lead
                            body:(NSString *)body
                          author:(NSString *)author
                            date:(NSDate *)createdAt
                        andPhoto:(UIImage *)photo;

@end
