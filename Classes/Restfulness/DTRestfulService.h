//
//  RestfulService.h
//  WordTower
//
//  Created by Christopher Garrett on 9/10/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DTRestfulService;

@protocol DTRestfulObject

- (NSString *) serverPathName;
- (NSString *) serverObjectName;
- (NSDictionary *) serverAttributes;
- (void) setServerAttributes: (NSDictionary *) attributes;

@property (nonatomic, retain) NSDate *lastSyncAt;
@property (nonatomic, retain) NSString *serverId;
@property (nonatomic, readonly) BOOL isReadyForSync;
@property (nonatomic, readonly) NSString *urlParam;

@end

@protocol DTRestfulServiceDelegate 

@optional

- (void) restfulService: (DTRestfulService *)service didCompleteRequestForObject: (id <DTRestfulObject>) restfulObject withResponse: (NSDictionary *) response;
- (void) restfulService: (DTRestfulService *)service didFailRequestForObject: (id <DTRestfulObject>) restfulObject;

@end


@interface DTRestfulService : NSObject {
   id <DTRestfulServiceDelegate> delegate;
   NSURLConnection *currentConnection;
   NSURLResponse *currentResponse;
   NSMutableData *currentConnectionData;
   id <DTRestfulObject> currentSyncObject;
   NSString *urlHost;
}

@property (nonatomic, retain) NSURLConnection *currentConnection;
@property (nonatomic, retain) NSMutableData *currentConnectionData;
@property (nonatomic, retain) id <DTRestfulObject> currentSyncObject;
@property (nonatomic, retain) NSString *urlHost;
@property (nonatomic, retain) NSURLResponse *currentResponse;
@property (nonatomic, assign) id <DTRestfulServiceDelegate> delegate;

- (id) initWithDelegate: (id <DTRestfulServiceDelegate>) delegate;
- (void) resetConnection;

- (void) postObject: (id <DTRestfulObject>) restfulObject;
- (void) putObject: (id <DTRestfulObject>) restfulObject;
- (void) deleteObject: (id <DTRestfulObject>) restfulObject;
- (void) getObject: (id <DTRestfulObject>) restfulObject;


@end
