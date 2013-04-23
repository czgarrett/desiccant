
#import "NSMutableString+Zest.h"


@implementation NSMutableString ( Zest )

-(void) appendTag: (NSString *) htmlTag text: (NSString *) htmlText {
   [self appendFormat: @"<%@>%@</%@>\n", htmlTag, htmlText, htmlTag];
}

-(void) appendTag: (NSString *) htmlTag textFormat: (NSString *) htmlText, ... {
   va_list args;
   va_start(args, htmlText);          // Start scanning for arguments after firstObject.
   NSString *text = [[NSString alloc] initWithFormat: htmlText arguments: args];
   return [self appendTag: htmlTag text: text];
}

@end


@interface FixCategoryBugNSMutableString : NSObject {}
@end
@implementation FixCategoryBugNSMutableString
@end