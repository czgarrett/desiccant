//
//  SelectableTableItem.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 8/30/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectableTableItem : NSObject {
   NSString *description;
   SEL selector;
   NSString *iconName;
}

@property(retain) NSString *description;
@property SEL selector;
@property(retain) NSString *iconName;

- (id) initWithDescription: (NSString *)description selector:(SEL)selector iconName: (NSString *)iconName;

@end
