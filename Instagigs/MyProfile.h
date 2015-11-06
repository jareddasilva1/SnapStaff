//
//  MyProfile.h
//  Instagigs
//
//  Created by Jerry Phillips on 8/20/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JTCalendar/JTCalendar.h"

@interface MyProfile : UIViewController<JTCalendarDelegate, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet JTCalendarMenuView *month;

@property (strong, nonatomic) IBOutlet JTCalendarWeekDayView *weekDayView;

@property (strong, nonatomic) IBOutlet JTVerticalCalendarView *calendarView;

@property(strong, nonatomic) JTCalendarManager *calendarManager;

@property (strong, nonatomic) IBOutlet UITabBarItem *scheduledButton;

@property (strong, nonatomic) IBOutlet UITabBarItem *staffedButton;

@property (strong, nonatomic) IBOutlet UITabBarItem *completedButton;

@property (strong, nonatomic) IBOutlet UITabBarItem *createdButton;

@property (strong, nonatomic) IBOutlet UITabBar *gTabBar;

@property (strong, nonatomic) IBOutlet UITabBarItem *profileTab;
@property (strong, nonatomic) IBOutlet UITableView *detailsTableView;

// Initiallly hidden only shown it the tableview has left the view
@property (strong, nonatomic) IBOutlet UILabel *instructionLabelForCreatEvent;
@end
