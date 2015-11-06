//
//  uberCreateReportTableViewCell.m
//  Instagigs
//
//  Created by Jerry Phillips on 9/9/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "uberCreateReportTableViewCell.h"

@implementation uberCreateReportTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
    //Round the buttons in the view
    [self roundThoseButton:_uberButton];
    [self roundThoseButton:_dropGigButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)roundThoseButton: (UIButton *)button
{
    button.layer.cornerRadius = 25;
    button.layer.masksToBounds = YES;
}

@end
