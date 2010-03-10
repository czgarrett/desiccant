
#import "FileMenuItem.h"
#import "ACDocumentViewController.h"
#import "ACMenuController.h"

@implementation FileMenuItem

@synthesize path, extension, title, description, resourceName, directory, controllerClass;

- (id) initWithPath: (NSString *) myPath {
   if (self = [super init]) {
      self.path = myPath;
      NSFileManager *fileMgr = [NSFileManager defaultManager];
      [fileMgr fileExistsAtPath: self.path isDirectory: &directory];
      NSString *fileName = [[self.path pathComponents] lastObject];
      NSString *fullName;
      if (directory) {
         self.extension = @"";
         fullName = fileName;
      } else {
         self.extension = [self.path pathExtension];                  
         fullName = [fileName substringToIndex: (fileName.length - extension.length - 1)];
      }
      NSArray *itemTitleAndDescription = [fullName componentsSeparatedByString: @"--"];
      self.title = [itemTitleAndDescription objectAtIndex: 0];
      if ([itemTitleAndDescription count] > 1) {
         self.description = [itemTitleAndDescription objectAtIndex: 1];
      }
      if ([extension isEqualToString: @"html"] || [extension isEqualToString: @"pdf"]) {
         controllerClass = [ACDocumentViewController class];
      } else if (directory) {
         controllerClass = [ACMenuController class];
      } 
   }
   return self;
}

- (void) dealloc {
   self.path = nil;
   self.extension = nil;
   self.title = nil;
   self.description = nil;
   self.resourceName = nil;
   [super dealloc];
}

@end
