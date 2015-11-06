//
//  confirmEventTableViewController.m
//  Instagigs
//
//  Created by Jerry Phillips on 8/27/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "confirmEventTableViewController.h"

#import "Constants.h"
#import "InstagigSingelton.h"
#import <Parse/Parse.h>
#import "createReportTableViewController.h"
#import "mapCellTableViewCell.h"
#import "signInButtonCell.h"
#import "eventInfoTableViewCell.h"
#import "notesLabelTableViewCell.h"
#import "MGSwipeTableCell.h"
#import "eventDetailsControllerBNTableViewController.h"


@interface confirmEventTableViewController ()

@end

InstagigSingelton *theDataShare;
PFGeoPoint * point;

// staffed people array
NSMutableArray *staffedPeople;
NSMutableDictionary * staffImages;

@implementation confirmEventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 250;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
  // self.navigationController.navigationBar.barTintColor = INSTABLUE;
    self.navigationController.navigationBar.tintColor = INSTABLUE;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName :INSTABLUE};

    
    theDataShare = [InstagigSingelton instagGigObject];
    
    _theEvent = theDataShare.currentEvent;
    
    
    //initialize event object
    if (theDataShare.createEvent == YES || theDataShare.scheduled == YES)
    {
                _theEvent = theDataShare.currentEvent;
        
      }
    
    if (theDataShare.scheduled == YES)
    {
        
        PFQuery * query = [PFQuery queryWithClassName:STAFFMANAGER];
        
        PFQuery *profiles = [PFUser query];
        staffImages = [[NSMutableDictionary alloc] init];
        
        [query whereKey:EVENTOBJECT equalTo:_theEvent.parseEventObject.objectId];
        [query whereKey:APPROVED notEqualTo:@YES];
        [query whereKey:DECLINED notEqualTo:@YES];
        
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error)
         {
             if (!error)
             {
                 NSMutableArray *localArray = [[NSMutableArray alloc] init];
                 
                 for (PFObject * object in array)
                 {
                     [localArray addObject:object[STAFFEDPERSEON]];
                 }
                 [profiles whereKey:@"objectId" containedIn:localArray];
                 [profiles findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError * error)
                  {
                      staffedPeople = [[NSMutableArray alloc]init];
                      
                      for (PFObject *object in objects)
                      {
                          InstagigUser *user = [[InstagigUser alloc] initWithParseUser:object];
                          [staffedPeople addObject:user];
                      }
                      [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                      
                      
                  }];
             }
             
         }];

    }

   

    
 
    self.navigationItem.title = _theEvent.parseEventObject[BRANDNAME];
    
  
    PFGeoPoint * mapPoint = _theEvent.parseEventObject[GEOPOINT];

      
 }

-(void)viewDidAppear:(BOOL)animated
{
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor lightGrayColor];
    header.textLabel.font = [UIFont fontWithName:@"OpenSansRegular" size:12.0];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    
}

//only set height if staffedpeople has objects
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 && staffedPeople.count >0)
    {
        
        return 35.0;
    }

    return 0;
}

