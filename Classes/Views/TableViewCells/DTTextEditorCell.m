//
//  DTTextEditorCell.m
//  ProLog
//
//  Created by Christopher Garrett on 10/6/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "DTTextEditorCell.h"


@implementation DTTextEditorCell

@synthesize textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
