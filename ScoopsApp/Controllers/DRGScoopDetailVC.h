//
//  DRGScoopDetailVC.h
//  ScoopsApp
//
//  Created by David Regatos on 04/05/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import UIKit;

@class DRGScoop;

@interface DRGScoopDetailVC : UIViewController

@property (nonatomic, strong) DRGScoop *scoop;

// IBOutles
@property (weak, nonatomic) IBOutlet UILabel *headlineLbl;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLbl;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLbl;
@property (weak, nonatomic) IBOutlet UITextView *scoopTextView;

//Autolayout
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightScoopTextConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightHeadlineConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContentViewConstrain;

@end
