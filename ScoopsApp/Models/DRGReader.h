//
//  DRGReader.h
//  ScoopsApp
//
//  Created by David Regatos on 27/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import Foundation;

@interface DRGReader : NSObject

@property (nonatomic, copy) NSString *fbID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSURL *pictureURL;

+ (instancetype)readerFromFacebook:(NSDictionary *)fbDic;

- (instancetype)initReaderFromFacebook:(NSDictionary *)fbDic;

@end
