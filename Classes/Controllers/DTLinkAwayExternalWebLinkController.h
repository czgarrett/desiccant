//
//  DTLinkAwayExternalWebLinkController.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/8/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ACWebLinkController.h"

@interface DTLinkAwayExternalWebLinkController : NSObject <ACWebLinkController> {

}

- (id) init;
+ (DTLinkAwayExternalWebLinkController *)controller;
    
@end
