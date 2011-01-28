//
//  DTCustomTableViewCell.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/22/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTCustomTableViewCell.h"
#import "Zest.h"
#import "DTImageView.h"

@interface DTCustomTableViewCell()
@property (nonatomic, retain) UILabel *dtTextLabel;
@property (nonatomic, retain) UILabel *dtDetailTextLabel;
@property(nonatomic, retain) UIImageView *dtImageView;
@property (nonatomic, retain) NSDictionary *dtData;
@end

@implementation DTCustomTableViewCell
@synthesize minHeight, dtTextLabel, dtDetailTextLabel, dtImageView, delegate, dtData, deleteBlock;

-(IBAction) deleteFromTable: (id) src {
   if (self.deleteBlock) {
      self.deleteBlock(self);
   } else {
      NSAssert(0, @"No delete block was given.  You should set a delete block when you create or configure the table cell.");
   }
}

#pragma mark Memory management

- (void)dealloc {
	self.dtTextLabel = nil;
	self.dtDetailTextLabel = nil;
	self.dtImageView = nil;
	self.delegate = nil;
	self.dtData = nil;
   self.deleteBlock = nil;
	
	[super dealloc];
   NSLog(@"Cell dealloced");
}

#pragma mark Public methods

// Default implementation sets the title using titleFromData:, the subtitle
// using subtitleFromData:
// Subclasses can override this to set fields given an untyped data object.
- (void)setData:(NSDictionary *)theData {
	self.dtData = theData;
	if (delegate) {
		if (self.textLabel) {
			self.textLabel.text = @"";
			NSString *title = [delegate cell:self titleFromData:theData];
			if (title) self.textLabel.text = title;
		}
		
		if (self.detailTextLabel) {
			self.detailTextLabel.text = @"";
			NSString *subtitle = [delegate cell:self subtitleFromData:theData];
			if (subtitle) self.detailTextLabel.text = subtitle;
		}
		
		if (self.imageView) {
			UIImage *theImage = [delegate cell:self imageFromData:theData];
			if (theImage) self.imageView.image = theImage;
			
			UIImage *theHighlightedImage = [delegate cell:self highlightedImageFromData:theData];
			self.imageView.highlightedImage = theHighlightedImage;
			
			NSURL *imageURL = [delegate cell:self imageURLFromData:theData];
			if (imageURL) {
				NSAssert ([self.imageView respondsToSelector:@selector(loadFromURL:)],
						  @"Can't load image URL asynchronously unless imageView is a DTImageView");
				[(DTImageView *)self.imageView setDefaultImage:self.imageView.image];
				[(DTImageView *)self.imageView loadFromURL:imageURL];
			}
		}
		
		if ([delegate cellShouldResizeTitle:self]) [self adjustHeightForLabel:self.textLabel];
		if ([delegate cellShouldResizeSubtitle:self]) [self adjustHeightForLabel:self.detailTextLabel];
	}
}

- (NSDictionary *)data {
	return self.dtData;
}

// Subclasses can call this in setData after setting the contents of a label.  
// It will adjust the height of the label and the cell to fit the text based on
// the current width of the label.  If you're going to use this in setData, make 
// sure you also override hasDynamicHeight and return YES.
- (void)adjustHeightForLabel:(UILabel *)label {
	if (minHeight == 0.0 || self.bounds.size.height < minHeight) minHeight = self.bounds.size.height;
	CGFloat margin = self.bounds.size.height - label.frame.size.height;
	CGFloat newLabelHeight = [label heightToFitText];
	CGFloat newCellHeight = newLabelHeight + margin;
	if (newCellHeight < minHeight && newLabelHeight > 0) {
		newCellHeight = minHeight;
		newLabelHeight = minHeight - margin;
	}
	
	CGFloat newLabelY = label.frame.origin.y;
	if (([label autoresizingMask] & UIViewAutoresizingFlexibleTopMargin) && !([label autoresizingMask] & UIViewAutoresizingFlexibleBottomMargin)) {
//		newLabelY = label.frame.origin.y - (newLabelHeight - label.frame.size.height);
		newLabelY = label.frame.origin.y;
	}
	else if (!([label autoresizingMask] & UIViewAutoresizingFlexibleTopMargin) && ([label autoresizingMask] & UIViewAutoresizingFlexibleBottomMargin)) {
		newLabelY = label.frame.origin.y;
	}
	else {
		NSAssert (0, @"To adjust the height of a label, it must have one flexible top or bottom margin, and one fixed.");
	}
	
	CGRect newBounds = self.bounds;
	newBounds.size.height = newCellHeight;
	newBounds.origin.y = 0;
	UIViewAutoresizing oldContentViewAutoresizing = self.contentView.autoresizingMask;
	self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.bounds = newBounds;
	self.contentView.autoresizingMask = oldContentViewAutoresizing;
	label.frame = CGRectMake(label.frame.origin.x, newLabelY, label.frame.size.width, newLabelHeight);
//	if ([label.text isEqual:@"DC-eye: 2COOLVK"]) {
//		DTLog(@"after: %f - %f = %f", self.bounds.size.height, label.frame.size.height, self.bounds.size.height - label.frame.size.height);
//	}
}

// Subclasses should override this method and return YES if they manually modify 
// the height of the cell in setData.  The default implementation returns YES if
// a delegate is set and cellShouldResizeTitle: or cellShouldResizeSubitle:
// return YES, or NO otherwise.
- (BOOL)hasDynamicHeight {
	return (delegate && ([delegate cellShouldResizeTitle:self] || 
						 [delegate cellShouldResizeSubtitle:self]));
}

#pragma mark Dynamic properties

- (void)setTextLabel:(UILabel *)theLabel {
	self.dtTextLabel = theLabel;
}

- (UILabel *)textLabel {
	if (!dtTextLabel) {
		return [super textLabel];
	}
	else {
		return dtTextLabel;
	}
}

- (void)setDetailTextLabel:(UILabel *)theLabel {
	self.dtDetailTextLabel = theLabel;
}

- (UILabel *)detailTextLabel {
	if (!dtDetailTextLabel) {
		return [super detailTextLabel];
	}
	else {
		return dtDetailTextLabel;
	}
}

- (void)setImageView:(UIImageView *)theImageView {
	self.dtImageView = theImageView;
}

- (UIImageView *)imageView {
	if (!dtImageView) {
		return [super imageView];
	}
	else {
		return dtImageView;
	}
}


@end
