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
@synthesize connection, data, defaultImage, delegate;

- (void)dealloc {
    [connection cancel];
    self.connection = nil;
    self.data = nil;
    self.defaultImage = nil;
    self.delegate = nil;
    
    [super dealloc];
}

- (id)initWithImage:(UIImage *)image {
    if (self = [super initWithImage:image]) {
        self.defaultImage = image;
    }
    return self;
}


- (void)loadFromURL:(NSURL *)url {
    [connection cancel];
    if ([url isCached]) {
        self.data = [[[url cachedData] mutableCopy] autorelease];
        [self connectionDidFinishLoading:nil];
    }
    else {
        self.image = defaultImage;
        self.data = [NSMutableData data];
        self.connection = [NSURLConnection connectionWithRequest:url.to_request delegate:self];
    }
}

- (void)connection:(NSURLConnection *)theConnection
    didReceiveData:(NSData *)incrementalData {
    [self.data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    [theConnection cancel];
    self.connection = nil;
    self.image = [UIImage imageWithData:data];
    if (!self.image) self.image = defaultImage;
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
