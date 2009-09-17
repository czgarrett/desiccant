//
//  Zest.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

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

#import "UIKit/UIView+Zest.h"
#import "UIKit/UIColor+Zest.h"
#import "UIKit/UILabel+Zest.h"
#import "UIKit/UINavigationController+Zest.h"
#import "UIKit/UIViewController+Zest.h"

#import "NSManagedObject+Zest.h"
#import "NSManagedObjectContext+Zest.h"

#define unless(X) if(!(X))
#define LogTimeStart double logTimeStart = [NSDate timeIntervalSinceReferenceDate];
#define LogTime(msg) NSLog(@"%@: %f", msg, [NSDate timeIntervalSinceReferenceDate] - logTimeStart);
