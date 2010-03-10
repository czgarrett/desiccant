//
//  WordList.h
//  WordTower
//
//  Created by Christopher Garrett on 12/27/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//
// WordList represents a file of uppercase words presorted alphabetically.  By assuming the file is
// already sorted, it can implement fast binary search algorithms against that file.

#import <Foundation/Foundation.h>


@interface DTWordList : NSObject {
   NSString *resourceName;
   NSFileHandle *fileHandle;
   
   
}

@property (nonatomic, retain) NSString *resourceName;
@property (nonatomic, retain) NSFileHandle *fileHandle;

+ (DTWordList *) wordListForResourceName: (NSString *) resourceName;
- (id) initWithResourceName: (NSString *) resourceName;

- (BOOL) containsWord: (NSString *) word;
- (NSString *) wordAtFilePosition: (unsigned long long) filePosition;

@end
