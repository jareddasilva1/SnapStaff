//
//  EventsTableViewController.m
//  Instagigs
//
//  Created by Rahiem Klugh on 9/29/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "EventsTableViewController.h"
#import <Parse/Parse.h>
#import "Constants.h"
#import "InstagigSingelton.h"
#import "EventTableViewCell.h"

@interface EventsTableViewController ()
{
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    
    NSDate *_dateSelected;
    NSArray *searchArray;
}

@end


//Singleton for data nd methods that we will need
InstagigSingelton *shared_Data1;
BOOL isAvailable;
NSArray *images;
NSArray *titles;

@implementation EventsTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = INSTABLUE;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName :[UIColor whiteColor]};
    // get singleton set up
    shared_Data1 = [InstagigSingelton instagGigObject];
    isAvailable = NO;
    
    if (_eventsSegmentControl.selectedSegmentIndex == 0) //Available
    {
        isAvailable = YES;
    }
    else  //Completed
    {
        isAvailable = NO;
    }
    [self fetchEvents];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor colorWithRed:239/255 green:239/255 blue:244/255 alpha:0.08]];
    [self.searchBar setBackgroundImage:[[UIImage alloc]init]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadEvents) name:EVENTSUPDATED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadEvents) name:COMPLETED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newProfileCreatedAlert) name:SHOWAVAILABLE object:nil];
    
    titles = @[@"Fun in the Sun", @"Future on the set", @"Diamonds Dancing Event"];
    images = @[@"test1", @"test2", @"test3"];
    
    [self loadCalendar];
}



-(void)newProfileCreatedAlert
{
    
    
    UIAlertController * alert=  [UIAlertController
                                 alertControllerWithTitle:@"SnapStaff"
                                 message:@"SnapStaff Profile Created! Click on Available Events and request to be booked"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Ok"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             }];

    
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) loadCalendar
{
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    // Generate random events sort by date using a dateformatter for the demonstration
    [self createRandomEvents];
    
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    _calendarManager.settings.weekModeEnabled = YES;

    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarView];
    [_calendarManager setDate:[NSDate date]];
}


- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}


- (IBAction)didGoTodayTouch
{
    [_calendarManager setDate:_todayDate];
}

//- (IBAction)didChangeModeTouch
//{
//    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
//    [_calendarManager reload];
//    
//    CGFloat newHeight = 300;
//    if(_calendarManager.settings.weekModeEnabled){
//        newHeight = 70.;
//    }
//    
//    self._calendarViewHeight.constant = newHeight;
//    [self.view layoutIfNeeded];
//}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView


- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarView.date isTheSameMonthThan:dayView.date]){
        if([_calendarView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarView loadNextPageWithAnimation];
        }
        else{
            [_calendarView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-2];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:2];
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

- (void)createRandomEvents
{
    _eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:randomDate];
    }
}

//- (IBAction)didChangeModeTouch
//{
//    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
//    [_calendarManager reload];
//    
//    CGFloat newHeight = 300;
//    if(_calendarManager.settings.weekModeEnabled){
//        newHeight = 70.;
//    }
//    
//    self._calendarViewHeight.constant = newHeight;
//    [self.view layoutIfNeeded];
//}

-(void) viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

-(void) reloadEvents
{
    [_detailsTableView reloadData];
    [self setSearchBarText];
}

-(void) fetchEvents
{
    _eventsArray = [[NSMutableArray alloc] init];
    _sharedEventsDictionary = [[NSMutableDictionary alloc] init];
    
    [_eventsSegmentControl setTitle:@"Available" forSegmentAtIndex:0];
    
    if (isAvailable)
    {
         [shared_Data1 queryEvents];
        _sharedEventsDictionary = shared_Data1.scheduledEvents;
    }
    else
    {
         [shared_Data1 queryCompletedEvents];
        _sharedEventsDictionary = shared_Data1.completedEvents;
    }
}

