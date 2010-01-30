//
//  DTCaptcha.h
//  PortablePTO
//
//  Created by Curtis Duhn on 1/27/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTGoogleCaptcha : NSObject {

}

- (id)initWithHTMLData:(NSData *)theData;
+ (id)captchaWithHTMLData:(NSData *)theData;

@end
