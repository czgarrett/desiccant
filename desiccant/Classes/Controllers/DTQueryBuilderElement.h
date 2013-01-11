//
//  DTQueryBuilderElement.h
//
//  Created by Curtis Duhn on 11/13/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTQueryBuilderElementType.h"

@protocol DTQueryBuilderElementType;

@protocol DTQueryBuilderElement
@property (nonatomic, retain) NSObject <DTQueryBuilderElementType> *type;
@property (nonatomic, retain) NSString *text;
@end

@interface DTQueryBuilderElement : NSObject <DTQueryBuilderElement> {
	NSObject <DTQueryBuilderElementType> *type;
	NSString *text;
}

- (id)initWithText:(NSString *)theText type:(NSObject <DTQueryBuilderElementType> *)theType;
+ (DTQueryBuilderElement *)elementWithText:(NSString *)theText type:(NSObject <DTQueryBuilderElementType> *)theType;


@end
