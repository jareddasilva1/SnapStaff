//
//  EventDetailsViewController.m
//  Instagigs
//
//  Created by Rahiem Klugh on 9/29/15.
//  Copyright © 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "Constants.h"
#import "InstagigSingelton.h"
#import <Parse/Parse.h>

@interface EventDetailsViewController ()

@end

InstagigSingelton *theDataShare1;
PFGeoPoint * point;

// staffed people array
NSMutableArray *staffedPeople;
NSMutableDictionary * staffImages;

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = INSTABLUE;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName :[UIColor whiteColor]};
    
    theDataShare1 = [InstagigSingelton instagGigObject];
    
    if (theDataShare1.detailsType == VIEWSTAFF)
    {
        
        UIBarButtonItem * edit = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEvent)];
        self.navigationItem.leftBarButtonItem = edit;
    }
    else
    {
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
        barButton.title = @"";
        self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    }
    
    _theEvent = theDataShare1.currentEvent;
    
    [self setupEventDetails];

    
//    if (theDataShare1.scheduled == YES)
//    {
//        
//        PFQuery * query = [PFQuery queryWithClassName:STAFFMANAGER];
//        
//        PFQuery *profiles = [PFUser query];
//        staffImages = [[NSMutableDictionary alloc] init];
//        
//        [query whereKey:EVENTOBJECT equalTo:_theEvent.parseEventObject.objectId];
//        [query whereKey:APPROVED notEqualTo:@YES];
//        [query whereKey:DECLINED notEqualTo:@YES];
//        
//        
//        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error)
//         {
//             if (!error)
//             {
//                 NSMutableArray *localArray = [[NSMutableArray alloc] init];
//                 
//                 for (PFObject * object in array)
//                 {
//                     [localArray addObject:object[STAFFEDPERSEON]];
//                 }
//                 [profiles whereKey:@"objectId" containedIn:localArray];
//                 [profiles findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError * error)
//                  {
//                      staffedPeople = [[NSMutableArray alloc]init];
//                      
//                      for (PFObject *object in objects)
//                      {
//                          InstagigUser *user = [[InstagigUser alloc] initWithParseUser:object];
//                          [staffedPeople addObject:user];
//                      }
//                  }];
//             }
//             
//         }];
//        
//    }
    

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popToRootView) name:NEWEVENTCREATED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(eventEdited) name:EVENTEDITED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteEvent) name:EVENTDELETED object:nil];

}

-(void)eventEdited
{
    [self viewDidLoad];
}


-(void)deleteEvent
{
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(cancelEvent) userInfo:nil repeats:NO];
}

-(void)cancelEvent
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupEventDetails
{
    switch (theDataShare1.detailsType) {
        case CREATEEVENT:
            [self setupCreateEventView];
            break;
        case VIEWSTAFF:
            [self setupViewStaffView];
            break;
        case VIEWSTAFF2:
            [self setupViewStaffView];
            break;
        case VIEWREPORT:
            [self setupViewReportView];
            break;
        case CREATEREPORT:
            [self setupCreateReportView];
            break;
            
        default:
            break;
    }
    
    
    self.transparentTopBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.transparentTopBar.layer.opacity = 0.6;
    self.transparentTopBar.layer.shadowOffset = CGSizeMake(0, 1);
    self.transparentTopBar.layer.shadowOpacity = 0.3;
    self.transparentTopBar.layer.shadowRadius = 4.0;
    self.transparentTopBar.clipsToBounds = NO;
    
    _spotsRemainingLabel.layer.cornerRadius = 12.5f;
    _spotsRemainingLabel.layer.masksToBounds = YES;
    
    
    _eventTitle.text = _theEvent.parseEventObject[BRANDNAME];
    self.title = _theEvent.parseEventObject[VENUENAME];
    
    
    _notes.text = [NSString stringWithFormat:@"Notes: %@", _theEvent.parseEventObject[NOTES]];
    _payRate.text = [NSString stringWithFormat:@"$%@/hr", _theEvent.parseEventObject[PAYRATE]];
    _jobTitle.text =_theEvent.parseEventObject[JOBTITLE];
    //Size to fit
//    self.title = @"Your TiTle Text";
//    UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 40)];
//    tlabel.text=self.navigationItem.title;
//    tlabel.textColor=[UIColor whiteColor];
//    tlabel.font = [UIFont fontWithName:@"Open Sans-Regular" size: 18.0];
//    tlabel.backgroundColor =[UIColor clearColor];
//    tlabel.adjustsFontSizeToFitWidth=YES;
//    self.navigationItem.titleView=tlabel;
    
    
    _timeLabel.text = [NSString stringWithFormat:@"%@ - %@",  [theDataShare1 dateFormatter:_theEvent.parseEventObject[STARTTIME] justTime:YES numberic:NO], [theDataShare1 dateFormatter:_theEvent.parseEventObject[ENDTIME] justTime:YES numberic:NO]];
    
    [_contactNumberButton setTitle: _theEvent.parseEventObject[CONTACTPHONE] forState:UIControlStateNormal];
    _venueAddress.text =  _theEvent.parseEventObject[EVENTADDRESS];
    _contactName.text = [NSString stringWithFormat:@"%@", _theEvent.parseEventObject[CONTACTPERSON]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"dd"];
    NSString*dayString = [df stringFromDate:_theEvent.parseEventObject[EVENTDATE]];
    
    [df setDateFormat:@"MMM"];
    NSString*monthString = [df stringFromDate:_theEvent.parseEventObject[EVENTDATE]];
    
    [df setDateFormat:@"yyyy"];
    NSString*yearString = [df stringFromDate:_theEvent.parseEventObject[EVENTDATE]];
    
    [df setDateFormat: @"EEEE"];
    NSString*dayOfWeekString = [df stringFromDate:_theEvent.parseEventObject[EVENTDATE]];
    
    _eventDate.text = [NSString stringWithFormat:@"%@, %@ %@, %@",dayOfWeekString,monthString,dayString,yearString];
    
    _eventType.text = _theEvent.parseEventObject[EVENTTYPE];
    
    _brandImage.image = [theDataShare1 fetchBrandImage:_theEvent.parseEventObject[BRANDNAME]];
    
    [self displayLocationOnMap];
}


