//
//  confirmEventTableViewController.h
//  Instagigs
//
//  Created by Jerry Phillips on 8/27/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "eventObject.h"

@interface confirmEventTableViewController : UITableViewController
- (IBAction)close:(id)sender;

@property(strong,nonatomic)eventObject *theEvent;




@end
