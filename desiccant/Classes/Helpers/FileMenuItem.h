
#import "desiccant.h"

@class ACMenuController;
@class ACDocumentViewController;

@interface FileMenuItem : NSObject {
   NSString *path;
   NSString *extension;
   NSString *title;
   NSString *description;
   NSString *resourceName;
   Class controllerClass;
   BOOL directory;
}

@property(nonatomic, retain) NSString *path;
@property(nonatomic, retain) NSString *extension;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSString *resourceName;
@property(nonatomic, readonly) Class controllerClass;
@property(nonatomic, readonly) BOOL directory;

- (id) initWithPath: (NSString *) path;

@end