-(void) setupViewStaffView
{
    _spotsLeftText.text = @"SPOTS LEFT";
    _spotsRemainingLabel.text = [_theEvent.parseEventObject[NUMBEROFTALENT] stringValue];
    [_bottomButtonCenter setTitle:@"VIEW STAFF" forState:UIControlStateNormal];
    
    UIBarButtonItem * edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editEvent)];
    self.navigationItem.rightBarButtonItem = edit;
}


-(void) setupViewReportView
{
    _spotsLeftText.hidden = YES;
    _spotsRemainingLabel.hidden = YES;
    [_bottomButtonCenter setTitle:@"VIEW REPORTS" forState:UIControlStateNormal];
}

-(void) setupCreateReportView
{
    _spotsLeftText.hidden = YES;
    _spotsRemainingLabel.hidden = YES;
    [_bottomButtonCenter setTitle:@"CREATE EVENT REPORT" forState:UIControlStateNormal];
}

-(void) editEvent
{
    theDataShare1.detailsType = EDITEVENT;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CreateEvent" bundle:nil];
    UINavigationController *navigationController1 = [storyboard instantiateInitialViewController];
    navigationController1.modalPresentationStyle = UIModalPresentationFormSheet;
    navigationController1.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:navigationController1 animated:YES completion:nil];
}

-(void) setupCreateEventView
{
    //Brand Image in corner

    _spotsLeftText.text = @"TALENT";
    _spotsRemainingLabel.text = [_theEvent.parseEventObject[NUMBEROFTALENT] stringValue];
    [_bottomButtonCenter setTitle:@"CREATE EVENT" forState:UIControlStateNormal];
    
}

-(void) setupRequestBookingView
{
    UIButton *btnNext1 =[[UIButton alloc] init];
    [btnNext1 setBackgroundImage:[UIImage imageNamed:@"directions-button"] forState:UIControlStateNormal];
    
    btnNext1.frame = CGRectMake(100, 100, 30, 25);
    UIBarButtonItem *btnNext =[[UIBarButtonItem alloc] initWithCustomView:btnNext1];
    [btnNext1 addTarget:self action:@selector(openMapsWithDirectionsTo:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = btnNext;
    
    _spotsRemainingLabel.text = [_theEvent.parseEventObject[NUMBEROFTALENT] stringValue];
}


- (void)displayLocationOnMap
{
    PFGeoPoint * mapPoint = _theEvent.parseEventObject[GEOPOINT];
    
    self.eventMapView.delegate = self;
    self.eventMapView.showsUserLocation = NO;
    
    CLLocationCoordinate2D deviceCoordinates = CLLocationCoordinate2DMake(mapPoint.latitude, mapPoint.longitude);
    MannyCustomAnnotation *deviceAnnotation = [[MannyCustomAnnotation alloc]initWithTitle:_theEvent.parseEventObject[VENUENAME] Location:deviceCoordinates];
    
    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(deviceCoordinates, 1000.0, 1000.0);
    
    [self.eventMapView addAnnotation:deviceAnnotation];
    
    // Show our location
    [self.eventMapView setRegion:zoomRegion animated:YES];
    
   // [self.locManager startUpdatingLocation];
    
}


- (void)openMapsWithDirectionsTo:(CLLocationCoordinate2D)to {
    
     PFGeoPoint * mapPoint = _theEvent.parseEventObject[GEOPOINT];

    CLLocationCoordinate2D endingCoord = CLLocationCoordinate2DMake(mapPoint.latitude, mapPoint.longitude);
    MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:endingCoord addressDictionary:nil];
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:endLocation];
    
    NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
    [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
    
    [endingItem openInMapsWithLaunchOptions:launchOptions];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)callContactNumber:(id)sender {
    
    NSString *phone = [NSString stringWithFormat:@"tel:%@", _theEvent.parseEventObject[CONTACTPHONE]];
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
     // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://2135554321"]];
}
- (IBAction)bottomButtonPressed:(id)sender {
    
    if (theDataShare1.detailsType == VIEWSTAFF || theDataShare1.detailsType == VIEWSTAFF2 || theDataShare1.detailsType == VIEWREPORT) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ViewStaff" bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"@ViewStaff"];
        [self showViewController:vc sender:self];
    }
    
    if (theDataShare1.detailsType == CREATEEVENT)
    {
        [theDataShare1 createEventInParse];
    }
    if (theDataShare1.detailsType == CREATEREPORT) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CreateReport" bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"@CreateReport"];
        [self showViewController:vc sender:self];
    }
}



-(void) popToRootView
{
   [self.navigationController popViewControllerAnimated:YES];  
}

@end
