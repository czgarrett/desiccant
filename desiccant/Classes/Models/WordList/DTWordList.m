//
//  WordList.m
//  WordTower
//
//  Created by Christopher Garrett on 12/27/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "DTWordList.h"

#define MAX_WORD_LENGTH 15
#define NEWLINE_LENGTH 2

static DTWordList *sowpodsFull;
static DTWordList *sowpodsPartial;

@implementation DTWordList

@synthesize resourceName, fileHandle;

+ (void) resetLists {
   sowpodsFull = nil;
   sowpodsPartial = nil;
}

+ (DTWordList *) sowpodsFull {
   if (!sowpodsFull) {
      sowpodsFull = [[DTWordList alloc] initWithResourceName: @"sowpods_unix"];
   }
   return sowpodsFull;
}

+ (DTWordList *) sowpodsPartial {
   if (!sowpodsPartial) {
      sowpodsPartial = [[DTWordList alloc] initWithResourceName: @"sowpods_parts"];
   }
   return sowpodsPartial;
}

// resourceName should be the name of a file containing a sorted list of capitalized words.
+ (DTWordList *) wordListForResourceName: (NSString *) resourceName {
   return [[DTWordList alloc] initWithResourceName: (NSString *) resourceName];
}

- (id) initWithResourceName: (NSString *) myResourceName {
   if ((self = [super init])) {
      self.resourceName = myResourceName;
   }
   return self;
}

- (BOOL) containsWord: (NSString *) word {
   if (!word || [word length] == 0) return NO;
   unsigned long long maxFilePosition = [self.fileHandle seekToEndOfFile];
	unsigned long long minFilePosition = 0;
   unsigned long long midFilePosition;
   NSString *wordAtMid = nil;
   
   // Yer basic binary search algorithm here.
   
	while (minFilePosition < maxFilePosition) {
      
		midFilePosition = (minFilePosition + maxFilePosition)/2;
      wordAtMid = [self wordAtFilePosition: midFilePosition];
      switch ([wordAtMid compare: word]) {
         case NSOrderedSame:
            return YES;
         case NSOrderedAscending:
            minFilePosition = midFilePosition + 1;
            break;
         case NSOrderedDescending:
            if (midFilePosition == 0) {
               return NO; // the word comes before the first word in the file
            }
            maxFilePosition = midFilePosition - 1;
            break;
      }
	}
   return NO;   
}

- (NSString *) wordAtFilePosition: (unsigned long long) filePosition {
   // Starting with the file position,
   // work backwards until we encounter a newline (end of the previous word)
   // or the beginning of the file.  Return the result immediately after the
   // newline, or the first word of the file if applicable
   unsigned long long dataStart = filePosition - MAX_WORD_LENGTH;
   if (filePosition < MAX_WORD_LENGTH) dataStart = 0;
   NSInteger indexOfFilePositionInData = filePosition - dataStart;
   [self.fileHandle seekToFileOffset: dataStart];

   NSData *wordData = [self.fileHandle readDataOfLength: (MAX_WORD_LENGTH + NEWLINE_LENGTH) * 2];
   NSString *words = [[NSString alloc] initWithData: wordData encoding: NSUTF8StringEncoding];
   
   NSRange characterRange;
   NSString *character;
   characterRange.length = 1;

   NSInteger wordStart = indexOfFilePositionInData;
   while (wordStart > 0) {
      characterRange.location = wordStart-1;
      character = [words substringWithRange: characterRange];
      if ([character isEqualToString: @"\n"]) break;
      wordStart--;
   }
   
   NSInteger wordEnd = indexOfFilePositionInData;
   while (wordEnd < [words length]) {
      characterRange.location = wordEnd;
      character = [words substringWithRange: characterRange];
      if ([character isEqualToString: @"\n"]) break;         
      wordEnd++;
   }
   
   
   NSRange wordRange;
   wordRange.length = wordEnd - wordStart;
   wordRange.location = wordStart;
   NSString *result =  [words substringWithRange: wordRange];
   return result;
}


- (NSFileHandle *) fileHandle {
   if (!fileHandle) {
      NSString *path = [[NSBundle mainBundle] pathForResource: self.resourceName ofType: @"txt"];
      NSAssert(path != nil, @"Bundle doesn't contain word list.");
      fileHandle = [NSFileHandle fileHandleForReadingAtPath: path];
   }
   return fileHandle;
}

@end
