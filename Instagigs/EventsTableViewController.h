//
//  EventsTableViewController.h
//  Instagigs
//
//  Created by Rahiem Klugh on 9/29/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProfile.h"

@interface EventsTableViewController : UITableViewController

//array of the passed events
@property(nonatomic, strong)NSMutableArray * eventsArray;
@property (strong, nonatomic) IBOutlet UITableView *detailsTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *eventsSegmentControl;
@property(nonatomic, strong) NSMutableDictionary *sharedEventsDictionary;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)eventsSegmentControlPressed:(id)sender;
@property (strong, nonatomic) IBOutlet JTHorizontalCalendarView *calendarView;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;

//presentingController
//@property(nonatomic, strong)MyProfile *sendingController;

@end
