//
//  DTWordDatabase.m
//  word-game-3
//
//  Created by Garrett Christopher on 6/4/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import "DTWordDatabase.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "CBucks.h"


static DTWordDatabase *DTWordDatabaseInstance;

@interface DTWordDatabase() {
   
}

@property (nonatomic, retain) FMDatabase *db;

@end

@implementation DTWordDatabase

@synthesize db;

+ (DTWordDatabase *) instance {
   if (!DTWordDatabaseInstance) {
      DTWordDatabaseInstance = [[DTWordDatabase alloc] init];
   }
   return DTWordDatabaseInstance;
}

+ (DTWordDatabase *) wordDatabase {
   return [[DTWordDatabase alloc] init];
}

- (id) init {
   self = [super init];
   if (self) {
      NSString *path = [[NSBundle mainBundle] pathForResource: @"words" ofType: @"db"];
      self.db = [FMDatabase databaseWithPath: path];
      [self.db open];
   }
   return self;
}

- (void) dealloc {
   [self.db close];
   self.db = nil;
}

- (BOOL) containsWord: (NSString *) word {
   return [[db executeQuery: @"SELECT * from words where word = ? limit 1", [word uppercaseString]] next];
}

- (BOOL) containsPartialWord: (NSString *) word {
   return [[db executeQuery: @"SELECT * from words where word like ? limit 1", $S(@"%%%@%%", word)] next];
}

- (NSString *) randomWordContainingPartial: (NSString *) partialWord {
   if (partialWord) {
      FMResultSet *r = [self.db executeQuery: @"SELECT * from words where word like ? order by random() limit 1", $S(@"%%%@%%", partialWord)];
      if ([r next]) {
         return [r stringForColumn: @"word"];
      }
   }
   return nil;
}


@end
