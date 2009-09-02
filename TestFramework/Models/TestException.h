//
//  TestException.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/16/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TestException : NSException {
}
+(TestException *) exceptionWithReason: (NSString *)reason;

@end
