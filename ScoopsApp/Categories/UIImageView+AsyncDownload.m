//
//  UIImageView+AsyncDownload.m
//  ScoopsApp
//
//  Created by David Regatos on 27/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "UIImageView+AsyncDownload.h"

@implementation UIImageView (AsyncDownload)

- (void)asyncDownloadFromURL:(NSURL *)url {
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.hidesWhenStopped = YES;
    activityView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self addSubview:activityView];
    [activityView startAnimating];
    
    //download the image in background
    dispatch_queue_t download = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(download, ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //set UIImageView image
            UIImage *image = [UIImage imageWithData:imageData];
            self.image = image;
            [activityView stopAnimating];
            [activityView removeFromSuperview];
        });
    });
}

@end
