//
//  DTImageViewDelegate.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/8/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DTImageView;

@protocol DTImageViewDelegate

- (void)imageView:(DTImageView *)imageView didFailLoadingWithError:(NSError *)error;
- (void)imageViewDidFinishLoading:(DTImageView *)imageView;

@end

