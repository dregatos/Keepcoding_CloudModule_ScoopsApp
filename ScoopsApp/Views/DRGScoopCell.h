//
//  DRGScoopCell.h
//  ScoopsApp
//
//  Created by David Regatos on 27/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import UIKit;

@class DRGScoop;

@interface DRGScoopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *headlineLbl;
@property (weak, nonatomic) IBOutlet UILabel *authorLbl;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLbl;

+ (CGFloat)height;
+ (NSString *)cellId;

- (void)configure:(DRGScoop *)scoop;

@end
