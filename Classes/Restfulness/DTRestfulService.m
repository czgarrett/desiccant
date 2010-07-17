//
//  RestfulService.m
//  WordTower
//
//  Created by Christopher Garrett on 9/10/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "DTRestfulService.h"
#import "Zest.h"

@implementation DTRestfulService

@synthesize currentConnection, currentConnectionData, currentSyncObject, urlHost, currentResponse, delegate;

- (void) resetConnection {
   if (self.currentConnection) [self.currentConnection cancel];
   self.currentConnection = nil;
   self.currentConnectionData = nil;
   self.currentSyncObject = nil;
   self.currentResponse = nil;
}

#pragma mark URLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
   self.currentConnectionData = [NSMutableData data];
   self.currentResponse = response;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
   NSString *errorWithXML;
   NSDictionary *result = (NSDictionary *)[NSPropertyListSerialization
                                              propertyListFromData: self.currentConnectionData
                                              mutabilityOption: NSPropertyListImmutable
                                              format: nil
                                              errorDescription: &errorWithXML];
   if ([self.currentResponse httpError]) {
      NSLog(@"Response failed with error %@", [self.currentResponse httpError]);
      if (!errorWithXML) {
         NSLog(@"Errors object: %@", [result description]);         
      }
      if (delegate) {
         [delegate restfulService: self didFailRequestForObject: self.currentSyncObject];         
      }
   } else if (errorWithXML) {
      NSLog(@"Response successful, but invalid XML:");
      NSLog(@"%@", errorWithXML);
      if (delegate) {
         [delegate restfulService: self didFailRequestForObject: self.currentSyncObject];         
      }
   } else {
      [self.currentSyncObject setServerAttributes: result];
      self.currentSyncObject.lastSyncAt = [NSDate date];
      if (delegate) {
         [delegate restfulService: self didCompleteRequestForObject: self.currentSyncObject withResponse: result];         
      }
   }
   [self resetConnection];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
   [self.currentConnectionData appendData: data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
   if (delegate) {
      [delegate restfulService: self didFailRequestForObject: self.currentSyncObject];      
   }
   [self resetConnection];
}




#pragma mark creating requests

- (void) createRequestForObject: (id <DTRestfulObject>) restfulObject withMethod: (NSString *) httpMethod {
   NSString *urlString = nil;
   NSDictionary *attrs = [restfulObject serverAttributes];
   if ([httpMethod isEqualToString: @"POST"]) {
      urlString = [NSString stringWithFormat: @"%@/%@", self.urlHost, [restfulObject serverPathName]];
   } else {
      urlString = [NSString stringWithFormat: @"%@/%@/%@", self.urlHost, [restfulObject serverPathName], [restfulObject urlParam]];      
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
   [self createRequestForObject: restfulObject withMethod: @"POST"];
}

- (void) putObject: (id <DTRestfulObject>) restfulObject {
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
