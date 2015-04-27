//
//  DRGScoopCell.m
//  ScoopsApp
//
//  Created by David Regatos on 27/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGScoopCell.h"
#import "DRGScoop.h"
#import "UIImageView+AsyncDownload.h"

@class DRGScoop;

@implementation DRGScoopCell

+ (CGFloat) height {
    return 90;
}

+ (NSString *)cellId {
    return NSStringFromClass(self);
}

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
    self.photoImageView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoImageView.clipsToBounds = YES;
    
    self.headlineLbl.numberOfLines = 2;
}

- (void)prepareForReuse{
    self.photoImageView.image = nil;
    self.headlineLbl.text = @"";
    self.createdAtLbl.text = @"";
}

- (void)configure:(DRGScoop *)scoop {
    self.headlineLbl.text = scoop.headline;
    self.authorLbl.text = scoop.author;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    self.createdAtLbl.text = [formatter stringFromDate:scoop.createdAt];
    
//    [self.photoImageView asyncDownloadFromURL:scoop.photoURL];
    self.photoImageView.image = scoop.photo;
}

@end
