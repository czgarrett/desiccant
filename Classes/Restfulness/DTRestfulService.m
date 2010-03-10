//
//  RestfulService.m
//  WordTower
//
//  Created by Christopher Garrett on 9/10/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "DTRestfulService.h"


@implementation DTRestfulService

@synthesize currentConnection, currentConnectionData, currentSyncObject, urlHost;

- (void) resetConnection {
   if (self.currentConnection) [self.currentConnection cancel];
   self.currentConnection = nil;
   self.currentConnectionData = nil;
   self.currentSyncObject = nil;
}

#pragma mark URLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
   self.currentConnectionData = [NSMutableData data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
   NSString *errorMessage;
   NSDictionary *result = (NSDictionary *)[NSPropertyListSerialization
                                              propertyListFromData: self.currentConnectionData
                                              mutabilityOption: NSPropertyListImmutable
                                              format: nil
                                              errorDescription: &errorMessage];
   if (errorMessage) {
      NSLog(@"Error decoding dictionary: %@", errorMessage);
      NSLog(@"XML content:");
      NSLog(@"%@", [[[NSString alloc] initWithData: self.currentConnectionData encoding: NSUTF8StringEncoding] autorelease]);
      [errorMessage release]; // nonstandard release, per docs for NSPropertyListSerialization
      [delegate restfulService: self didFailRequestForObject: self.currentSyncObject];
   } else {
      [self.currentSyncObject setServerAttributes: result];
      self.currentSyncObject.lastSyncAt = [NSDate date];
      [delegate restfulService: self didCompleteRequestForObject: self.currentSyncObject withResponse: result];
   }
   [self resetConnection];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
   [self.currentConnectionData appendData: data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
   [delegate restfulService: self didFailRequestForObject: self.currentSyncObject];
   [self resetConnection];
}




#pragma mark creating requests

- (void) createRequestForObject: (id <DTRestfulObject>) restfulObject withMethod: (NSString *) httpMethod {
   NSString *urlString = nil;
   NSDictionary *attrs = [restfulObject serverAttributes];
   if ([httpMethod isEqualToString: @"POST"]) {
      urlString = [NSString stringWithFormat: @"%@/%@", self.urlHost, [restfulObject serverPathName]];
   } else {
      urlString = [NSString stringWithFormat: @"%@/%@/%@", self.urlHost, [restfulObject serverPathName], [attrs objectForKey: @"id"]];      
   }
   NSURL *url = [NSURL URLWithString: urlString];
   NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
   [request setValue: @"application/xml" forHTTPHeaderField: @"Accept"];
   [request setValue: @"application/xml" forHTTPHeaderField: @"Content-Type"];
   [request setHTTPMethod: httpMethod];

   NSMutableString *postString = [NSMutableString string];
   [postString appendString: @"<?xml version='1.0' encoding='UTF-8'?>"];
   [postString appendFormat: @"<%@>", [restfulObject serverObjectName]];
   for (NSString *key in [attrs keyEnumerator]) {
      [postString appendFormat: @"<%@>%@</%@>", key, [attrs objectForKey: key], key];
   }
   [postString appendFormat: @"</%@>", [restfulObject serverObjectName]];
   NSData *postData =  [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
   [request setHTTPBody: postData];   
   [request setValue: [NSString stringWithFormat: @"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];

   self.currentConnection = [NSURLConnection connectionWithRequest: request delegate: self];
   [request release];
   self.currentSyncObject = restfulObject;
}

- (void) postObject: (id <DTRestfulObject>) restfulObject {
   NSLog(@"Posting!");
   [self createRequestForObject: restfulObject withMethod: @"POST"];
}

- (void) putObject: (id <DTRestfulObject>) restfulObject {
   NSLog(@"Putting!");
   [self createRequestForObject: restfulObject withMethod: @"PUT"];   
}

- (void) deleteObject: (id <DTRestfulObject>) restfulObject {
   
}

- (void) getObject: (id <DTRestfulObject>) restfulObject {
   
}

#pragma mark  lifecycle

- (id) initWithDelegate: (id <DTRestfulServiceDelegate>) myDelegate {
   if (self = [super init]) {
      delegate = myDelegate;
   }
   return self;
}


- (void) dealloc {
   [self resetConnection]; // releases the connection, conn data and current sync obj
   delegate = nil;
   [super dealloc];
}

@end
