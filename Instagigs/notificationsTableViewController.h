
//
//  notificationsTableViewController.h
//  Instagigs
//
//  Created by Jerry Phillips on 9/2/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface notificationsTableViewController : UITableViewController <MGSwipeTableCellDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
//- (IBAction)closeThisView:(id)sender;

@end
