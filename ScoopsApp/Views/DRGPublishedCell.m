//
//  DRGScoopCell.m
//  ScoopsApp
//
//  Created by David Regatos on 27/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGPublishedCell.h"
#import "DRGAzureManager.h"
#import "DRGScoop.h"
#import "UIImageView+AsyncDownload.h"

@class DRGScoop;

@implementation DRGPublishedCell

+ (CGFloat) height {
    return 120;
}

+ (NSString *)cellId {
    return NSStringFromClass(self);
}

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
    self.photoImageView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoImageView.clipsToBounds = YES;
    
    self.headlineLbl.numberOfLines = 3;
}

- (void)prepareForReuse{
    self.photoImageView.image = nil;
    self.headlineLbl.text = @"";
    self.createdAtLbl.text = @"";
}

- (void)configure:(DRGScoop *)scoop {
    self.headlineLbl.text = scoop.headline;
    self.authorLbl.text = scoop.authorName;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    self.createdAtLbl.text = [formatter stringFromDate:scoop.createdAt];
    
    // Cell image
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.hidesWhenStopped = YES;
    activityView.center = CGPointMake(self.photoImageView.bounds.size.width/2, self.photoImageView.bounds.size.height/2);
    [self.photoImageView addSubview:activityView];
    [activityView startAnimating];
    [[DRGAzureManager sharedInstance] downloadImageForScoop:scoop
                                             withCompletion:^(UIImage *image, NSError *error) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     [activityView stopAnimating];
                                                     scoop.photo = image;
                                                     self.photoImageView.image = image;
                                                 });
                                             }];
}

@end
