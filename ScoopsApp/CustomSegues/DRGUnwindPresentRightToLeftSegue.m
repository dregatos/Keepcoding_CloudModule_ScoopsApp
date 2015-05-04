//
//  EDUnwindPresentRightToLeftSegue.m
//  EdCoApp
//
//  Created by David Regatos on 15/09/14.
//  Copyright (c) 2014 edCo. All rights reserved.
//

#import "DRGUnwindPresentRightToLeftSegue.h"

@implementation DRGUnwindPresentRightToLeftSegue

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    
    // Add view to super view temporarily
    [sourceViewController.view.superview insertSubview:destinationViewController.view atIndex:0];
    
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // Move back!
                         sourceViewController.view.transform = CGAffineTransformMakeTranslation(sourceViewController.view.bounds.size.width, 0);
                     }
                     completion:^(BOOL finished){
                         [destinationViewController.view removeFromSuperview]; // remove from temp super view
                         [sourceViewController dismissViewControllerAnimated:NO completion:NULL]; // dismiss VC
                     }];
}

@end
