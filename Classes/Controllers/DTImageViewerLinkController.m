//
//  DTImageViewerLinkController.m
//  iRevealMaui
//
//  Created by Curtis Duhn on 10/13/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTImageViewerLinkController.h"
#import "Zest.h"

@interface DTImageViewerLinkController()
@end

@implementation DTImageViewerLinkController
@synthesize title, parentController;

- (void)dealloc {
    self.title = nil;
    self.parentController = nil;
    
    [super dealloc];
}

- (id)initWithTitle:(NSString *)aTitle parentController:(UIViewController *)theParentController {
    if (self = [super init]) {
        self.title = aTitle;
        self.parentController = theParentController;
    }
    return self;
}

+ (DTImageViewerLinkController *)controllerWithTitle:(NSString *)aTitle parentController:(UIViewController *)theParentController{
    return [[[self alloc] initWithTitle:aTitle parentController:theParentController] autorelease];
}

- (BOOL)canHandleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return [request.URL isFileURL] && [[request.URL pathExtension] isImageExtension];
}

- (BOOL)handleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    DTImageViewerController *imageViewerController = [DTImageViewerController controllerWithURL:request.URL];
    imageViewerController.title = title;
    if (parentController.navigationController) {
        [parentController.navigationController pushViewController:imageViewerController animated:YES];
    }
    else {
        // TODO: Support usage without navigation controller by presenting modal
        NSAssert (0, @"Currently DTImageViewerLinkController requires its parent view controller to have a navigation controller.");
    }
    
    return NO;
}


@end
