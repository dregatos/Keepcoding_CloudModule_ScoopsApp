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

@end
