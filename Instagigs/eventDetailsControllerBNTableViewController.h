//
//  eventDetailsControllerBNTableViewController.h
//  Instagigs
//
//  Created by Jerry Phillips on 8/28/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eventDetailsControllerBNTableViewController : UITableViewController <UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

// close the view completely

- (IBAction)killView:(UIBarButtonItem *)sender;

//if this array is populated it will be used to send a push notification to user scheduled for the event
@property (strong, nonatomic) NSArray *staffedPeopleToNotify;

@end
