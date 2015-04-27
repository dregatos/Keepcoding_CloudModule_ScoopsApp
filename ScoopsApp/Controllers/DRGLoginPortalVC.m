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
                                                        
                                                        if (error) {
                                                            NSLog(@"Error en el login : %@", error);

                                                        } else {
                                                            NSLog(@"user -> %@", user);
                                                            if (user) {
                                                                [DRGAzureManager sharedInstance].client.currentUser = user;
                                                                [[DRGAzureManager sharedInstance] saveAuthInfo];
                                                                [self presentMainStoryboard];
                                                                return;
                                                            }
                                                        }
                                                        
                                                        // Be sure to dismiss login VC
                                                        [self dismissViewControllerAnimated:YES completion:nil];
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
