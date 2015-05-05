//
//  DRGScoopDetailVC.m
//  ScoopsApp
//
//  Created by David Regatos on 04/05/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGScoopDetailVC.h"
#import "DRGScoop.h"

@interface DRGScoopDetailVC ()

@end

@implementation DRGScoopDetailVC

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //after nib-loading
}

#pragma mark - view events

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self syncViewAndModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateScrollViewLayout];
}

#pragma mark - Utils

- (void)syncViewAndModel {
    self.authorNameLbl.text = self.scoop.authorName;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    self.createdAtLbl.text = [formatter stringFromDate:self.scoop.createdAt];
    self.headlineLbl.text = self.scoop.headline;
    self.scoopTextView.text = [NSString stringWithFormat:@"%@\n\n%@", self.scoop.lead, self.scoop.body];
}

- (void)updateScrollViewLayout {
//    self.heightHeadlineConstrain.constant = [self heightThatFitSizeOfContent:self.headlineLbl];
//    self.heightScoopTextConstrain.constant = [self heightThatFitSizeOfContent:self.scoopTextView];
    
    CGFloat calculatedHeight = [self heightThatFitSizeOfContent:self.headlineLbl] + [self heightThatFitSizeOfContent:self.scoopTextView] + 100;
    
    self.heightContentViewConstrain.constant = calculatedHeight > self.view.bounds.size.height ? calculatedHeight : self.view.bounds.size.height;
}

- (CGFloat)heightThatFitSizeOfContent:(UIView *)myView {
    CGSize viewSize = [myView sizeThatFits:CGSizeMake(myView.frame.size.width, FLT_MAX)];
    
    return viewSize.height;
}

@end
