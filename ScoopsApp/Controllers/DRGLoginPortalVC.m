//
//  DRGLoginPortalVC.m
//  ScoopsApp
//
//  Created by David Regatos on 26/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGLoginPortalVC.h"
#import "DRGAzureManager.h"
#import "DRGReader.h"
#import "UIViewController+Alert.h"

@interface DRGLoginPortalVC ()

@end

@implementation DRGLoginPortalVC

#pragma mark - View events

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

#pragma mark - IBActions

- (IBAction)logInViaFacebook:(UIButton *)sender {
    
    [self loginWithProvider:@"facebook"];
}

#pragma mark - Login

- (void)loginWithProvider:(NSString *)provider {
    
    [[DRGAzureManager sharedInstance].client loginWithProvider:provider
                                                    controller:self
                                                      animated:YES
                                                    completion:^(MSUser *user, NSError *error) {
                            
                                                        if (!error && user) {
                                                            NSLog(@"user -> %@", user);
                                                            [[DRGAzureManager sharedInstance] saveAuthInfo];
                                                            [self presentMainStoryboard];
                                                            return;
                                                        }
                                                        
                                                        // Be sure to dismiss login VC
                                                        [self dismissViewControllerAnimated:YES completion:nil];
                                                        
                                                        if (error) {
                                                            NSLog(@"Authentication Error: %@", error);
                                                            [self showAlertWithMessage:error.localizedDescription];
                                                        } else if (!user) {
                                                            [self showAlertWithMessage:@"Unable to get user info."];
                                                        } else {
                                                            [self showAlertWithMessage:@"Unknown error."];
                                                        }
                                                    }];
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)presentMainStoryboard {
    // Log in success
    UIViewController *nextVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    nextVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nextVC animated:YES completion:nil];
}

@end
