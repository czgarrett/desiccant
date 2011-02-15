//
//  DTQueryBuilderElementType.h
//
//  Created by Curtis Duhn on 11/13/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTQueryBuilderElementType
- (NSString *)selectorText;
- (NSString *)labelText;
@end

@interface DTQueryBuilderElementType : NSObject <DTQueryBuilderElementType> {
	NSString *selectorText;
	NSString *labelText;
}

@property (nonatomic, retain) NSString *selectorText;
@property (nonatomic, retain) NSString *labelText;

@end
