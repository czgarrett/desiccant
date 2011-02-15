//
//  NSURLResponse+Zest.h
//
//  Created by Curtis Duhn on 1/22/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSURLResponse (Zest)

// If this is an HTTP response, and the server returned an error code (400 or greater), this
// returns an object with a matching code and localized description for that error.
// If the response code was not an error, or if this wasn't an HTTP response, this returns nil.
- (NSError *)httpError;

// If this is an HTTP response, returns the contents of the Content-Type response header.  Returns nil if 
// this wasn't an HTTP request, or if the content type is unknown.
- (NSString *)httpContentType;

@end
