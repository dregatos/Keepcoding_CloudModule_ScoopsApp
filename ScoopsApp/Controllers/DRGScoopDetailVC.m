//
//  DRGScoopDetailVC.m
//  ScoopsApp
//
//  Created by David Regatos on 04/05/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGScoopDetailVC.h"
#import "DRGScoop.h"
#import "DRGThemeManager.h"

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
    
    self.view.backgroundColor = [DRGThemeManager colorOfType:ThemeColorType_LightGreen];
    
    UIBarButtonItem *likeBtn = [[UIBarButtonItem alloc] initWithTitle:@"Like" style:UIBarButtonItemStylePlain target:self action:@selector(likeBtnPressed:)];
    self.navigationItem.rightBarButtonItem = likeBtn;
    
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
    self.photoView.image = self.scoop.photo;
    self.headlineLbl.text = self.scoop.headline;
    self.scoopTextView.text = [NSString stringWithFormat:@"%@\n\n%@", self.scoop.lead, self.scoop.body];
}

- (void)updateScrollViewLayout {
//    CGFloat calculatedHeight = [self heightThatFitSizeOfContent:self.headlineLbl] + [self heightThatFitSizeOfContent:self.scoopTextView] + 100;
//    
//    self.heightContentViewConstrain.constant = calculatedHeight > self.view.bounds.size.height ? calculatedHeight : self.view.bounds.size.height;
    
//    NSLog(@"heightHeadlineConstrain: %f",self.heightHeadlineConstrain.constant);
    self.heightHeadlineConstrain.constant = [self heightThatFitSizeOfContent:self.headlineLbl];
//    NSLog(@"heightScoopTextConstrain: %f",self.heightScoopTextConstrain.constant);
    self.heightScoopTextConstrain.constant = [self heightThatFitSizeOfContent:self.scoopTextView];
    
//    NSLog(@"NEW heightHeadlineConstrain: %f",self.heightHeadlineConstrain.constant);
//    NSLog(@"NEW heightScoopTextConstrain: %f",self.heightScoopTextConstrain.constant);

    [self.view needsUpdateConstraints];
}

#pragma mark - IBActions

- (IBAction)likeBtnPressed:(id)sender {
    [self showAlertWithMessage:@"Under construction"];
}

#pragma mark - Helpers

- (CGFloat)heightThatFitSizeOfContent:(UIView *)myView {
    CGSize viewSize = [myView sizeThatFits:myView.bounds.size];
    
    return viewSize.height;
}

#pragma mark - Alert controller

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"OK"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action) {
                                                      [alert dismissViewControllerAnimated:YES completion:nil];
                                                  }];
    [alert addAction:okBtn];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
