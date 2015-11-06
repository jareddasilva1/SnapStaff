//
//  notificationsTableViewController.m
//  Instagigs
//
//  Created by Jerry Phillips on 9/2/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "notificationsTableViewController.h"
#import  <Parse/Parse.h>
#import "Constants.h"
#import "InstagigUser.h"
#import "MGSwipeButton.h"
#import "talentViewController.h"

@interface notificationsTableViewController ()

@end


NSMutableArray * event_Manager_Objects;
NSMutableDictionary *imagery_Dictionary;
//we are using this to seperate the events
NSMutableDictionary *event_Host;

//to view the individual profile of the user
InstagigUser *viewTheUser;


@implementation notificationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
       // self.navigationController.navigationBar.barTintColor = INSTABLUE;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadThisData) name:EVENTSUPDATED object:nil];
    
    event_Host = [[NSMutableDictionary alloc] init];
    
    //query staffManager
    PFQuery * query = [PFQuery queryWithClassName:STAFFMANAGER];
    //query eventManger
    PFQuery *eventManager = [PFQuery queryWithClassName:EVENTMANAGER];
    // query users
    PFQuery *profiles = [PFUser query];
    NSDate *today = [NSDate date];
    imagery_Dictionary = [[NSMutableDictionary alloc] init];
    
    
    [query whereKey:APPROVED notEqualTo:@YES];
    [query whereKey:DECLINED notEqualTo:@YES];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *staffManagerArray, NSError *error)
     {
         if (!error)
         {
             event_Manager_Objects = [[NSMutableArray alloc] initWithArray:staffManagerArray];
             NSMutableArray *localArray = [[NSMutableArray alloc] init];
            
             NSMutableArray *eventId = [[NSMutableArray alloc] init];
             
             for (PFObject * object in staffManagerArray)
             {
                 [localArray addObject:object[STAFFEDPERSEON]];
                 if ([eventId indexOfObject:object[EVENTOBJECT]] == NSNotFound)
                 {
                     [eventId addObject:object[EVENTOBJECT]];
                 }
             }
                      [eventManager whereKey:@"objectId" containedIn:eventId];
             [eventManager whereKey:EVENTDATE greaterThan:today];
                      [eventManager findObjectsInBackgroundWithBlock:^(NSArray *eventObjects, NSError * error)
                       {
                        if(!error)
                        {
                            [profiles whereKey:@"objectId" containedIn:localArray];
                            [profiles findObjectsInBackgroundWithBlock:^(NSArray *staffObjects, NSError * error)
                             {
                                 for(PFObject* objs in staffManagerArray)
                                 {
                                     for (PFObject *obj in staffObjects)
                                     {
                                         if([obj.objectId isEqualToString:objs[STAFFEDPERSEON]])
                                         {
                                             for (PFObject *eveObject in eventObjects)
                                             {
                                                 if ([eveObject.objectId isEqualToString:objs[EVENTOBJECT]])
                                                 {
                                                     if ([event_Host objectForKey:eveObject[BRANDNAME]] != nil)
                                                     {
                                                         NSMutableArray  *theArray = [event_Host objectForKey:eveObject[BRANDNAME]];
                                                         InstagigUser *user = [[InstagigUser alloc] initWithParseUser:obj];
                                                         
                                                         user.refEventId = eveObject.objectId;
                                                         [theArray addObject:user];
                                                     }
                                                     else
                                                     {
                                                         InstagigUser *user = [[InstagigUser alloc] initWithParseUser:obj];
                                                              user.refEventId = eveObject.objectId;
                                                         NSMutableArray *theArray = [[NSMutableArray alloc] initWithObjects:user, nil];
                                                         [event_Host setObject:theArray forKey:eveObject[BRANDNAME]];
                                                     }

                                                 }
                                             }
                                         }
                                     }

                                 }

                                 
                                 
                                 
                                 
                             }];
                                                   }
                       }];
                      
        
         }
         
     }];
    
    
   
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)reloadThisData
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return event_Host.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger rowcount;
    
    NSArray *allkeys  = [event_Host allKeys];
    
    NSString *key = [allkeys objectAtIndex: section];
    
    NSArray * array = [event_Host objectForKey:key];
    
    
    
    
    rowcount = array.count;
    
    
    
    return rowcount;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *Keys = [event_Host allKeys];
    
    NSString * brandString = [Keys objectAtIndex:section];
    
    NSArray *objectArray = event_Host[brandString];
    
    // grab any item out of the array to set the date from
    InstagigUser *user = [objectArray firstObject];
    NSString * dateForEvent = [user returnEventDate:user.refEventId];
    
    
    return [NSString stringWithFormat:@"%@ on %@", brandString, dateForEvent ];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGSwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MGSwipeTableCell" ];
    
    // Configure the cell...
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"notificationsTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (MGSwipeTableCell *) currentObject;
                break;
            }
        }
    }
    
    NSArray *allkeys  = [event_Host allKeys];
    
    NSString *key = [allkeys objectAtIndex: indexPath.section];
    
    NSArray * array = [event_Host objectForKey:key];

    InstagigUser *object = [array objectAtIndex:indexPath.row];
    PFObject *eventObject;
    for (PFObject *lObj in event_Manager_Objects)
    {
        if ([lObj[STAFFEDPERSEON] isEqualToString:object.userInfo.objectId])
        {
            eventObject = lObj;
        }
    }
    
    
    //cell.notesTextview.text = object[@"bio"];
    
    cell.nameOfTalent.text = [NSString stringWithFormat:@"%@ %@.", object.userInfo[FIRSTNAME], [object.userInfo[LASTNAME] substringToIndex:1]];
    cell.ageLabel.text = [object calculateAge:object.userInfo[DATEOFBIRTH]];
    cell.locationLabel.text = object.userInfo[CITY];
    cell.profileImage_View.layer.cornerRadius = cell.profileImage_View.frame.size.width/2;
    cell.profileImage_View.layer.masksToBounds = YES;
    cell.profileImage_View.layer.borderColor = INSTABLUE.CGColor;
    cell.profileImage_View.layer.borderWidth = 1;
    
    if ([imagery_Dictionary objectForKey: object.userInfo.objectId] != nil)
    {
        cell.profileImage_View.image = [imagery_Dictionary objectForKey: object.userInfo.objectId];
    }
    else
    {
        PFFile *imageFile = object.userInfo[PROFILE1];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
         {
             if (!error)
             {
                 UIImage *image = [UIImage imageWithData:data];
                 [imagery_Dictionary setObject:image forKey:object.userInfo.objectId];
                 NSArray *paths = [NSArray arrayWithObject:indexPath];
                 [self.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
             }
             
         }];
    }
    
    if ([eventObject[APPROVED] isEqual:@YES])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.leftExpansion.fillOnTrigger = YES;
    cell.leftExpansion.threshold =1.1;
    cell.leftExpansion.buttonIndex = 0;
    
    cell.rightExpansion.fillOnTrigger = YES;
    cell.rightExpansion.threshold = 2.0;
     cell.rightExpansion.buttonIndex = 0;
    
    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Accept" icon:[UIImage imageNamed:@"completed_normal-1"] backgroundColor:[UIColor greenColor] callback:^BOOL(MGSwipeTableCell *sender) {
        
        
                eventObject[APPROVED] = @YES;
        eventObject[DECLINED] = @NO;
                [eventObject  saveInBackground];
        
        
        
        NSArray *paths = @[indexPath];
        [self.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
        
        return YES;
    }]];
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Decline" backgroundColor:[UIColor redColor]callback:^BOOL(MGSwipeTableCell *sender) {
        eventObject[APPROVED] = @NO;
        eventObject[DECLINED] = @YES;
        [eventObject saveInBackground];
        NSArray *paths = @[indexPath];
        NSArray * keys = [event_Host allKeys];
        
        NSString * key = [keys objectAtIndex:indexPath.section];
        
        NSMutableArray *array = [event_Host objectForKey:key];
        
        
        
        
        [array removeObjectAtIndex:indexPath.row];
        if(array.count < 1)
        {
            [event_Host removeObjectForKey:key];
        }
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        return YES;
    }]];
  
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *allkeys  = [event_Host allKeys];
    
    NSString *key = [allkeys objectAtIndex: indexPath.section];
    
    NSArray * array = [event_Host objectForKey:key];
    
    InstagigUser *object = [array objectAtIndex:indexPath.row];
    
    
    viewTheUser = object;
    
    [self performSegueWithIdentifier:@"viewUser" sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"viewUser"])
    {
        //UINavigationController *nav = segue.destinationViewController;
        
        talentViewController * talent = segue.destinationViewController;
        
        talent.the_CurrentUser = viewTheUser;
        talent.editable = NO;
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}


- (IBAction)closeThisView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
