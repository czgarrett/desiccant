//
//  DTRSSQuery.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/18/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTRSSQuery.h"
#import "DTXMLCollectionParserDelegate.h"
#import "DTXMLObjectParserDelegate.h"
#import "DTXMLValueParserDelegate.h"
#import "DTXMLAttributeParserDelegate.h"
#import "Zest.h"

@implementation DTRSSQuery

- (id)initWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryDelegate> *)theDelegate {
	if ((self = [super initWithURL:theURL 
						 delegate:theDelegate 
						   parser:[DTXMLParser 
								   parserWithParserDelegate:[DTXMLCollectionParserDelegate
															 delegateWithElement:@"channel" 
															 nestedParserDelegate:[DTXMLObjectParserDelegate
																				   delegateWithElement:@"item"
																				   nestedParserDelegates:[[NSArray arrayWithObjects:
																										  [DTXMLValueParserDelegate delegateWithElement:@"title"],
																										  [DTXMLValueParserDelegate delegateWithElement:@"description"],
																										   [DTXMLValueParserDelegate delegateWithKey:@"isoDate" element:@"dc:date"], // TODO-LATER: Figure out how to use the full namespace URL
																										  [DTXMLValueParserDelegate delegateWithElement:@"link"],
																										  [DTXMLValueParserDelegate delegateWithKey:@"pubDateString" element:@"pubDate"],
																										  [DTXMLAttributeParserDelegate delegateWithKey:@"video_url" element:@"enclosure" attribute:@"url" matchingAttributes:[NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"video/mp4", @"video/x-flv", @"video/x-mp4", @"video/quicktime", @"video/3gpp", @"video/mpeg", nil] forKey:@"type"]],
																										  [DTXMLAttributeParserDelegate delegateWithKey:@"audio_url" element:@"enclosure" attribute:@"url" matchingAttributes:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"audio/mpeg"] forKey:@"type"]],
																										  [DTXMLAttributeParserDelegate delegateWithKey:@"image_url" element:@"enclosure" attribute:@"url" matchingAttributes:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"image/jpg"] forKey:@"type"]],
																										  nil] arrayByAddingObjectsFromArray:[self extendedParserDelegatesForRSSItem]]
																				   ]
															 ]
								   ]
				]))
	{
		[self addRowTransformer:self];
	}
    return self;	
}

+ (id)queryWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryDelegate> *)theDelegate {
	return [[(DTRSSQuery *)[self alloc] initWithURL:theURL delegate:theDelegate] autorelease];
}

- (NSArray *)extendedParserDelegatesForRSSItem {
	return [NSArray array];
}

- (void)transform:(NSMutableDictionary *)data {
    [data setValue:[data stringForKey:@"pubDateString"].to_date forKey:@"pubDate"];
}

@end
