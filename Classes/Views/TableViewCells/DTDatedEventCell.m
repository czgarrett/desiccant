//
//  ACDatedEventCell.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/18/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTDatedEventCell.h"
#import "RegexKitLite.h"
#import "Zest.h"

@implementation DTDatedEventCell
@synthesize dayName, eventName, dayNumber;

- (void)dealloc {
    self.dayName = nil;
    self.eventName = nil;
    self.dayNumber = nil;
    
    [super dealloc];
}

#ifndef __IPHONE_3_0
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
#else
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
#endif
                // Initialization code
    }
    return self;
}

- (void)setData:(NSMutableDictionary *)data {
    eventName.text = [data stringForKey:@"title"];
    dayName.text = [data stringForKey:@"dayName"];
    dayNumber.text = [data stringForKey:@"dayNumber"];
//    dayName.text = [[data stringValueFor:@"description"] stringByMatching:@"<b>(.*?)," capture:1L];
//    dayNumber.text = [NSString stringWithFormat:@"%d",[[[data stringValueFor:@"description"] stringByMatching:@"<b>.*?,\\s+\\w+\\s+(\\d+)," capture:1L] intValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
