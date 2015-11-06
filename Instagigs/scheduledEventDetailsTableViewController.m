
//
//  scheduledEventDetailsTableViewController.m
//  Instagigs
//
//  Created by Jerry Phillips on 9/9/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

//This view will be used to display the details for the scheduled events, previously I was reusing the same views but as the app began to change This approch is much better

#import "scheduledEventDetailsTableViewController.h"
#import "mapCellTableViewCell.h"
#import "eventInfoTableViewCell.h"
#import "noteTableViewCell.h"
#import "uberCreateReportTableViewCell.h"
#import "signInButtonCell.h"
#import "InstagigSingelton.h"
#import "MGSwipeTableCell.h"
#import <MapKit/MapKit.h>



#import "Constants.h"

@interface scheduledEventDetailsTableViewController ()

@end
NSMutableArray *staffObjects;
NSMutableDictionary * dictionaryImages;
@implementation scheduledEventDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    InstagigSingelton *sharedData = [InstagigSingelton instagGigObject];
    _objectOfEvent = sharedData.currentEvent.parseEventObject;
    
    //title the event from the event details of the passed pfObject
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    
    self.navigationItem.title = _objectOfEvent[BRANDNAME];
    
    if ([[PFUser currentUser][ISADMIN] isEqual:@YES])
    {        
        
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    //if client side there is an additional section for event staff
    if ([[PFUser currentUser][ISADMIN] isEqual:@YES]) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    
    //We are checking if the current logged in user is an admin
    if ([[PFUser currentUser][ISADMIN] isEqual:@YES]) {
        
        switch (section) {
            case 0:
                if (_objectOfEvent[NOTES] != nil)
                {
                    return 3;
                }
                else
                {
                    return 2;
                }
                break;
                
            default:
                return staffObjects.count + 1;
                break;
        }
    }
    if (_objectOfEvent[NOTES] == nil)
    {
        return  4;
    }
    return 5;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor lightGrayColor];
    header.textLabel.font = [UIFont fontWithName:@"OpenSansRegular" size:12.0];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    return 35.0;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1 && staffObjects.count >0)
    {
        
        return  @"STAFF";
    }
    
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //we will need some methods from the instagigSingelton
    
    InstagigSingelton *sharedData = [InstagigSingelton instagGigObject];
    
    // Configure the cell...
    
    eventInfoTableViewCell * eventCell = [tableView dequeueReusableCellWithIdentifier:@"eventInfoTableViewCell"];
    noteTableViewCell *notesCell = [tableView dequeueReusableCellWithIdentifier:@"noteTableViewCell"];
    signInButtonCell *confirmOrEditCell = [tableView dequeueReusableCellWithIdentifier:@"signInButtonCell"];
    mapCellTableViewCell *mapCell = [tableView dequeueReusableCellWithIdentifier:@"mapCellTableViewCell"];
    MGSwipeTableCell *staffCell = [tableView dequeueReusableCellWithIdentifier:@"MGSwipeTableCell"];
    //staff cell for staffed events
    
    // we will only alloc the uber cell in the user is not an admin
    uberCreateReportTableViewCell *uberCell;
    
    if (![[PFUser currentUser][ISADMIN] isEqual:@YES]) {
        uberCell = [tableView dequeueReusableCellWithIdentifier:@"uberCreateReportTableViewCell"];
        
        if (uberCell == nil)
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"uberCreateReportTableViewCell" owner:self options:nil];
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    uberCell =  (uberCreateReportTableViewCell *) currentObject;
                    break;
                }
            }
        }
    }
    
    //instatiate cells if they are nil
    
    if (eventCell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"eventInfoTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                eventCell =  (eventInfoTableViewCell *) currentObject;
                break;
            }
        }
    }
    
    if (notesCell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"noteTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                notesCell =  (noteTableViewCell *) currentObject;
                break;
            }
        }
    }
    
    if (confirmOrEditCell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"signInButtonCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                confirmOrEditCell =  (signInButtonCell *) currentObject;
                break;
            }
        }
    }
    
    if (mapCell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"mapCellTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                mapCell =  (mapCellTableViewCell *) currentObject;
                break;
            }
        }
    }
    
    if (staffCell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"notificationsTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                staffCell =  (MGSwipeTableCell *) currentObject;
                break;
            }
        }
    }
    
    //lets grab the geopoint from our parse object and use it to set the view for our map
    PFGeoPoint *point;
    
    //we need a cllocation to set the view for the map
    //CLLocationCoordinate2D location;
    
    MKCoordinateRegion region;
    if (indexPath.section == 0)
    {
        

    
    switch (indexPath.row)
    {
        case 0:
            // setup the eventdetails cell with information from the object
            eventCell.dateLabel.text = [sharedData dateFormatter:_objectOfEvent[EVENTDATE] justTime:NO numberic:NO];
            eventCell.startLabel.text = [sharedData dateFormatter:_objectOfEvent[STARTTIME] justTime:YES numberic:NO];
            eventCell.endLabel.text = [sharedData dateFormatter:_objectOfEvent[ENDTIME] justTime:YES numberic:NO];
            eventCell.eventTypeLabel.text = _objectOfEvent[EVENTTYPE];
            //admin side sees 
            eventCell.numberOfTalent.text = [_objectOfEvent[NUMBEROFTALENT] stringValue];
            
            //We change the text if the user is on the talent side
            if (![[PFUser currentUser][ISADMIN] isEqual:@YES])
            {
                eventCell.numberOfTalent.text = @"# SPOTS REMAINING:";
            }
            
            return eventCell;
            break;
            
        case 1:
            //setup notes cell
            
            if (_objectOfEvent[NOTES] != nil) {
                notesCell.notes.text = _objectOfEvent[NOTES];
                return notesCell;
            }
            else{
                // setup mapcell
                if (_objectOfEvent[NOTES] != nil) {
                    
                    mapCell.venueName.text = _objectOfEvent[VENUENAME];
                    mapCell.venueAddress.text =_objectOfEvent[EVENTADDRESS];
                    
                    mapCell.phoneNumberOfVenue.text = _objectOfEvent[PHONENUMBER];
                    point = _objectOfEvent[GEOPOINT];
                    //location = CLLocationCoordinate2DMake(point.latitude, point.longitude);
                    
                    region.center.longitude = point.longitude;
                    region.center.latitude = point.latitude;
                    region.span.latitudeDelta = 0.00725;
                    region.span.longitudeDelta = 0.00725;
                    
                    
                    // Set pin for the location
                    mapCell.pin = [[MKPointAnnotation alloc] init];
                    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(point.latitude, point.longitude);
                    [mapCell.pin setCoordinate:coord];
                    
                    
                    
                    [mapCell.mapOfVenue setRegion:region animated:YES];
                    [mapCell.mapOfVenue addAnnotation:mapCell.pin];
                    mapCell.mapOfVenue.userInteractionEnabled = NO;
                    return mapCell;
                }

            }
        
                
        case 2:
            // setup mapcell
            if (_objectOfEvent[NOTES] != nil) {

            mapCell.venueName.text = _objectOfEvent[VENUENAME];
            mapCell.venueAddress.text =_objectOfEvent[EVENTADDRESS];
            
            mapCell.phoneNumberOfVenue.text = _objectOfEvent[PHONENUMBER];
            point = _objectOfEvent[GEOPOINT];
            //location = CLLocationCoordinate2DMake(point.latitude, point.longitude);
            
            region.center.longitude = point.longitude;
            region.center.latitude = point.latitude;
            region.span.latitudeDelta = 0.00725;
            region.span.longitudeDelta = 0.00725;
            
            
            // Set pin for the location
            mapCell.pin = [[MKPointAnnotation alloc] init];
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(point.latitude, point.longitude);
            [mapCell.pin setCoordinate:coord];
            
            
            
            [mapCell.mapOfVenue setRegion:region animated:YES];
            [mapCell.mapOfVenue addAnnotation:mapCell.pin];
            mapCell.mapOfVenue.userInteractionEnabled = NO;
             return mapCell;
            }
            else
            {
                if(![[PFUser currentUser][ISADMIN] isEqual:@YES])
                {
                    //add targets for the ubercell buttons
                    uberCell.uberButton.tag = 0;
                    [uberCell.uberButton addTarget:self action:@selector(buttonClicks:) forControlEvents:UIControlEventTouchUpInside];
                    uberCell.dropGigButton.tag = 1;
                    [uberCell.dropGigButton addTarget:self action:@selector(buttonClicks:) forControlEvents:UIControlEventTouchUpInside];
                    return uberCell;
                }
            }
            
            break;
             
        case 3:
             
             //again if the user is an admin we will return the correct cell accordingly
             if((![[PFUser currentUser][ISADMIN] isEqual:@YES]) && _objectOfEvent[NOTES] != nil)
             {
                 //add targets for the ubercell buttons
                 uberCell.uberButton.tag = 0;
                 [uberCell.uberButton addTarget:self action:@selector(openUberAppWithLatiude:longitude:) forControlEvents:UIControlEventTouchUpInside];
                 uberCell.dropGigButton.tag = 1;
                 [uberCell.dropGigButton addTarget:self action:@selector(buttonClicks:) forControlEvents:UIControlEventTouchUpInside];
                 return uberCell;
             }
             else{
                 if(![[PFUser currentUser][ISADMIN] isEqual:@YES])
                 {
                     if (sharedData.myGigs == YES) {
                         confirmOrEditCell.label.text = @"CREATE REPORT";
                         confirmOrEditCell.backgroundColor = INSTABLUE;
                         
                     }
                     else
                     confirmOrEditCell.label.text = @"REQUEST BOOKING";
                     
                     return  confirmOrEditCell;
                 }
             }
            break;
        case 4:
            
            //return the submmit button
            if(![[PFUser currentUser][ISADMIN] isEqual:@YES])
            {
                if (sharedData.myGigs == YES) {
                    confirmOrEditCell.label.text = @"CREATE REPORT";
                    confirmOrEditCell.backgroundColor = INSTABLUE;
                }
                else
                    confirmOrEditCell.label.text = @"REQUEST BOOKING";
                
                return  confirmOrEditCell;
            }
                break;
                
            default:
                break;
        }
        
    }
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == staffObjects.count) {
            confirmOrEditCell.label.text = @"EDIT";
            
            return confirmOrEditCell;
        }
        else
        {
            PFObject *object = [staffObjects objectAtIndex:indexPath.row];
            
            staffCell.nameOfTalent.text = [NSString stringWithFormat:@"%@, %@", object[FIRSTNAME], [object[LASTNAME] substringToIndex:1]];
            
            staffCell.profileImage_View.layer.cornerRadius = staffCell.profileImage_View.frame.size.width/2;
            staffCell.profileImage_View.layer.masksToBounds = YES;
            staffCell.profileImage_View.layer.borderColor = INSTABLUE.CGColor;
            staffCell.profileImage_View.layer.borderWidth = 1;
            
            if ([dictionaryImages objectForKey: object.objectId] != nil)
            {
                staffCell.profileImage_View.image = [dictionaryImages objectForKey: object.objectId];
            }
            else
            {
                PFFile *imageFile = object[PROFILE1];
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
                 {
                     if (!error)
                     {
                         UIImage *image = [UIImage imageWithData:data];
                         [dictionaryImages setObject:image forKey:object.objectId];
                         NSArray *paths = [NSArray arrayWithObject:indexPath];
                         [self.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
                     }
                     
                 }];
            }
            return staffCell;
        }
    }
    

    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_objectOfEvent[NOTES] != nil ) {
        if (indexPath.row == 3)
        {
            [self performSegueWithIdentifier:@"createReport" sender:nil];
        }
    }
    else
    {
        if (indexPath.row == 4)
        {
            [self performSegueWithIdentifier:@"createReport" sender:nil];
        }
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView performWithoutAnimation:^{
        [cell layoutIfNeeded];
    }];
}