// only display text if there are objects to display
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1 && staffedPeople.count >0)
    {
        
        return  @"STAFF";
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  // all of the cells except for the last in this view should have user interaction diasabled
    if (theDataShare.createEvent == YES)
    {
        [theDataShare saveScheduledObject];
        
        //update the data
        [theDataShare  queryEvents];
        [self fireNotificationToTalent];
        
        // these are navigation views but they are behaing like modal's? iOS 9 issue? had to call presentingView 3 times to kill the view on creation
        [[[[self presentingViewController]presentingViewController]presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        
    }
    if (theDataShare.scheduled == YES)
    {
        //push the edit details profile
        if (indexPath.row == staffedPeople.count )
        {
            theDataShare.createEvent = YES;
            theDataShare.scheduled = NO;
            [self performSegueWithIdentifier:@"editEvent" sender:self];
           
        }
        else
        {
            
            [self performSegueWithIdentifier:@"talentProfile" sender:self];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (theDataShare.scheduled == YES)
    {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //number of rows for the confirm an event
    if (theDataShare.createEvent == YES)
    {
        return 5;
    }
    
    //number of rows for editing a event (scheduled on the admin side)
    if (theDataShare.scheduled == YES)
    {
        if (section == 0)
        {
            return  4;
            
        }
        if (section == 1)
        {
            // we need to populate for staffed people for the event and add one for the edit field
            return staffedPeople.count+1;
        }
        
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //eventDetails cell
    eventInfoTableViewCell *eventDetailsCell = [tableView dequeueReusableCellWithIdentifier:@"eventInfoTableViewCell"];
    //Notes Label text
    notesLabelTableViewCell *notesLabelCell = [tableView dequeueReusableCellWithIdentifier:@"notesLabelTableViewCell"];
    
    // to display the map
    mapCellTableViewCell *mapCell = [tableView dequeueReusableCellWithIdentifier:@"mapCellTableViewCell"];
    
    //confirm Button
    signInButtonCell *signInCell = [tableView dequeueReusableCellWithIdentifier:@"signInButtonCell"];
    MGSwipeTableCell * staffCell = [tableView dequeueReusableCellWithIdentifier:@"MGSwipeTableCell"];
    
    if (eventDetailsCell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"eventInfoTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                eventDetailsCell =  (eventInfoTableViewCell *) currentObject;
                break;
            }
        }
    }
    
    if (notesLabelCell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"notesLabelTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                notesLabelCell =  (notesLabelTableViewCell *) currentObject;
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
    
    if ( signInCell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"signInButtonCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                signInCell =  (signInButtonCell *) currentObject;
                break;
            }
        }
    }
    
    if (staffCell == nil)
    {
        
        //pay attetion here the staffcell is cast from a mgswipetableviewcell the nib is named differently than from the class, It was decided after the fact that this cell would be used elsewhere
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"notificationsTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                staffCell =  (MGSwipeTableCell *) currentObject;
                break;
            }
        }
    }
    
     MKCoordinateRegion region;
    
    if (indexPath.section == 0)
    {
        
    switch (indexPath.row)
    {
        case 0:
            eventDetailsCell.dateLabel.text = [theDataShare dateFormatter:_theEvent.parseEventObject[EVENTDATE] justTime:NO numberic:YES];
            
            eventDetailsCell.eventTypeLabel.text = _theEvent.parseEventObject[EVENTTYPE];
            
            eventDetailsCell.startLabel.text = [theDataShare dateFormatter:_theEvent.parseEventObject[STARTTIME] justTime:YES numberic:NO];
            
            eventDetailsCell.endLabel.text = [theDataShare dateFormatter:_theEvent.parseEventObject[STARTTIME] justTime:YES numberic:NO];
            
            eventDetailsCell.numberLabel.text = [_theEvent.parseEventObject[NUMBEROFTALENT] stringValue];
            
            return eventDetailsCell;
            break;
            
        case 1:
            //reusing the notes cell to show contact person details
            notesLabelCell.notesLabelText.text = [NSString stringWithFormat:@"Contact Person: %@ \n\nContact Phone: %@\n", _theEvent.parseEventObject[CONTACTPERSON], _theEvent.parseEventObject[CONTACTPHONE]];
            notesLabelCell.userInteractionEnabled = NO;
            return notesLabelCell;
            
        case 2:
            
            notesLabelCell.notesLabelText.text = [NSString stringWithFormat: @"Notes: %@",_theEvent.parseEventObject[NOTES]];
            notesLabelCell.userInteractionEnabled = NO;
            return notesLabelCell;
            break;
            
        case 3:
        {
            mapCell.venueName.text = _theEvent.parseEventObject[VENUENAME];
            mapCell.venueAddress.text =_theEvent.parseEventObject[EVENTADDRESS];
            
            mapCell.phoneNumberOfVenue.text = _theEvent.parseEventObject[CONTACTPHONE];
            PFGeoPoint * mapPoint = _theEvent.parseEventObject[GEOPOINT];
            
            
            region.center.longitude = mapPoint.longitude;
            region.center.latitude = mapPoint.latitude;
            region.span.latitudeDelta = 0.00725;
            region.span.longitudeDelta = 0.00725;
            
            
            // Set pin for the location
            mapCell.pin = [[MKPointAnnotation alloc] init];
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(mapPoint.latitude, mapPoint.longitude);
            [mapCell.pin setCoordinate:coord];
            
            
            
            [mapCell.mapOfVenue setRegion:region animated:YES];
            [mapCell.mapOfVenue addAnnotation:mapCell.pin];
            mapCell.mapOfVenue.userInteractionEnabled = NO;
            mapCell.userInteractionEnabled = NO;
            return mapCell;
        }
            break;
            
        case 4:
            
            signInCell.backgroundColor = INSTABLUE;
            signInCell.label.text = @"Confirm";
            return signInCell;
            break;
            
        default:
            return nil;
            break;
    }
        
    }
    else
    {
        //last object is the confirm/or edit event button
        if (indexPath.row == staffedPeople.count)
        {
            signInCell.backgroundColor = GREEN;
            signInCell.label.text = @"Edit";
            return  signInCell;
        }
        InstagigUser *object = [staffedPeople objectAtIndex:indexPath.row];
        staffCell.nameOfTalent.text = [NSString stringWithFormat:@"%@, %@", object.userInfo[FIRSTNAME], [object.userInfo[LASTNAME] substringToIndex:1]];
        
        staffCell.profileImage_View.layer.cornerRadius = staffCell.profileImage_View.frame.size.width/2;
        staffCell.profileImage_View.layer.masksToBounds = YES;
        staffCell.profileImage_View.layer.borderColor = INSTABLUE.CGColor;
        staffCell.profileImage_View.layer.borderWidth = 1;
        
        if ([staffImages objectForKey: object.userInfo.objectId] != nil)
        {
            staffCell.profileImage_View.image = [staffImages objectForKey: object.userInfo.objectId];
        }
        else
        {
            PFFile *imageFile = object.userInfo[PROFILE1];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
             {
                 if (!error)
                 {
                     UIImage *image = [UIImage imageWithData:data];
                     [staffImages setObject:image forKey:object.userInfo.objectId];
                     NSArray *paths = [NSArray arrayWithObject:indexPath];
                     [self.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
                 }
                 
             }];
        }
        staffCell.ageLabel.text = [object calculateAge:object.userInfo[DATEOFBIRTH]];
        staffCell.locationLabel.text = object.userInfo[CITY];
        return staffCell;

        
    }
  
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"createReport"])
    {
        UINavigationController *nav = segue.destinationViewController;
        createReportTableViewController *report = (createReportTableViewController*)nav.topViewController;
        
        report.eventId = _theEvent.parseEventObject.objectId;
    }
    if ([segue.identifier isEqualToString:@"editEvent"])
    {
        UINavigationController *nav = segue.destinationViewController;
        eventDetailsControllerBNTableViewController *edit = (eventDetailsControllerBNTableViewController*)nav.topViewController;
        // I'm using the fact that if the staffedpeoplearray on th eventdetails is populated with something we are displaying the delete event button so I am adding a dummy item and will use that to determine wheter or not to send a push
        if (staffedPeople.count >0)
        {
            staffedPeople = [NSMutableArray arrayWithObject:@"noItems"];
        }
        
        edit.staffedPeopleToNotify = staffedPeople;
    }

}