-(void) setSearchBarText
{
        [self.searchBar setPlaceholder:[NSString stringWithFormat:@"Search %lu Events", (unsigned long)_sharedEventsDictionary.count]];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return _sharedEventsDictionary.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array;
    NSString* key;
    
    //NSMutableArray * localArray;
    // Return the number of rows in the section.
    array = [_sharedEventsDictionary allKeys];
    key =[array objectAtIndex:section];
    
    _eventsArray = [_sharedEventsDictionary objectForKey:key];
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchArray count];
        
    } else {
           return _eventsArray.count;
    }
    
    
 
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor lightGrayColor];
    header.textLabel.font = [UIFont fontWithName:@"OpenSansRegular" size:12.0];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentLeft;
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *array;
    
    array = [_sharedEventsDictionary allKeys];
    
    return [shared_Data1 orderTheDates:array :section];
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  PFObject *object = [_eventsArray objectAtIndex:indexPath.row];
    //
    ////    cell.eventName.text = object[BRANDNAME];
    ////    cell.time.text = [shared__Data dateFormatter:object[STARTTIME] justTime:YES numberic:NO];
    //     cell.textLabel.text = [NSString stringWithFormat:@"%@ at %@", object[BRANDNAME], [shared_Data1 dateFormatter:object[STARTTIME] justTime:YES numberic:NO]];
    NSArray *array;
    
    array = [shared_Data1.scheduledEvents allKeys];
    
    NSString* key =[array objectAtIndex:indexPath.section];
    
    NSMutableArray * localArray;
    
    localArray = [shared_Data1.scheduledEvents objectForKey:key];
    
    PFObject *object = [localArray objectAtIndex:indexPath.row];
    
    static NSString* CellIdentifier = @"eventsCell";
    EventTableViewCell* postingCell = (EventTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    // Configure the cell...
    if (postingCell == nil) {
        postingCell = [[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    postingCell.contentView.frame = postingCell.bounds;
    postingCell.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    postingCell.venueName.text = object[VENUENAME];
    postingCell.brandNameLabel.text = object[BRANDNAME];
    postingCell.time.text = [NSString stringWithFormat:@"%@ - %@",  [shared_Data1 dateFormatter:object[STARTTIME] justTime:YES numberic:NO], [shared_Data1 dateFormatter:object[ENDTIME] justTime:YES numberic:NO]];
    postingCell.brandImage.image = [shared_Data1 fetchBrandImage:object[BRANDNAME]];
    postingCell.EventTitle.text = object[EVENTTITLE];
    postingCell.cityState.text = [NSString stringWithFormat:@"%@. %@", object[CITY], object[STATE]];
    postingCell.payRate.text = [NSString stringWithFormat:@"$%@/hr", object[PAYRATE]];
    postingCell.jobTitle.text = object[JOBTITLE];
    
    return postingCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSArray *array;
    
    array = [shared_Data1.scheduledEvents allKeys];
    
    NSString* key =[array objectAtIndex:indexPath.section];
    
    NSMutableArray * localArray;
    
    localArray = [shared_Data1.scheduledEvents objectForKey:key];
    
    PFObject *object = [localArray objectAtIndex:indexPath.row];
    
    
   // InstagigSingelton *sharedData = [InstagigSingelton instagGigObject];
   
    //PFObject *object = [_eventsArray objectAtIndex:indexPath.row];
    

    //setting the singleton with the parse object
    shared_Data1.currentEvent.parseEventObject = object;
    //sharedData.scheduled = YES;
    
    shared_Data1.detailsType = VIEWSTAFF;
    
    if ([_ENVIRONMENT isEqualToString:@"TALENT"])
    {
        if (!isAvailable)
        {
            shared_Data1.detailsType = CREATEREPORT;
        }
    }
    else if ([_ENVIRONMENT isEqualToString:@"ADMIN"])
    {
        if (!isAvailable)
        {
            shared_Data1.detailsType = VIEWREPORT;
        }
    }
    //
    //
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"EventDetails" bundle: nil];
    //    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"@EventDetails"];
    //    [self showViewController:vc sender:self];
    //
    //
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"EventDetails" bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"@EventDetails"];
    UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController showViewController:passcodeNavigationController sender:self];
}


- (IBAction)eventsSegmentControlPressed:(id)sender {
    
    if (_eventsSegmentControl.selectedSegmentIndex == 0)
    {
        isAvailable = YES;
    }
    else
    {
        isAvailable = NO;
    }
    [self fetchEvents];
}
@end
