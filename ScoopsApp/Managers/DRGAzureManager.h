//
//  AzureManager.h
//  ScoopsApp
//
//  Created by David Regatos on 26/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import Foundation;

#import "AzureKeys.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

extern NSString * const AZURE_MOBILESERVICE_URL;
extern NSString * const AZURE_MOBILESERVICE_APPKEY;

typedef void (^profileCompletion)(NSDictionary* profInfo);
typedef void (^completeBlock)(NSArray* results);
typedef void (^completeOnError)(NSError *error);
typedef void (^completionWithURL)(NSURL *theUrl, NSError *error);

@interface DRGAzureManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) MSClient *client;

- (BOOL)loadUserAuthInfo;
- (void)saveAuthInfo;
- (void)resetAuthInfo;

@end
