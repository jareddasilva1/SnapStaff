//
//  ViewStaffTableViewCell.h
//  Instagigs
//
//  Created by Rahiem Klugh on 10/8/15.
//  Copyright © 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewStaffTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *age;

@end
