//
//  DTAddress.h
//  BlueDevils
//
//  Created by Curtis Duhn on 1/26/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DTAddress : NSObject {
	NSString *name;
	NSString *address1;
	NSString *address2;
	NSString *city;
	NSString *state;
	NSString *zip;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address1;
@property (nonatomic, retain) NSString *address2;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *zip;
@property (nonatomic, retain, readonly) NSString *cityStateZipLine;

- (id) initWithName:(NSString *)theName
		   address1:(NSString *)theAddress1
		   address2:(NSString *)theAddress2
			   city:(NSString *)theCity
			  state:(NSString *)theState
				zip:(NSString *)theZip;

+ (id) addressWithName:(NSString *)theName
			  address1:(NSString *)theAddress1
			  address2:(NSString *)theAddress2
				  city:(NSString *)theCity
				 state:(NSString *)theState
				   zip:(NSString *)theZip;

- (NSString *)mapAnnotationTitle;

@end
