//
//  DTViewController.h
//  iRevealMaui
//
//  Created by Ilan Volow on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DTActsAsChildViewController.h"

@interface DTViewController : UIViewController <DTActsAsChildViewController> {
	IBOutlet UIViewController *containerViewController;
}

@end
