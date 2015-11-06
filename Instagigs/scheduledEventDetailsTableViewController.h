//
//  scheduledEventDetailsTableViewController.h
//  Instagigs
//
//  Created by Jerry Phillips on 9/9/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface scheduledEventDetailsTableViewController : UITableViewController


@property(nonatomic, strong)PFObject *objectOfEvent;

//dismiss this view
- (IBAction)closeTheView:(id)sender;

//this is an array for staff that has been assigned to the event


@end
