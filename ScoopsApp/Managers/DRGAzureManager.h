//
//  AzureManager.h
//  ScoopsApp
//
//  Created by David Regatos on 26/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import Foundation;

@class DRGScoop;
@class DRGUser;

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

#pragma mark - Connection

- (void)fetchCurrentUserInfoWithCompletion:(void(^)(DRGUser *user, NSError *error))completionBlock;

- (void)fetchAllPublishedScoopsWithCompletion:(void(^)(NSArray *result, NSError *error))completionBlock;

- (void)fetchScoopWithID:(NSString *)scoopID withCompletion:(void(^)(DRGScoop *scoop, NSError *error))completionBlock;

- (void)fetchMyPublishedScoopsWithCompletion:(void(^)(NSArray *result, NSError *error))completionBlock;

- (void)fetchMyUnPublishedScoopsWithCompletion:(void(^)(NSArray *result, NSError *error))completionBlock;

- (void)insertScoop:(DRGScoop *)newScoop
     withCompletion:(void(^)(DRGScoop *scoop, NSError *error))completionBlock;

- (void)updateScoop:(DRGScoop *)updatedScoop
     withCompletion:(void(^)(DRGScoop *scoop, NSError *error))completionBlock;

// Blobs
- (void)uploadImage:(UIImage *)anImage
           forScoop:(DRGScoop *)aScoop
     withCompletion:(void(^)(BOOL success, DRGScoop *scoop, NSError *error))completionBlock;

- (void)downloadImageForScoop:(DRGScoop *)aScoop
               withCompletion:(void(^)(UIImage *image, NSError *error))completionBlock;

#pragma mark - Persistance

- (BOOL)loadUserAuthInfo;
- (void)saveAuthInfo;
- (void)resetAuthInfo;

@end
