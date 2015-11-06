//
//  MyProfile.m
//  Instagigs
//
//  Created by Jerry Phillips on 8/20/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "MyProfile.h"
#import "Constants.h"
#import "InstagigSingelton.h"
#import "eventDatailsTableViewCell.h"
#import "talentViewController.h"
#import "eventViewTableViewController.h"
#import "EventTableViewCell.h"
#import "SVProgressHUD.h"


@interface MyProfile ()
{
    //NSMutableDictionary *_eventsByDate;
    
    NSDate *_dateSelected;
}

@end




InstagigSingelton *shared__Data;

BOOL hiddenTB;

//used to set the rect of the halfsized tableview that is displayed onscreen
CGRect halfsizeTableView;
//used to set the rect of the fullSized tableview that is displayed onscreen
CGRect fullscreenTableview;

//Constraints of the tableview
NSArray *tbconstraints;
NSArray *images1;
NSArray *titles1;


@implementation MyProfile

- (void)viewDidLoad {
    
    titles1 = @[@"Fun in the Sun", @"Future on the set", @"Diamonds Dancing Event"];
    images1 = @[@"test1", @"test2", @"test3"];
    
    [super viewDidLoad];
    shared__Data = [InstagigSingelton instagGigObject];

    PFUser *currentUser = [PFUser currentUser];

    _instructionLabelForCreatEvent.hidden = NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popoverSegue) name:PUSHPCONTROLLER object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadEvents) name:EVENTSUPDATED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadEvents) name:COMPLETED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fetchEvents) name:EVENTDELETED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showCreateEventView) name:SHOWCREATEEVENT object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fetchEvents) name:NEWEVENTCREATED object:nil];
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showSettingsView) name:SHOWSETTINGS object:nil];


    _detailsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];  //Remove the extra cells
    [shared__Data queryEvents];
    [shared__Data saveBrandImagesToDevice];
     shared__Data.scheduled = YES;
    
    if ([currentUser[ISADMIN] isEqual:@YES])
    {
        _scheduledButton.tag = 0;
        
        _staffedButton.tag = 1;
        
        _completedButton.tag = 2;
        
        _createdButton.tag = 3;
        _gTabBar.selectedItem = _scheduledButton;
        
        _profileTab.tag = 8;
        
    }
    else
    {
        _gTabBar.selectedItem = _scheduledButton;
        [ _scheduledButton  setTitle:@"My Gigs" ];
        _scheduledButton.tag = 4;
        
        [_staffedButton setTitle:@"Available"];
        _staffedButton.tag = 5;
        
        [_completedButton setTitle:@"Completed"];
        _completedButton.tag = 6;
        
        _createdButton.tag = 7;
        [_createdButton setTitle:@"My Profile"];
        [_createdButton setImage: [UIImage imageNamed:@"profile_normal"]];
        [_createdButton setSelectedImage:[UIImage imageNamed:@"profile_normal"]];
        
        _profileTab.tag = 9;
       
    }
     [self tabBar:_gTabBar didSelectItem:_scheduledButton];

   // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
       _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadCalendar) name:EVENTSUPDATED object:nil];
    _calendarManager.settings.pageViewHaveWeekDaysView = NO;
    _calendarManager.settings.pageViewNumberOfWeeks = 0; // Automatic
    //_detailsTableView.estimatedRowHeight = 72;
    _detailsTableView.rowHeight = UITableViewAutomaticDimension;

    _weekDayView.manager = _calendarManager;
    //_calendarManager.settings.weekModeEnabled = YES;
    
    [_weekDayView reload];
    
    [_calendarManager setMenuView:_month];
    [_calendarManager setContentView:_calendarView];
    [_calendarManager setDate:[NSDate date]];
    
    _month.scrollView.scrollEnabled = NO; // Scroll not supported with JTVerticalCalendarView
    
    _calendarView.backgroundColor = [UIColor clearColor];
    _weekDayView.backgroundColor = [UIColor clearColor];
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 85;
}

-(void) viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

