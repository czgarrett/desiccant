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

+ (DTRSSQuery *)queryWithURL:(NSURL *)url delegate:(NSObject <DTAsyncQueryDelegate> *)delegate {
    DTRSSQuery *newQuery = (DTRSSQuery *) 
    [super queryWithURL:url 
               delegate:delegate 
                 parser:[DTXMLParser 
                         parserWithParserDelegate:[DTXMLCollectionParserDelegate
                                                   delegateWithElement:@"channel" 
                                                   nestedParserDelegate:[DTXMLObjectParserDelegate
                                                                         delegateWithElement:@"item"
                                                                         nestedParserDelegates:[NSArray arrayWithObjects:
                                                                                                [DTXMLValueParserDelegate delegateWithElement:@"title"],
                                                                                                [DTXMLValueParserDelegate delegateWithElement:@"description"],
                                                                                                [DTXMLValueParserDelegate delegateWithElement:@"link"],
                                                                                                [DTXMLValueParserDelegate delegateWithKey:@"pubDateString" element:@"pubDate"],
                                                                                                [DTXMLAttributeParserDelegate delegateWithKey:@"video_url" element:@"enclosure" attribute:@"url" matchingAttributes:[NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"video/mp4", @"video/x-flv", @"video/x-mp4", @"video/quicktime", @"video/3gpp", @"video/mpeg", nil] forKey:@"type"]],
                                                                                                [DTXMLAttributeParserDelegate delegateWithKey:@"audio_url" element:@"enclosure" attribute:@"url" matchingAttributes:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"audio/mpeg"] forKey:@"type"]],
                                                                                                [DTXMLAttributeParserDelegate delegateWithKey:@"image_url" element:@"enclosure" attribute:@"url" matchingAttributes:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"image/jpg"] forKey:@"type"]],
                                                                                                [DTXMLCollectionParserDelegate 
                                                                                                 delegateWithElement:@"event_scores" 
                                                                                                 nestedParserDelegate:[DTXMLObjectParserDelegate
                                                                                                                       delegateWithElement:@"result"
                                                                                                                       nestedParserDelegates:[NSArray arrayWithObjects:
                                                                                                                                              [DTXMLValueParserDelegate delegateWithElement:@"corps"],
                                                                                                                                              [DTXMLValueParserDelegate delegateWithElement:@"score"],                                                                                                                           
                                                                                                                           nil]]],
                                                                                                [DTXMLCollectionParserDelegate
                                                                                                 delegateWithElement:@"event_corps" 
                                                                                                 nestedParserDelegate:[DTXMLValueParserDelegate delegateWithElement:@"corps"]],
                                                                                                nil]
                                                   ]
                                ]
            ]
    ];
    [newQuery addRowTransformer:newQuery];
    return newQuery;
}

- (void)transform:(NSMutableDictionary *)data {
    [data setValue:[data stringForKey:@"pubDateString"].to_date forKey:@"pubDate"];
}

@end
