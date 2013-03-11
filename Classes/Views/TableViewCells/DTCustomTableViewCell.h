//
//  DTCustomTableViewCell.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/22/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTCustomTableViewCell;
@protocol DTCustomTableViewCellDelegate <NSObject>

// If the delegate returns YES, the default setData: will resize the title
// to have variable height.
- (BOOL)cellShouldResizeTitle:(DTCustomTableViewCell *)theCell;

// If the delegate returns YES, the default setData: will resize the subtitle
// to have variable height.
- (BOOL)cellShouldResizeSubtitle:(DTCustomTableViewCell *)theCell;

// The delegate should return an image if the cell should present one 
// synchronously, or nil otherwise.
- (UIImage *)cell:(DTCustomTableViewCell *)theCell imageFromData:(NSDictionary *)data;

// The delegate should return an image if the cell should present an alternate
// image when the row is selected, or nil otherwise.
- (UIImage *)cell:(DTCustomTableViewCell *)theCell highlightedImageFromData:(NSDictionary *)data;

// The delegate should return an image URL if the cell should load one
// asynchronously, or nil otherwise.
- (NSURL *)cell:(DTCustomTableViewCell *)theCell imageURLFromData:(NSDictionary *)data;

// The delegate should return a title for the cell, or nil if it shouldn't
// have one.
- (NSString *)cell:(DTCustomTableViewCell *)theCell titleFromData:(NSDictionary *)data;

// The delegate should return a sbtitle for the cell, or nil if it shouldn't
// have one.
- (NSString *)cell:(DTCustomTableViewCell *)theCell subtitleFromData:(NSDictionary *)data;

@end

@interface DTCustomTableViewCell : UITableViewCell {
	CGFloat minHeight;
	UILabel *dtTextLabel;
	UILabel *dtDetailTextLabel;
	UIImageView *dtImageView;
	id <DTCustomTableViewCellDelegate> delegate;
	NSDictionary *dtData;
}

// Set this to enforce a min height on variable height rows.
@property (nonatomic) CGFloat minHeight;

// Returns the default textLabel property, or a custom one if you set it
// in a NIB or code.
@property (nonatomic, retain) IBOutlet UILabel *textLabel;

// Returns the default detailTextLabel property, or a custom one if you set it
// in a NIB or code.
@property(nonatomic, retain) IBOutlet UILabel *detailTextLabel;

// Returns the default imageView property, or a custom one if you set it
// in a NIB or code.
@property(nonatomic, retain) IBOutlet UIImageView *imageView;

// Set the delegate if you want to use the default setData: method
@property (nonatomic, assign) IBOutlet id <DTCustomTableViewCellDelegate> delegate;

// The default setter uses derives a title, subtitle, and image from
// the delegate if one is set.  Otherwise it does nothing.
// Subclasses can override this method to customize the cell's UI manually.
// Subclasses may call [super setData:] to do further customization beyond
// the default.
@property (nonatomic, retain) NSDictionary * data;

// Subclasses may implement this if they need to do something after setData: but before
// display.  This is needed because setData: also gets called in tableView:heightForRowAtIndexPath:
// on cells with dynamic heights.  If a cell does something expensive like load a remote image,
// you don't want to do that on every row when you're just measuring heights.  So just save the
// URL in setData: and load the image here in prepareForDisplay.
- (void)prepareForDisplay;

// Subclasses should override this method and return YES if they manually modify 
// the height of the cell in setData.  The default implementation returns YES if
// a delegate is set and cellShouldResizeTitle: or cellShouldResizeSubitle:
// return YES, or NO otherwise.
- (BOOL)hasDynamicHeight;

// Subclasses can call this in setData after setting the contents of a label.  
// It will adjust the height of the label and the cell to fit the text based on
// the current width of the label.  If you're going to use this in setData, make 
// sure you also override hasDynamicHeight and return YES.
- (void)adjustHeightForLabel:(UILabel *)label;


@end
