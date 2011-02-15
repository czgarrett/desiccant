//
//  DTSetDataBasedTableViewController.h
//  BlueDevils
//
//  Created by Curtis Duhn on 3/15/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTTableViewController.h"
#import "DTCustomTableViewCell.h"

@interface DTSetDataBasedTableViewController : DTTableViewController <DTCustomTableViewCellDelegate> {

}

// Returns "image_name" by default.  Subclasses can override this to pull the 
// name of a local image resource to use from a different key.
- (NSString *)imageNameKey;

// Returns "highlighted_image_name" by default.  Subclasses can override this to pull the 
// name of a local image resource to use from a different key.
- (NSString *)highlightedImageNameKey;

// Returns "title" by default.  Subclasses can override this to pull the
// title from the data using a different key.
- (NSString *)titleKey;

// Returns "subtitle" by default.  Subclasses can override this to pull the
// subtitle from the data using a different key.
- (NSString *)subtitleKey;

// Returns "title" by default.  Subclasses can override this to pull a URL
// of an image to be loaded asynchronously from the data using a different key.
- (NSString *)imageURLKey;

@end
