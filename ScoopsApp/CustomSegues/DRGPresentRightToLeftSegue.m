//
//  DRPresentRightToLeftSegue.m
//  EdCoApp
//
//  Created by David Regatos on 15/09/14.
//  Copyright (c) 2014 edCo. All rights reserved.
//

#import "DRGPresentRightToLeftSegue.h"

@implementation DRGPresentRightToLeftSegue

- (void)perform {
    
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    
    // Add the destination view as a subview, temporarily
    [sourceViewController.view addSubview:destinationViewController.view];
    
    // Transformation start traslation
    destinationViewController.view.transform = CGAffineTransformMakeTranslation(sourceViewController.view.bounds.size.width, 0);
    
    
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // Move!
                         destinationViewController.view.transform = CGAffineTransformMakeTranslation(0., 0.);
                     }
                     completion:^(BOOL finished){
                         [destinationViewController.view removeFromSuperview]; // remove from temp super view
                         [sourceViewController presentViewController:destinationViewController animated:NO completion:NULL]; // present VC
                     }];
}

@end
