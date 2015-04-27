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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

#pragma mark - IBActions

- (IBAction)logInViaFacebook:(UIButton *)sender {
    
    [self loginAppInViewController:self withCompletion:^(MSUser *user, NSError *error) {
        
        if (error) {
            NSLog(@"Error -->> %@", error.localizedDescription);
            // TO DO: show error
            return;
        }
        
        NSLog(@"Resultados ---> %@", user);
        if (user) {
            [DRGAzureManager sharedInstance].client.currentUser = user;
            [[DRGAzureManager sharedInstance] saveAuthInfo];
            [self presentMainStoryboard];
        }
    }];
}

#pragma mark - Login

- (void)loginAppInViewController:(UIViewController *)controller
                  withCompletion:(void(^)(MSUser *user, NSError *error))completionBlock {
    
    [[DRGAzureManager sharedInstance].client loginWithProvider:@"facebook"
                                                    controller:controller
                                                      animated:YES
                                                    completion:^(MSUser *user, NSError *error) {
                                                        
                                                        if (error) {
                                                            NSLog(@"Error en el login : %@", error);
                                                            completionBlock(nil,error);
                                                        } else {
                                                            NSLog(@"user -> %@", user);
                                                            completionBlock(user,nil);
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