-(void) showCreateEventView
{
    shared__Data.detailsType = CREATEEVENT;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CreateEvent" bundle:nil];
    UINavigationController *navigationController1 = [storyboard instantiateInitialViewController];
    navigationController1.modalPresentationStyle = UIModalPresentationFormSheet;
    navigationController1.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:navigationController1 animated:YES completion:nil];
}

-(void) showSettingsView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    UINavigationController *navigationController1 = [storyboard instantiateInitialViewController];
    navigationController1.modalPresentationStyle = UIModalPresentationFormSheet;
    navigationController1.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:navigationController1 animated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    halfsizeTableView = CGRectMake(_detailsTableView.frame.origin.x, _detailsTableView.frame.origin.y, _detailsTableView.frame.size.width, _detailsTableView.frame.size.height);
    
    
    // expand the tableview to be full screen, we are leaving some spacing at the top for the ios menu bar, it just looks weird without it
    fullscreenTableview = CGRectMake(0, 20, _detailsTableView.frame.size.width, self.view.frame.size.height - (_gTabBar.frame.size.height + 20));
    
    //reload the view just incase data has been updated
     [self tabBar:_gTabBar didSelectItem:_scheduledButton];
}

//when the data from parse is downloaded for scheduled events this is the method called by NSnotification center
-(void)reloadEvents
{
    [_detailsTableView reloadData];
}

