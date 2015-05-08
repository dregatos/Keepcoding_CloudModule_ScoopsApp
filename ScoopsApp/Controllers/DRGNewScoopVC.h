//
//  DRGNewScoopVC.h
//  ScoopsApp
//
//  Created by David Regatos on 29/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import UIKit;

@class DRGScoop;
@class DRGUser;

@interface DRGNewScoopVC : UIViewController

@property (nonatomic, strong) DRGScoop *scoop;
@property (nonatomic, strong) DRGUser *user;

// IBOutlets
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIControl *topContainer;
@property (weak, nonatomic) IBOutlet UITextField *authorTextField;
@property (weak, nonatomic) IBOutlet UISwitch *publishSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) IBOutletCollection(UITextView) NSArray *textViewCollection;
@property (weak, nonatomic) IBOutlet UITextView *headlineTextView;
@property (weak, nonatomic) IBOutlet UITextView *leadTextView;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;

// Autolayout
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTopContainerViewConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthHeadlineConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLeadConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightBodyConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightBottomBarConstrain;

@end
