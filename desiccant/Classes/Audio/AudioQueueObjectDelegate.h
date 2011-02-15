/*
 *  AudioQueueObjectDelegate.h
 *  ZWorkbench
 *
 *  Created by Christopher Garrett on 7/23/08.
 *  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
 *
 */

@class AudioQueueObject;

@protocol AudioQueueObjectDelegate  

- (void) audioQueueStateChanged: (AudioQueueObject *) inQueue;

@end

