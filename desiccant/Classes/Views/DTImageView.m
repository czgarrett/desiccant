//
//  DTImageView.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/3/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTImageView.h"
#import "Zest.h"

@interface DTImageView()
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *data;
@end

@implementation DTImageView
@synthesize connection, data, defaultImage, delegate, alwaysCacheToDisk;

- (void)dealloc {
    [connection cancel];
    self.connection = nil;
    self.data = nil;
    self.defaultImage = nil;
    self.delegate = nil;
    
    [super dealloc];
}

- (id)initWithImage:(UIImage *)image {
    if ((self = [super initWithImage:image])) {
        self.defaultImage = image;
    }
    return self;
}

- (void)loadFromURL:(NSURL *)url {
   if (url) {
      [connection cancel];
      if ([url isFileURL]) {
         self.data = nil;
         self.image = [UIImage imageWithContentsOfFile:[url path]];
         [self performSelectorOnMainThread:@selector(connectionDidFinishLoading:) withObject:nil waitUntilDone:NO];
      }
      else if ([url isCached]) {
         self.data = [[[url cachedData] mutableCopy] autorelease];
         [self performSelectorOnMainThread:@selector(connectionDidFinishLoading:) withObject:nil waitUntilDone:NO];
      }
      else {
         NSLog(@"Loading uncached image: %@", url);
         self.image = defaultImage;
         self.data = [NSMutableData data];
         NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
         [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
         self.connection = [NSURLConnection connectionWithRequest:url.to_request delegate:self];
      }      
   }
}

- (void)connection:(NSURLConnection *)theConnection
    didReceiveData:(NSData *)incrementalData {
    [self.data appendData:incrementalData];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    if (self.alwaysCacheToDisk) {
        NSCachedURLResponse *memOnlyCachedResponse =
        [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response
                                                 data:cachedResponse.data
                                             userInfo:cachedResponse.userInfo
                                        storagePolicy:NSURLCacheStorageAllowed];
        return [memOnlyCachedResponse autorelease];
    }
    else {
        return cachedResponse;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    [theConnection cancel];
    self.connection = nil;
    if (data) self.image = [UIImage imageWithData:data];
   if (!self.image) {
      NSLog(@"Didn't load, data size was %d", [data length]);
      self.image = defaultImage;  
   }
    self.data = nil;
    [delegate imageViewDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error {
    [theConnection cancel];
    self.connection = nil;
    self.image = defaultImage;
    self.data = nil;
    [delegate imageView:self didFailLoadingWithError:error];
}


@end
