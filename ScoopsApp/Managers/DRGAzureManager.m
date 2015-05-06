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

- (void)fetchCurrentUserInfoWithCompletion:(void(^)(DRGUser *user, NSError *error))completionBlock {
    [[DRGAzureManager sharedInstance].client invokeAPI:AZURE_API_GET_USER
                                                  body:nil
                                            HTTPMethod:@"GET"
                                            parameters:nil
                                               headers:nil
                                            completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                                                DRGUser *user = [DRGUser userFromFacebook:result];
                                                completionBlock(user,error);
                                            }];
}

- (void)fetchFullInfoOfAvailableScoopsWithCompletion:(void(^)(NSArray *result, NSError *error))completionBlock {
    
    [[DRGAzureManager sharedInstance].client invokeAPI:AZURE_API_GET_SCOOPS
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

- (void)fetchBasicInfoOfAvailableScoopsWithCompletion:(void(^)(NSArray *result, NSError *error))completionBlock {
    
    NSDictionary *parameters = @{@"info" : @"basic"};
    
    [[DRGAzureManager sharedInstance].client invokeAPI:AZURE_API_GET_SCOOPS
                                                  body:nil
                                            HTTPMethod:@"GET"
                                            parameters:parameters
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

- (void)fetchScoop:(DRGScoop *)scoop withCompletion:(void(^)(DRGScoop *scoop, NSError *error))completionBlock {
    
    NSDictionary *parameters = @{@"scoopID" : scoop.scoopID};

    [[DRGAzureManager sharedInstance].client invokeAPI:AZURE_API_GET_SCOOPS
                                                  body:nil
                                            HTTPMethod:@"GET"
                                            parameters:parameters
                                               headers:nil
                                            completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                                                
                                                NSMutableArray *mArr = [NSMutableArray new];
                                                if ([result isKindOfClass:[NSArray class]]) {
                                                    for (NSDictionary *dic in ((NSArray *)result)) {
                                                        DRGScoop *scoop = [DRGScoop scoopFromDictionary:dic];
                                                        if (scoop) { [mArr addObject:scoop]; }
                                                    }
                                                }
                                                
                                                if ([mArr count] > 1) {
                                                    // Error - more than one scoop with same id
                                                    // TODO - create custom error
                                                    completionBlock(nil, error);
                                                }
                                                
                                                completionBlock([mArr firstObject],error);
                                            }];
}

- (void)fetchCurrentUserPublishedWithCompletion:(void(^)(NSArray *result, NSError *error))completionBlock {
    [[DRGAzureManager sharedInstance].client invokeAPI:AZURE_API_GET_USER_PUBLISHED
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
    [[DRGAzureManager sharedInstance].client invokeAPI:AZURE_API_GET_USER_UNPUBLISHED
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

- (void)insertScoop:(DRGScoop *)newScoop
     withCompletion:(void(^)(DRGScoop *scoop, NSError *error))completionBlock {
    
    MSTable *news = [[DRGAzureManager sharedInstance].client tableWithName:@"scoops"];
    NSDictionary *dic = [DRGScoop dictionaryFromScoop:newScoop];
    NSLog(@"Item: %@", dic);
    [news insert:dic
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

#pragma mark - Blobs

- (void)uploadImage:(UIImage *)anImage
           forScoop:(DRGScoop *)aScoop
     withCompletion:(void(^)(BOOL success, DRGScoop *scoop, NSError *error))completionBlock {
    
    // TODO: Check if anImage and aScoop.scoopID exist
    
    NSString *imName = [NSString stringWithFormat:@"%@.jpg", aScoop.scoopID];
    [self requestSasURLForImageNamed:imName withCompletion:^(NSURL *sasURL, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            completionBlock(NO,aScoop,error);
            return;
        }
        
        if (sasURL) {
            // Upload scoop image
            [self handleImageToUploadAzureBlob:sasURL
                                       blobImg:anImage
                          completionUploadTask:^(id result, NSError *error) {
                              
                if (error) {
                    NSLog(@"Error: %@", error.localizedDescription);
                    completionBlock(NO,aScoop,error);
                    return;
                }
                              
                //Update scoop
                DRGScoop *scoopWithSas = aScoop;
                scoopWithSas.photoURL = sasURL;

                [self updateScoop:scoopWithSas withCompletion:^(DRGScoop *scoop, NSError *error) {
                    if (error) {
                        NSLog(@"Error: %@", error.localizedDescription);
                        completionBlock(NO,aScoop,error);
                        return;
                    }
                    
                    aScoop.photoURL = sasURL;
                    completionBlock(YES,scoop,error);
                }];
            }];
            
        } else {
            completionBlock(NO,aScoop,error);
        }
    }];
}

- (void)downloadImageForScoop:(DRGScoop *)aScoop
               withCompletion:(void(^)(UIImage *image, NSError *error))completionBlock {
    
    NSURL *sasURL = aScoop.photoURL;
    
    if (!sasURL) {
        // TODO create not image available error
        completionBlock(nil,nil);
        return;
    }
    
    [self handleSaSURLToDownload:sasURL completionHandleSaS:^(id result, NSError *error) {
        completionBlock(result,error);
    }];
}

- (void)requestSasURLForImageNamed:(NSString *)imageName
                    withCompletion:(void(^)(NSURL *sasURL, NSError *error))completionBlock {
    
    NSDictionary *parameters = @{@"blobName" : imageName};
    
    [self.client invokeAPI:AZURE_API_GET_BLOB_SAS
                 body:nil
           HTTPMethod:@"GET"
           parameters:parameters
              headers:nil
           completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
               
               if (!error) {
                   NSLog(@"resultado --> %@", result);
               }
               
               NSURL *sasURL;
               if (result) {
                   sasURL = [NSURL URLWithString:result[@"sasUrl"]];
               }
               
               completionBlock(sasURL,error);
           }];
}

- (void)handleImageToUploadAzureBlob:(NSURL *)sasURL
                             blobImg:(UIImage *)blobImg
                completionUploadTask:(void (^)(id result, NSError *error))completion {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:sasURL];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    
    NSData *data = UIImageJPEGRepresentation(blobImg, 1.f);
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [[NSURLSession sharedSession] uploadTaskWithRequest:request
                                                            fromData:data
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                       
                                                       if (error) {
                                                           NSLog(@"Error: %@", error.localizedDescription);
                                                       }
                                                       
                                                       NSLog(@"resultado --> %@", response);
                                                       completion(response, error);
                                                   }];
    
    [uploadTask resume];
}

- (void)handleSaSURLToDownload:(NSURL *)sasURL completionHandleSaS:(void (^)(id result, NSError *error))completion {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:sasURL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDownloadTask *downloadTask;
    downloadTask = [[NSURLSession sharedSession]downloadTaskWithRequest:request
                                                      completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                          
                                                          UIImage *image;
                                                          if (!error) {
                                                              NSLog(@"resultado --> %@", response);
                                                              NSData *imData = [NSData dataWithContentsOfURL:location];
                                                              image = [UIImage imageWithData:imData];
                                                          }
                                                          completion(image, error);
                                                      }];
    [downloadTask resume];
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
