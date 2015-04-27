//
//  DRGScoopsVC.m
//  ScoopsApp
//
//  Created by David Regatos on 27/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGScoopsVC.h"
#import "DRGAzureManager.h"
#import "DRGReader.h"
#import "UIImageView+AsyncDownload.h"

@interface DRGScoopsVC ()

@property (nonatomic, strong) DRGReader *reader;

@end

@implementation DRGScoopsVC

- (void)setReader:(DRGReader *)reader {
    _reader = reader;
    
    self.userNameLbl.text = reader.name;
    [self.userImageView asyncDownloadFromURL:reader.pictureURL];
}

#pragma mark - view events

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchCurrentUserInfo];
}

#pragma mark - IBActions

- (IBAction)logOut:(UIButton *)sender {
    [[DRGAzureManager sharedInstance].client logout];
    [[DRGAzureManager sharedInstance] resetAuthInfo];
    [self presentLoginStoryboard];
}

#pragma mark - API

- (void)fetchCurrentUserInfo {
    [[DRGAzureManager sharedInstance].client invokeAPI:@"getCurrentUserInfo"
                                                  body:nil
                                            HTTPMethod:@"GET"
                                            parameters:nil
                                               headers:nil
                                            completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                                                
                                                if (error) {
                                                    NSLog(@"Error -->> %@", error.localizedDescription);
                                                }
                                                
                                                NSLog(@"getCurrentUserInfo ->> %@", result);
                                                self.reader = [DRGReader readerFromFacebook:result];
                                                NSLog(@"Reader -->> %@", self.reader);
                                                
                                            }];
}

#pragma mark - Navigation

- (void)presentLoginStoryboard {
    // Log in success
    UIViewController *nextVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
    nextVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nextVC animated:YES completion:nil];
}


@end
