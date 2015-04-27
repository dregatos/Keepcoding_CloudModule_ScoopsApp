//
//  AzureManager.m
//  ScoopsApp
//
//  Created by David Regatos on 26/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGAzureManager.h"

NSString * const AZURE_MOBILESERVICE_URL = @"https://scoopsmobileservice.azure-mobile.net/";
NSString * const AZURE_MOBILESERVICE_APPKEY = @"ApdmhWVKozUMmeeUabiSigayAsRswz24";
NSString * const userIDKey = @"userID";
NSString * const tokenFBKey = @"tokenFB";

@interface DRGAzureManager ()

@property (nonatomic, readwrite) MSClient *client;

@end

@implementation DRGAzureManager

//@synthesize currentUser = _currentUser;

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

//- (MSUser *)currentUser {
//    return self.client.currentUser;
//}
//
//- (void)setCurrentUser:(MSUser *)currentUser {
//    _currentUser = currentUser;
//    self.client.currentUser = currentUser;
//}

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
    self.client = nil;
    [self saveAuthInfo];
}

- (void)saveAuthInfo {
    
    [[NSUserDefaults standardUserDefaults]setObject:self.client.currentUser.userId
                                             forKey:userIDKey];
    [[NSUserDefaults standardUserDefaults]setObject:self.client.currentUser.mobileServiceAuthenticationToken
                                             forKey:tokenFBKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
