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
    activityView.center = self.center;
    [self addSubview:activityView];
    
    //download the image in background
    dispatch_queue_t download = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [activityView startAnimating];
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
