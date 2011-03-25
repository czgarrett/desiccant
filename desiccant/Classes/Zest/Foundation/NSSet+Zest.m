
#import "NSSet+Zest.h"


@implementation NSSet (Zest)

- (BOOL) empty {
   return [self count] == 0;
}

@end

@interface FixCategoryBugNSSet : NSObject {}
@end
@implementation FixCategoryBugNSSet
@end