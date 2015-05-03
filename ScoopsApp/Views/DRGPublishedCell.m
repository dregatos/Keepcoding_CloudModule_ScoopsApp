//
//  DRGScoopCell.m
//  ScoopsApp
//
//  Created by David Regatos on 27/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGPublishedCell.h"
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
    
//    [self.photoImageView asyncDownloadFromURL:[NSURL URLWithString:@"http://www.zastavki.com/pictures/1920x1200/2011/Space_Huge_explosion_031412_.jpg"]];
    self.photoImageView.image = scoop.photo;
}

@end
