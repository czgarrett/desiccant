//
//  Zest.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef __IPHONE_3_0
#import <CoreData/CoreData.h>
#endif

#import "ISO8601DateFormatter.h"
#import "NSData+Base64.h"
#import "RegexKitLite.h"

#import "Foundation/NSObject+Zest.h"
#import "Foundation/NSString+Zest.h"
#import "Foundation/NSDate+Zest.h"
#import "Foundation/NSArray+Zest.h"
#import "Foundation/NSMutableArray+Zest.h"
#import "Foundation/NSDictionary+Zest.h"
#import "Foundation/NSMutableDictionary+Zest.h"
#import "Foundation/NSURL+Zest.h"
#import "Foundation/NSSet+Zest.h"
#import "Foundation/NSMutableString+Zest.h"
#import "Foundation/NSIndexPath+Zest.h"
#import "Foundation/NSData+Zest.h"
#import "Foundation/NSMutableData+Zest.h"
#import "Foundation/NSURLResponse+Zest.h"
#import "Foundation/NSHTTPURLResponse+Zest.h"
#import "Foundation/NSNull+Zest.h"
#import "Foundation/NSMutableURLRequest+Zest.h"

#import "UIKit/UIView+Zest.h"
#import "UIKit/UIColor+Zest.h"
#import "UIKit/UILabel+Zest.h"
#import "UIKit/UINavigationController+Zest.h"
#import "UIKit/UIViewController+Zest.h"
#import "UIKit/UIWebView+Zest.h"
#import "UIKit/UITabBarItem+Zest.h"
#import "UIKit/UITableView+Zest.h"
#import "UIKit/UIButton+Zest.h"
#import "UIKit/UIBarButtonItem+Zest.h"
#import "UIKit/MKMapView+Zest.h"
#import "UIKit/UIImageView+Zest.h"
#import "UIKit/UIScreen+Zest.h"

#import "NSManagedObject+Zest.h"
#import "NSManagedObjectContext+Zest.h"
#import "NSSortDescriptor+Zest.h"
#import "NSFetchRequest+Zest.h"

#define unless(X) if(!(X))
#define LogTimeStart double logTimeStart = [NSDate timeIntervalSinceReferenceDate];
#define LogTime(msg) NSLog(@"%@: %f", msg, [NSDate timeIntervalSinceReferenceDate] - logTimeStart);
// Wrap a method call in optionally() to swallow NSInvalidArgumentExpression.  Useful for optional protocol methods.
// Note: this is slightly different than testing using respondsToSelector:, because respondsToSelector: doesn't recognize
// methods invoked through forwardInvocation:.  This macro will call those methods.  Also, if the method called returns
// NSInvalidArgumentException for other reasons (e.g. you passed an invalid argument), you'll never know it.
#define optionally(expression) @try { expression; } @catch (NSException *e) { if (![[e name] isEqualToString:NSInvalidArgumentException]) @throw; }
#define ifResponds(target, selector, expression) if ([target respondsToSelector:selector]) { expression; }
// Can I get away with this?
#define $(s) @selector(s)
#define DTAbstractMethod NSAssert(0, @"Subclass must implement this abstract method"); [self doesNotRecognizeSelector:_cmd];