-(void) fetchEvents
{
    [shared__Data queryEvents];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (shared__Data.scheduled == YES || shared__Data.available == YES)
    {
        return shared__Data.scheduledEvents.count;
    }
    if (shared__Data.myGigs == YES)
    {
        return shared__Data.theUser.myScheduledSnapGigs.count;
    }
    if (shared__Data.talentCompleted == YES)
    {
        return shared__Data.theUser.myCompletedSnapGigs.count;
    }
    if (shared__Data.completed == YES)
    {
        return shared__Data.completedEvents.count;
    }
    if (shared__Data.staffed == YES)
    {
        return shared__Data.staffedEvents.count;
    }
    return 0;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array;
    NSString* key;
    
    NSMutableArray * localArray;
    
    if (shared__Data.scheduled == YES || shared__Data.available == YES)
    {
        array = [shared__Data.scheduledEvents allKeys];
        key =[array objectAtIndex:section];
        
        localArray = [shared__Data.scheduledEvents objectForKey:key];
        
        return localArray.count;
    }
    if (shared__Data.myGigs == YES)
    {
        array = [shared__Data.theUser.myScheduledSnapGigs allKeys];
        key =[array objectAtIndex:section];
        
        localArray = [shared__Data.theUser.myScheduledSnapGigs objectForKey:key];
        
        return localArray.count;
    }
    
    if(shared__Data.talentCompleted == YES)
    {
        array = [shared__Data.theUser.myCompletedSnapGigs allKeys];
        key =[array objectAtIndex:section];
        
        localArray = [shared__Data.theUser.myCompletedSnapGigs objectForKey:key];
        
        return localArray.count;
    }
    if (shared__Data.completed == YES)
    {
        array = [shared__Data.completedEvents allKeys];
        key =[array objectAtIndex:section];
        
        localArray = [shared__Data.completedEvents objectForKey:key];
        
        return localArray.count;
    }
    if(shared__Data.staffed == YES)
    {
        array = [shared__Data.staffedEvents allKeys];
         key =[array objectAtIndex:section];
        localArray = [shared__Data.staffedEvents objectForKey:key];
        return localArray.count;
    }
    
    return 0;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *array;
    
    
    if (shared__Data.available == YES || shared__Data.scheduled == YES) {
        array = [shared__Data.scheduledEvents allKeys];
    }
    
    if (shared__Data.myGigs == YES)
    {
        array = [shared__Data.theUser.myScheduledSnapGigs allKeys];
    }
    if (shared__Data.talentCompleted == YES)
    {
        array = [shared__Data.theUser.myCompletedSnapGigs allKeys];
    }
    if (shared__Data.completed == YES)
    {
          array = [shared__Data.completedEvents allKeys];
    }
    if (shared__Data.staffed == YES)
    {
        array = [shared__Data.staffedEvents allKeys];
    }



 
    
    return [shared__Data orderTheDates:array :section];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"eventsCell";
    EventTableViewCell* postingCell = (EventTableViewCell*)[_detailsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    // Configure the cell...
    if (postingCell == nil) {
        postingCell = [[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    postingCell.contentView.frame = postingCell.bounds;
    postingCell.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
//    
//    
//    postingCell.venueName.text = object[VENUENAME];
//    postingCell.brandNameLabel.text = object[BRANDNAME];
//    postingCell.brandImage.image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
//    postingCell.EventTitle.text = [titles objectAtIndex:indexPath.row];

    
    NSArray *array;
    
    if (shared__Data.available == YES || shared__Data.scheduled == YES) {
        array = [shared__Data.scheduledEvents allKeys];
    }
    
    if (shared__Data.myGigs == YES)
    {
        array = [shared__Data.theUser.myScheduledSnapGigs allKeys];
    }
    if (shared__Data.talentCompleted == YES)
    {
        array = [shared__Data.theUser.myCompletedSnapGigs allKeys];
    }
    if (shared__Data.completed == YES)
    {
        array = [shared__Data.completedEvents allKeys];
    }
    if (shared__Data.staffed == YES)
    {
        array = [shared__Data.staffedEvents allKeys];
    }
    
    NSString* key =[array objectAtIndex:indexPath.section];
    
    NSMutableArray * localArray;
    
    if (shared__Data.available == YES || shared__Data.scheduled == YES) {
        localArray = [shared__Data.scheduledEvents objectForKey:key];
    }
   
    if (shared__Data.myGigs == YES)
    {
        localArray = [shared__Data.theUser.myScheduledSnapGigs objectForKey:key];
    }
    if (shared__Data.talentCompleted == YES)
    {
        localArray = [shared__Data.theUser.myCompletedSnapGigs objectForKey:key];
    }
    
    if (shared__Data.completed == YES)
    {
        localArray = [shared__Data.completedEvents objectForKey:key];
    }
    if (shared__Data.staffed == YES)
    {
        localArray = [shared__Data.staffedEvents objectForKey:key];
    }
    
    
    PFObject *object = [localArray objectAtIndex:indexPath.row];
    
    postingCell.venueName.text = object[VENUENAME];
    postingCell.brandNameLabel.text = object[BRANDNAME];
    postingCell.time.text = [NSString stringWithFormat:@"%@ - %@",  [shared__Data dateFormatter:object[STARTTIME] justTime:YES numberic:NO], [shared__Data dateFormatter:object[ENDTIME] justTime:YES numberic:NO]];
    postingCell.brandImage.image = [shared__Data fetchBrandImage:object[BRANDNAME]];
    postingCell.EventTitle.text = object[EVENTTITLE];
    postingCell.cityState.text = [NSString stringWithFormat:@"%@. %@", object[CITY], object[STATE]];
    postingCell.payRate.text = [NSString stringWithFormat:@"$%@/hr", object[PAYRATE]];
    postingCell.jobTitle.text = object[JOBTITLE];
    
    return postingCell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *array;
    NSString* key;
    NSMutableArray * localArray;
    
    if (shared__Data.scheduled == YES || shared__Data.available == YES)
    {
        array = [shared__Data.scheduledEvents allKeys];
        key = [array objectAtIndex:indexPath.section];
        
        localArray = [shared__Data.scheduledEvents objectForKey:key];
    }
    
    if (shared__Data.myGigs == YES)
    {
        array = [shared__Data.theUser.myScheduledSnapGigs allKeys];
        key = [array objectAtIndex:indexPath.section];
        
        localArray = [shared__Data.theUser.myScheduledSnapGigs objectForKey:key];
    }

    if (shared__Data.talentCompleted == YES)
    {
        array = [shared__Data.theUser.myCompletedSnapGigs allKeys];
        key = [array objectAtIndex:indexPath.section];
        
        localArray = [shared__Data.theUser.myCompletedSnapGigs objectForKey:key];
    }
    
    if (shared__Data.completed == YES)
    {
        array = [shared__Data.completedEvents allKeys];
        key = [array objectAtIndex:indexPath.section];
        
        localArray = [shared__Data.completedEvents objectForKey:key];
    }
    
    PFObject *object = [localArray objectAtIndex:indexPath.row];
    
    shared__Data.currentEvent.parseEventObject = object;
    
   // [self performSegueWithIdentifier:@"eventDetailsAdmin" sender:self];
    [self showEventDetails];
}


-(void) showEventDetails
{
    shared__Data.detailsType = VIEWSTAFF;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"EventDetails" bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"@EventDetails"];
    UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController showViewController:passcodeNavigationController sender:self];
}

-(void)reloadCalendar
{
    [_calendarManager reload];
    
    [_detailsTableView reloadData];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //minimize tableview on the create event tab
    if (item.tag == 3 && hiddenTB == NO)
    {
        _calendarView.hidden = NO;
        _instructionLabelForCreatEvent.alpha = 0;
        [UIView animateWithDuration:1.0 animations:^{
            _detailsTableView.frame = CGRectMake(0, _detailsTableView.frame.origin.y + _detailsTableView.frame.size.height, _detailsTableView.frame.size.width, _detailsTableView.frame.size.height);
            
            _instructionLabelForCreatEvent.hidden = NO;
            _instructionLabelForCreatEvent.alpha = 1;
        } completion:^(BOOL finished)
        {
            
            hiddenTB = YES;
        }];
    }
    if (hiddenTB == YES && item.tag != 3)
    {
        [UIView animateWithDuration:1.0 animations:^{
            _detailsTableView.frame = CGRectMake(0, _detailsTableView.frame.origin.y - _detailsTableView.frame.size.height, _detailsTableView.frame.size.width, _detailsTableView.frame.size.height);
            _instructionLabelForCreatEvent.hidden = YES;
            
        } completion:^(BOOL finished)
        {
            hiddenTB = NO;
        }];
    }
    
    
    
    
    
    switch (item.tag)
    {
        case 0:
            shared__Data.createEvent = NO;
            shared__Data.scheduled = YES;
            shared__Data.staffed = NO;
            shared__Data.completed = NO;
            [self reloadCalendar];
            [self halfSizedTableview];
            
            
            break;
            
        case 1:
            shared__Data.createEvent = NO;
            shared__Data.scheduled = NO;
            shared__Data.staffed = YES;
            shared__Data.completed = NO;
            [self fullSizedTableview];
            [self reloadCalendar];
            
            
            break;
            
        case 2:
            shared__Data.createEvent = NO;
            shared__Data.scheduled = NO;
            shared__Data.staffed = NO;
            shared__Data.completed = YES;
            [self reloadCalendar];
            [self fullSizedTableview];
            
            break;
            
        case 3:
        
            shared__Data.createEvent = YES;
            shared__Data.scheduled = NO;
            shared__Data.staffed = NO;
            shared__Data.completed = NO;
            [_calendarManager reload];
        
    
            break;
            
        case 4:
            
            shared__Data.myGigs = YES;
            shared__Data.available = NO;
            shared__Data.myProfile = NO;
            shared__Data.talentCompleted = NO;
            
            [self reloadCalendar];
            break;
            
        case 5:
            shared__Data.myGigs = NO;
            shared__Data.available = YES;
            shared__Data.myProfile = NO;
            shared__Data.talentCompleted = NO;
            //query events as user looks for them to keep them current
            [shared__Data queryEvents];
            [self reloadCalendar];
            [self fullSizedTableview];
            break;
        case 6:
            shared__Data.myGigs = NO;
            shared__Data.available = NO;
            shared__Data.myProfile = NO;
            shared__Data.talentCompleted = YES;
            [self reloadCalendar];
            break;
            
        case 7:
            [self performSegueWithIdentifier:@"talentProfile" sender:self];
            break;
            
        case 8:
            [self performSegueWithIdentifier:@"notifications" sender:self];
            break;
            
            
        default:
            break;
    }
}



#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
   
    
    // Hide if from another month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = INSTABLUE;
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor whiteColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = INSTABLUE;
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = INSTABLUE;
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
        
        if (shared__Data.scheduled == YES)
        {
            dayView.dotView.backgroundColor= [UIColor whiteColor];
        }
        if (shared__Data.available == YES)
        {
            dayView.dotView.backgroundColor = GREEN;
        }
        if (shared__Data.myGigs == YES)
        {
            dayView.dotView.backgroundColor= [UIColor whiteColor];
        }
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

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
    // push view to create an event
    if (shared__Data.createEvent == YES)
    {
        shared__Data.currentEvent.parseEventObject[EVENTDATE] = _dateSelected;
        
        [self performSegueWithIdentifier:@"newEvent" sender:self];
    }
    //show popover of available events
    if (shared__Data.scheduled == YES || shared__Data.available == YES || shared__Data.myGigs == YES)
    {
        // init the popover
        eventViewTableViewController *popover = [[eventViewTableViewController alloc] init];
        
        
        // place where we want to see the popover
        popover.popoverPresentationController.sourceView = dayView;
        
       
        if (shared__Data.scheduledEvents[[shared__Data dateFormatter:dayView.date justTime:NO numberic:NO]] != nil && shared__Data.scheduled == YES )
        {
            
            
            // init the array for the popover
            popover.eventsArray = shared__Data.scheduledEvents[[shared__Data dateFormatter:dayView.date justTime:NO numberic:NO]];
            
        
         
            
            
            //set the popover size
            popover. preferredContentSize = CGSizeMake(250, 44 * popover.eventsArray.count);
            [self presentViewController:popover animated:YES completion:nil];
            
        }
        else
        {
            if (shared__Data.theUser.myScheduledSnapGigs[[shared__Data dateFormatter:dayView.date justTime:NO numberic:NO]] != nil)
            {
            
                popover.eventsArray = shared__Data.theUser.myScheduledSnapGigs[[shared__Data dateFormatter:dayView.date justTime:NO numberic:NO]];
                
                //set the popover size
                popover. preferredContentSize = CGSizeMake(250, 44 * popover.eventsArray.count);
                
                [self presentViewController:popover animated:YES completion:nil];
            }
        }
    }
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

// Used only to have a key for _eventsByDate
//- (NSDateFormatter *)dateFormatter
//{
//    static NSDateFormatter *dateFormatter;
//    if(!dateFormatter){
//        dateFormatter = [NSDateFormatter new];
//        dateFormatter.dateFormat = @"dd-MM-yyyy";
//    }
//    
//    return dateFormatter;
//}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [shared__Data dateFormatter:date justTime:NO numberic:NO];
    
    
    if (shared__Data.scheduled == YES || shared__Data.available == YES)
    {
        if(shared__Data.scheduledEvents[key] != nil)
        {
            return YES;
        }
    }
    if (shared__Data.myGigs == YES)
    {
        if(shared__Data.theUser.myScheduledSnapGigs[key] != nil)
        {
            return YES;
        }
    }
 
        
    
    
    return NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([segue.identifier isEqualToString: @"talentProfile"])
    {
        talentViewController *go = segue.destinationViewController;
        
       go.the_CurrentUser = shared__Data.theUser;
        
    }
    
    
}

-(void)popoverSegue
{
    [self showEventDetails];
}

-(void) halfSizedTableview
{
    // set the tableview halfsized to view
    
    if (_calendarView.hidden == YES)
    {
        _calendarView.hidden = NO;
        
        _weekDayView.hidden = NO;
        
       
        
        [UIView animateWithDuration:.50 animations:^{
            
            
             _detailsTableView.frame = halfsizeTableView;
        } completion:nil];
        //_detailsTableView.frame = halfsizeTableView;
    }
    
}

-(void)fullSizedTableview
{
    // set the tableview to full size and hide the calendar elements
    
    // we want a full screen tableview for this view
    _calendarView.hidden = YES;

    _weekDayView.hidden = YES;
    
    [UIView animateWithDuration:.50 animations:^
    {
        _detailsTableView.frame = fullscreenTableview;

    } completion:nil];

}

@end
