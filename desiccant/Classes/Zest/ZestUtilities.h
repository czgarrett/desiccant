//
//  ZestUtilities.h
//  desiccant
//
//  Created by Curtis Duhn on 6/15/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#define unless(X) if(!(X))

#ifndef __OPTIMIZE__
#define DTLog(fmt, ...) [[NSFileHandle fileHandleWithStandardOutput] writeData:[[NSString stringWithFormat:(@"--\n" fmt @"\n"), ##__VA_ARGS__] dataUsingEncoding:NSUTF8StringEncoding]]
#define LogTimeStart double logTimeStart = [NSDate timeIntervalSinceReferenceDate];
#define LogTime(msg) DTLog(@"%@: %f", msg, [NSDate timeIntervalSinceReferenceDate] - logTimeStart);
#else
#define DTLog(fmt, ...) if (0) { [[NSFileHandle fileHandleWithStandardOutput] writeData:[[NSString stringWithFormat:(@"--\n" fmt @"\n"), ##__VA_ARGS__] dataUsingEncoding:NSUTF8StringEncoding]]; }
#define LogTimeStart
#define LogTime(msg)
#endif

// Wrap a method call in optionally() to swallow NSInvalidArgumentExpression.  Useful for optional protocol methods.
// Note: this is slightly different than testing using respondsToSelector:, because respondsToSelector: doesn't recognize
// methods invoked through forwardInvocation:.  This macro will call those methods.  Also, if the method called returns
// NSInvalidArgumentException for other reasons (e.g. you passed an invalid argument), you'll never know it.
#define optionally(expression) @try { expression; } @catch (NSException *e) { if (![[e name] isEqualToString:NSInvalidArgumentException]) @throw; }
#define ifResponds(target, selector, expression) if ([target respondsToSelector:selector]) { expression; }
// Can I get away with this?
#define $(s) @selector(s)
#define DTAbstractMethod NSAssert(0, @"Subclass must implement this abstract method"); [self doesNotRecognizeSelector:_cmd];

#define DTOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

// Add this to the end of a declaration to deprecate it
#define ZEST_DEPRECATED __attribute__ ((deprecated))