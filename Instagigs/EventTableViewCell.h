//
//  EventTableViewCell.h
//  Instagigs
//
//  Created by Rahiem Klugh on 9/30/15.
//  Copyright © 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *EventTitle;
@property (strong, nonatomic) IBOutlet UILabel *venueName;
@property (strong, nonatomic) IBOutlet UIImageView *brandImage;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *cityState;
@property (strong, nonatomic) IBOutlet UILabel *payRate;
@property (strong, nonatomic) IBOutlet UILabel *jobTitle;

@end
