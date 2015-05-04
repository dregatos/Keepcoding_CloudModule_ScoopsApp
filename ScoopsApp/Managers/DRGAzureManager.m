//
//  AzureManager.m
//  ScoopsApp
//
//  Created by David Regatos on 26/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGAzureManager.h"
#import "DRGScoop.h"
#import "DRGUser.h"

NSString * const AZURE_MOBILESERVICE_URL = @"https://scoopsmobileservice.azure-mobile.net/";
NSString * const AZURE_MOBILESERVICE_APPKEY = @"ApdmhWVKozUMmeeUabiSigayAsRswz24";
NSString * const userIDKey = @"userID";
NSString * const tokenFBKey = @"tokenFB";

@interface DRGAzureManager ()

@property (nonatomic, readwrite) MSClient *client;

@end

@implementation DRGAzureManager

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static DRGAzureManager *shared;
    dispatch_once(&once, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

#pragma mark - Properties

- (MSClient *)client  {
    if  (!_client) {
        _client = [MSClient clientWithApplicationURLString:AZURE_MOBILESERVICE_URL
                                            applicationKey:AZURE_MOBILESERVICE_APPKEY];
    }
    
    return _client;
}

#pragma mark - API

- (void)fetchAvailableScoopsWithCompletion:(void(^)(NSArray *result, NSError *error))completionBlock {
    [[DRGAzureManager sharedInstance].client invokeAPI:@"getallpublishedscoops"
                                                  body:nil
                                            HTTPMethod:@"GET"
                                            parameters:nil
                                               headers:nil
                                            completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                                                
                                                NSMutableArray *mArr = [NSMutableArray new];
                                                if ([result isKindOfClass:[NSArray class]]) {
                                                    for (NSDictionary *dic in ((NSArray *)result)) {
                                                        DRGScoop *scoop = [DRGScoop scoopFromDictionary:dic];
                                                        if (scoop) { [mArr addObject:scoop]; }
                                                    }
                                                }
                                                completionBlock([self sortedScoopArrayByPublicationDate:mArr],error);
                                            }];
}

- (void)fetchCurrentUserPublishedWithCompletion:(void(^)(NSArray *result, NSError *error))completionBlock {
    [[DRGAzureManager sharedInstance].client invokeAPI:@"getcurrentuserpublished"
                                                  body:nil
                                            HTTPMethod:@"GET"
                                            parameters:nil
                                               headers:nil
                                            completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                                                
                                                NSMutableArray *mArr = [NSMutableArray new];
                                                if ([result isKindOfClass:[NSArray class]]) {
                                                    for (NSDictionary *dic in ((NSArray *)result)) {
                                                        DRGScoop *scoop = [DRGScoop scoopFromDictionary:dic];
                                                        if (scoop) { [mArr addObject:scoop]; }
                                                    }
                                                }
                                                completionBlock([self sortedScoopArrayByPublicationDate:mArr],error);
                                            }];
}

- (void)fetchCurrentUserUnpublishedWithCompletion:(void(^)(NSArray *result, NSError *error))completionBlock {
    [[DRGAzureManager sharedInstance].client invokeAPI:@"getcurrentuserunpublished"
                                                  body:nil
                                            HTTPMethod:@"GET"
                                            parameters:nil
                                               headers:nil
                                            completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                                                
                                                NSMutableArray *mArr = [NSMutableArray new];
                                                if ([result isKindOfClass:[NSArray class]]) {
                                                    for (NSDictionary *dic in ((NSArray *)result)) {
                                                        DRGScoop *scoop = [DRGScoop scoopFromDictionary:dic];
                                                        if (scoop) { [mArr addObject:scoop]; }
                                                    }
                                                }
                                                completionBlock([self sortedScoopArrayByPublicationDate:mArr],error);
                                            }];
}

- (void)uploadScoop:(DRGScoop *)newScoop
      withCompletion:(void(^)(DRGScoop *scoop, NSError *error))completionBlock {
    
    MSTable *news = [[DRGAzureManager sharedInstance].client tableWithName:@"scoops"];
    [news insert:[DRGScoop dictionaryFromScoop:newScoop]
      completion:^(NSDictionary *item, NSError *error) {
          DRGScoop *scoop = [DRGScoop scoopFromDictionary:item];
          completionBlock(scoop, error);
      }];
}

- (void)updateScoop:(DRGScoop *)updatedScoop
      withCompletion:(void(^)(DRGScoop *scoop, NSError *error))completionBlock {
    
    MSTable *news = [[DRGAzureManager sharedInstance].client tableWithName:@"scoops"];
    [news update:[DRGScoop dictionaryFromScoop:updatedScoop]
      completion:^(NSDictionary *item, NSError *error) {
          DRGScoop *scoop = [DRGScoop scoopFromDictionary:item];
          completionBlock(scoop, error);
      }];
}

- (void)fetchCurrentUserInfoWithCompletion:(void(^)(DRGUser *user, NSError *error))completionBlock {
    [[DRGAzureManager sharedInstance].client invokeAPI:@"getCurrentUserInfo"
                                                  body:nil
                                            HTTPMethod:@"GET"
                                            parameters:nil
                                               headers:nil
                                            completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                                                DRGUser *user = [DRGUser userFromFacebook:result];
                                                completionBlock(user,error);
                                            }];
}

#pragma mark - User persistance

- (BOOL)loadUserAuthInfo {
    
    NSString *userFBId = [[NSUserDefaults standardUserDefaults] objectForKey:userIDKey];
    NSString *tokenFB = [[NSUserDefaults standardUserDefaults] objectForKey:tokenFBKey];
    
    if (userFBId) {
        MSUser *user = [[MSUser alloc]initWithUserId:userFBId];
        user.mobileServiceAuthenticationToken = tokenFB;
        self.client.currentUser = user;
        
        return TRUE;
    }
    
    return FALSE;
}

- (void)resetAuthInfo {

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:userIDKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:tokenFBKey];

    for (NSHTTPCookie *value in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:value];
    }
}

- (void)saveAuthInfo {
    
    [[NSUserDefaults standardUserDefaults]setObject:self.client.currentUser.userId
                                             forKey:userIDKey];
    [[NSUserDefaults standardUserDefaults]setObject:self.client.currentUser.mobileServiceAuthenticationToken
                                             forKey:tokenFBKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - Utils

- (NSArray *)sortedScoopArrayByPublicationDate:(NSMutableArray *)scoopArr {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    NSArray *orderedArray = [scoopArr sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    return orderedArray;
}


@end