//Fire push notification to talent side users
-(void)fireNotificationToTalent
{
    NSDictionary *data = @{ @"badge": @"Increment"};
    
    PFPush * push = [[PFPush alloc] init];
    
    [push setChannel: @"Talent"];
    
    [push setData:data];
    
    [push sendPushInBackground];
    
    
}
/**
 * Opens the Uber application (if found) with the destination already set. 
 * If the application is not found, the App Store Uber page will be opened instead.
 * @param latitude Latitude coordinate for the destination.
 * @param longitude Longitude coordinate for the destination.
 */
- (void)openUberAppWithLatiude
{
    // Open the Uber application
    [self openAppWithURLScheme:@"uber://"
                    parameters:[NSString stringWithFormat:@"?client_id=7HsaMVLKTRSChl3g7VUCoRUepAtPYccn&action=setPickup&pickup=my_location&dropoff[latitude]=%g&dropoff[longitude]=%g", point.latitude, point.longitude]
                   appStoreURL:@"https://itunes.apple.com/us/app/uber/id368677368?mt=8"];
}

/**
 * Opens the Google Maps application (if found) with the destination already set.
 * If the application is not found, the App Store Google Maps page will be opened instead.
 * @param latitude Latitude coordinate for the destination.
 * @param longitude Longitude coordinate for the destination.
 */
- (void)openGoogleMapsAppWithLatiude
{
    // Open the Uber application
    [self openAppWithURLScheme:@"comgooglemaps://"
                    parameters:[NSString stringWithFormat:@"?saddr=&daddr=%g,%g&directionsmode=driving", point.latitude, point.longitude]
                   appStoreURL:@"https://itunes.apple.com/us/app/google-maps/id585027354?mt=8"];
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

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