//Dismiss the view
- (IBAction)closeTheView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/**
 * Opens the Maps application with the destination already set.
 * @param latitude Latitude coordinate for the destination.
 * @param longitude Longitude coordinate for the destination.
 */
- (void)openAppleMaps:(double)latitude longitude:(double)longitude
{
    // Create the placemark
    MKPlacemark* placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) addressDictionary:nil];
    
    // Create a new map item using the placemark
    MKMapItem* mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    
    // Set the item's name
    [mapItem setName:@"Destination"];
    
    // Open the item in Maps with driving directions mode enabled
    [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
}

/**
 * Opens the Uber application (if found) with the destination already set.
 * If the application is not found, the App Store Uber page will be opened instead.
 * @param latitude Latitude coordinate for the destination.
 * @param longitude Longitude coordinate for the destination.
 */
- (void)openUberAppWithLatiude:(double)latitude longitude:(double)longitude
{
    // Open the Uber application
    [self openAppWithURLScheme:@"uber://"
                    parameters:[NSString stringWithFormat:@"?client_id=7HsaMVLKTRSChl3g7VUCoRUepAtPYccn&action=setPickup&pickup=my_location&dropoff[latitude]=%g&dropoff[longitude]=%g", latitude, longitude]
                   appStoreURL:@"https://itunes.apple.com/us/app/uber/id368677368?mt=8"];
}

/**
 * Opens the URL scheme application (if found) with the destination already set.
 * If the application is not found, the App Store page will be opened instead.
 * @param urlScheme URL scheme for the application to be opened.
 * @param parameters Paramters to use for the call.
 * @param storeURL App Store page URL of the application.
 */
- (void)openAppWithURLScheme:(NSString *)urlScheme parameters:(NSString *)parameters appStoreURL:(NSString *)storeURL
{
    // Check if the Google Maps application is available
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[urlScheme stringByAppendingString:urlScheme]]])
    {
        // Create the URL to open the Google Maps app with coordinates already set
        NSString *url = [urlScheme stringByAppendingString:parameters];
        
        // Open the Google Maps application
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:storeURL]]; // Open the Google Maps App Store page
}

@end
