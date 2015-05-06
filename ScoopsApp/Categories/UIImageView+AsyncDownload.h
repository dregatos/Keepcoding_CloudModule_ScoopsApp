//
//  UIImageView+AsyncDownload.h
//  ScoopsApp
//
//  Created by David Regatos on 27/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import UIKit;

@interface UIImageView (AsyncDownload)

- (void)asyncDownloadFromURL:(NSURL *)url andCompletion:(void(^)(UIImage *image))completionBlock;

- (void)asyncDownloadFromURL:(NSURL *)url
             withPlaceholder:(UIImage *)placeholder
               andCompletion:(void(^)(UIImage *image))completionBlock;


@end
