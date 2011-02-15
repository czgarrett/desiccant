//
//  ACShowController.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 9/21/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "ACShowController.h"
#include <AudioToolbox/AudioToolbox.h>
#include <CoreFoundation/CoreFoundation.h>

@implementation ACShowController

@synthesize modelObject;

-(id) initWithModelObject: (ARObject *)myModelObject {
   if (self == [self init]) {
      self.modelObject = myModelObject;
   }
   return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)alertWithTitle: (NSString *)title message: (NSString *)message {
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                   message: message
                                                  delegate: self 
                                         cancelButtonTitle: @"Ok" 
                                         otherButtonTitles: nil];
   [alert show];
   [alert autorelease];   
}

- (void) playSoundNamed: (NSString *)soundName {
   NSString *path = [[NSBundle mainBundle] pathForResource: soundName ofType: @"wav" inDirectory: nil];
   NSURL *soundURL =  [NSURL fileURLWithPath: path];
   SystemSoundID    mySSID;
   AudioServicesCreateSystemSoundID ((CFURLRef) soundURL, &mySSID);
   AudioServicesPlaySystemSound (mySSID);
}



- (void)confirmationWithTitle: (NSString *)title message: (NSString *)message {
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                   message: message
                                                  delegate: self 
                                         cancelButtonTitle: @"Cancel" 
                                         otherButtonTitles: @"Ok", nil];
   [alert show];
   [alert autorelease];   
}



- (void)dealloc {
   self.modelObject = nil;
    [super dealloc];
}


@end
