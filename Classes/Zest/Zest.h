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

#import "Foundation/NSObject+Zest.h"
#import "Foundation/NSString+Zest.h"
#import "Foundation/NSDate+Zest.h"
#import "Foundation/NSArray+Zest.h"
#import "Foundation/NSDictionary+Zest.h"
#import "Foundation/NSMutableDictionary+Zest.h"
#import "Foundation/NSURL+Zest.h"
#import "Foundation/NSSet+Zest.h"
#import "Foundation/NSIndexPath+Zest.h"
#import "Foundation/NSData+Zest.h"
#import "Foundation/NSMutableData+Zest.h"

#import "UIKit/UIView+Zest.h"
#import "UIKit/UIColor+Zest.h"
#import "UIKit/UILabel+Zest.h"
#import "UIKit/UINavigationController+Zest.h"
#import "UIKit/UIViewController+Zest.h"
#import "UIKit/UITabBarItem+Zest.h"
#import "UIKit/UITableView+Zest.h"
#import "UIKit/UIButton+Zest.h"
#import "UIKit/UIBarButtonItem+Zest.h"

#import "NSManagedObject+Zest.h"
#import "NSManagedObjectContext+Zest.h"

#define unless(X) if(!(X))
#define LogTimeStart double logTimeStart = [NSDate timeIntervalSinceReferenceDate];
#define LogTime(msg) NSLog(@"%@: %f", msg, [NSDate timeIntervalSinceReferenceDate] - logTimeStart);
