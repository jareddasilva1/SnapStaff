//
//  InstagigSingelton.m
//  Instagigs
//
//  Created by Jerry Phillips on 8/18/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "InstagigSingelton.h"
#import "Constants.h"
#import "SVProgressHUD.h"



UIViewController *currentView;
@implementation InstagigSingelton
{
    NSInteger syncStep;
}

+(InstagigSingelton *) instagGigObject
{
    static InstagigSingelton * sInstaGigObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstaGigObject = [[InstagigSingelton alloc ]init];
    });
    
    return sInstaGigObject;
}

-(id)init
{
    if (self = [super init])
    {
        
        _currentEvent = [[eventObject alloc]init];
        _scheduledEvents = [[NSMutableDictionary alloc] init];
        _staffedEvents = [[NSMutableDictionary alloc] init];
        _completedEvents = [[NSMutableDictionary alloc] init];
        _allEvents = [[NSMutableDictionary alloc] init];
        _availableEvents = [[NSMutableDictionary alloc] init];
        
        if ([PFUser currentUser] != nil)
        {
            _theUser = [[InstagigUser alloc] initWithParseUser:[PFUser currentUser]];
            
        }
        
        [self beginSync];
    }
    
    return self;
}

-(void) beginSync
{
    syncStep = 1;
    [self syncWithStep:syncStep];
}

-(void)syncWithStep:(NSInteger)step
{
    syncStep = step;
    
    switch (step) {
        case 1:
            [self queryBrands];
            break;
        case 2:
            [self queryJobtitles];
            break;
        case 3:
          [self queryEvents];
            break;
        default:
            break;
    }
}



-(void)queryBrands
{
    PFQuery *query = [PFQuery queryWithClassName:BRANDS];
    
    [query orderByAscending:BRANDNAME];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             _brandNames = [NSMutableArray arrayWithArray:objects];
         }
     }];
     [self syncWithStep:syncStep+1];
}

-(void)queryJobtitles
{
    PFQuery *query = [PFQuery queryWithClassName:JOBTITLES];
    
    [query orderByAscending:JOBTITLE];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             _jobTitles = [NSMutableArray arrayWithArray:objects];
         }
     }];
}

-(void)queryEvents
{
    //Show the hud
    [SVProgressHUD showWithStatus:@"Loading Events..."];
    
    //whenever this query is ran we need an empty dictionary to start with or else we may see duplicate items
    if (_scheduledEvents.count > 0)
    {
        [_scheduledEvents removeAllObjects];
    }
    PFQuery *query = [PFQuery queryWithClassName:EVENTMANAGER];
    NSDate *date = [NSDate date];
    
    
    [query whereKey:USERNAME equalTo: [PFUser currentUser][USERNAME]];
    [query whereKey:EVENTDATE greaterThan:date];
    [query orderByAscending:EVENTDATE];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
        if(!error)
        {
            for (PFObject * object in objects) {
                if ([object[SPOTSREMAINING] isEqualToNumber:@0])
                {
                    if ([_staffedEvents objectForKey:[self dateFormatter:object[EVENTDATE] justTime:NO numberic:NO]] != nil)
                    {
                        NSMutableArray *array = [_staffedEvents objectForKey:[self dateFormatter:object[EVENTDATE] justTime:NO numberic:NO]];
                        
                        [array addObject:object];
                    }
                    else
                    {
                        NSMutableArray *array = [[ NSMutableArray alloc] initWithObjects:object, nil];
                        
                        [_staffedEvents setObject:array forKey:[self dateFormatter:object[EVENTDATE] justTime:NO numberic:NO]];
                    }

                }
        
            if ([_scheduledEvents objectForKey:[self dateFormatter:object[EVENTDATE] justTime:NO numberic:NO]] != nil)
            {
                NSMutableArray *array = [_scheduledEvents objectForKey:[self dateFormatter:object[EVENTDATE] justTime:NO numberic:NO]];
                
                [array addObject:object];
            }
            else
            {
                NSMutableArray *array = [[ NSMutableArray alloc] initWithObjects:object, nil];
                
                [_scheduledEvents setObject:array forKey:[self dateFormatter:object[EVENTDATE] justTime:NO numberic:NO]];
            }
            }

            [[NSNotificationCenter defaultCenter]postNotificationName:EVENTSUPDATED object:nil];
            [SVProgressHUD dismiss];
        }
     }];
    
}

-(void)queryCompletedEvents
{
    PFQuery *query = [PFQuery queryWithClassName:EVENTMANAGER];
    NSDate *date = [NSDate date];
    
    [query orderByAscending:EVENTDATE];
    [query whereKey:EVENTDATE lessThan:date];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if(!error)
         {
             for (PFObject * object in objects) {
                 
                 
                 if ([_completedEvents objectForKey:[self dateFormatter:object[EVENTDATE] justTime:NO numberic:NO]] != nil)
                 {
                     NSMutableArray *array = [_scheduledEvents objectForKey:[self dateFormatter:object[EVENTDATE] justTime:NO numberic:NO]];
                     
                     [array addObject:object];
                 }
                 else
                 {
                     NSMutableArray *array = [[ NSMutableArray alloc] initWithObjects:object, nil];
                     
                     [_completedEvents setObject:array forKey:[self dateFormatter:object[EVENTDATE] justTime:NO numberic:NO]];
                 }
             }
             
             [[NSNotificationCenter defaultCenter]postNotificationName:COMPLETED object:nil];
         }
     }];
    

}



-(void)queryAvailableEvents
{
    //Show the hud
    [SVProgressHUD showWithStatus:@"Loading Events..."];
    
    //whenever this query is ran we need an empty dictionary to start with or else we may see duplicate items
    if (_availableEvents.count > 0)
    {
        [_availableEvents removeAllObjects];
    }
    PFQuery *query = [PFQuery queryWithClassName:EVENTMANAGER];
    NSDate *date = [NSDate date];

    [query whereKey:EVENTDATE greaterThan:date];
    [query orderByAscending:EVENTDATE];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if(!error)
         {
             for (PFObject * object in objects) {

                 
                 if ([_availableEvents objectForKey:[self dateFormatter:object[EVENTDATE] justTime:NO numberic:NO]] != nil)
                 {
                     NSMutableArray *array = [_availableEvents objectForKey:[self dateFormatter:object[EVENTDATE] justTime:NO numberic:NO]];
                     
                     [array addObject:object];
                 }
                 else
                 {
                     NSMutableArray *array = [[ NSMutableArray alloc] initWithObjects:object, nil];
                     
                     [_availableEvents setObject:array forKey:[self dateFormatter:object[EVENTDATE] justTime:NO numberic:NO]];
                 }
             }
             
             [[NSNotificationCenter defaultCenter]postNotificationName:EVENTSUPDATED object:nil];
             [SVProgressHUD dismiss];
         }
     }];
    
}



-(void) saveBrandImagesToDevice
{
    NSError * error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *folderPath = [documentsPath stringByAppendingPathComponent:BRANDS];
    __block NSString *filePath;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
    {
         //Create the brands folder path
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
    }
 
    if (!error) {
        PFQuery *query = [PFQuery queryWithClassName:BRANDS];
        [query orderByDescending:UPDATEDAT];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if(!error)
             {
                 for (PFObject * object in objects) {
                     NSString *brandName = [NSString stringWithFormat:@"%@.png",object[BRANDNAME]];
                     NSString *removeSpacesName = [brandName stringByReplacingOccurrencesOfString:@" " withString:@""]; //Remove Spaces from name
                     PFFile *file = object[BRANDIMAGE];
                     [file getDataInBackgroundWithBlock:^(NSData *brandImageData, NSError *error) {
                         if (!error) {
                             filePath = [folderPath stringByAppendingPathComponent:removeSpacesName];   //Add the file name
                             [brandImageData writeToFile:filePath atomically:YES];   //Write the file
                             
                         }
                         //                     dispatch_async(dispatch_get_main_queue(), ^{
                         //                         [_activityIndicator stopAnimating];
                         //                         [_tableView reloadData];
                         //                     });
                     }];
                 }
                 
                 //Query completed
                 // [[NSNotificationCenter defaultCenter]postNotificationName:COMPLETED object:nil];
             }
             else
             {
                 //Error
             }
         }];
    }
}

-(UIImage*) fetchBrandImage: (NSString*) brandName
{
    UIImage *brandImage;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *name = [brandName stringByReplacingOccurrencesOfString:@" " withString:@""]; //
    NSString *folderPath = [NSString stringWithFormat:@"%@/%@.png", BRANDS,name];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:folderPath];
    
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];
    brandImage = [UIImage imageWithData:pngData];
    
    return brandImage;
}

-(void)buttonState:(UIButton *)sender :(BOOL)selected
{
    if (selected)
    {
        sender.backgroundColor = [UIColor whiteColor];
        sender.layer.borderColor =[UIColor blueColor].CGColor;
        sender.layer.borderWidth = 2;
        
        [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    }
    if (! selected)
    {
        sender.backgroundColor = [UIColor blueColor];
        //sender.layer.borderColor =[UIColor blueColor].CGColor;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    
    
}




-(UIToolbar *)doneToolBar:(UIView *)view
{
    UIToolbar * bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 44)];
    
    bar.translucent = YES;
    
    UIBarButtonItem * done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [bar setItems:[NSArray arrayWithObjects:flexibleSpace, flexibleSpace, done, nil]];
    

    return bar;
}

-(void)done
{
    [[NSNotificationCenter defaultCenter]postNotificationName:DISMISSKEYBOARD object:nil];
}

-(NSString *)dateFormatter:(NSDate*)passedDate justTime:(BOOL)justTheTime numberic:(BOOL)numeric
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    if (numeric == NO && justTheTime == NO)
    {
        [formater setDateStyle:NSDateFormatterMediumStyle];
        [formater setTimeStyle:NSDateFormatterNoStyle];
    }
    if (justTheTime == YES)
    {
        [formater setDateStyle:NSDateFormatterNoStyle];
        [formater setTimeStyle:NSDateFormatterShortStyle];
    }
    if (numeric == YES)
    {
        [formater setDateStyle:NSDateFormatterShortStyle];
        [formater setTimeStyle:NSDateFormatterNoStyle];
    }
    
    NSString *dateForDisplay = [formater stringFromDate:passedDate];
    
    return dateForDisplay;
    
    
    
}

-(void)saveScheduledObject
{
    [_currentEvent.parseEventObject saveInBackground];
    if ([_scheduledEvents objectForKey:[self dateFormatter:_currentEvent.parseEventObject[EVENTDATE] justTime:NO numberic:NO]] != nil)
    {
        NSMutableArray  *theArray = [_scheduledEvents objectForKey:[self dateFormatter:_currentEvent.parseEventObject[EVENTDATE] justTime:NO numberic:NO]];
        
        
        [theArray addObject:_currentEvent.parseEventObject];
    }
    else
    {
        NSMutableArray *theArray = [[NSMutableArray alloc] initWithObjects:_currentEvent.parseEventObject, nil];
        [_scheduledEvents setObject:theArray forKey:[self dateFormatter:_currentEvent.parseEventObject[EVENTDATE] justTime:NO numberic:NO]];
    }


    _currentEvent = nil;
    _currentEvent = [[eventObject alloc]init];
     [[NSNotificationCenter defaultCenter]postNotificationName:EVENTSUPDATED object:nil];
}


//reorder the titles
-(NSString *)orderTheDates: (NSArray *)titles :(NSInteger)index
{
    
    NSArray *sortedArray = [titles sortedArrayUsingSelector:@selector(compare:)];
    
//    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
//    
//    [dateformat setDateFormat:@"MMM dd, YYYY"];
//    NSArray *arrKeys = [titles sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
//        
//        NSDate *d1 = [dateformat dateFromString: obj1];
//        NSDate *d2 = [dateformat dateFromString: obj2];
//
//        return [d1 compare: d2];
//    }];
    
    return [sortedArray objectAtIndex:index];
    
}
// log user out
-(void)logUserOut: (UIViewController *)presentTheAlertView
{
    
    UIAlertController *logOutAlert = [UIAlertController alertControllerWithTitle:@"Log Out?" message:@"Are you sure you would like to log out?" preferredStyle:UIAlertControllerStyleAlert];
    
    [logOutAlert addAction:[UIAlertAction actionWithTitle:@"LOG OUT" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [PFUser logOut];
        
        if (_theUser != nil)
        {
            _theUser = nil;
        }
        
        // need to figure out which view will hold the logout
        [presentTheAlertView performSegueWithIdentifier:@"" sender:presentTheAlertView];

    }]];
    
    [logOutAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [presentTheAlertView presentViewController:logOutAlert animated:YES completion:nil];
     
  }


-(void) createEventInParse
{
    PFObject *event = [PFObject objectWithClassName:@"EventManager"];
    event[GEOPOINT] = _currentEvent.parseEventObject[GEOPOINT];
    event[BRANDNAME] = _currentEvent.parseEventObject[BRANDNAME];
    event[CONTACTPERSON] = _currentEvent.parseEventObject[CONTACTPERSON];
    event[CONTACTPHONE] = _currentEvent.parseEventObject[CONTACTPHONE];
    event[ENDTIME] = _currentEvent.parseEventObject[ENDTIME];
    event[EVENTADDRESS] = _currentEvent.parseEventObject[EVENTADDRESS];
    event[STARTTIME] = _currentEvent.parseEventObject[STARTTIME];
    event[EVENTDATE] = _currentEvent.parseEventObject[EVENTDATE];
    event[CITY] = _currentEvent.parseEventObject[CITY];
    event[STATE] = _currentEvent.parseEventObject[STATE];
    event[ZIPCODE] = _currentEvent.parseEventObject[ZIPCODE];
    event[EVENTTYPE] = _currentEvent.parseEventObject[EVENTTYPE];
    event[NUMBEROFTALENT] = _currentEvent.parseEventObject[NUMBEROFTALENT];
    event[SPOTSREMAINING] = _currentEvent.parseEventObject[SPOTSREMAINING];
    event[VENUENAME] = _currentEvent.parseEventObject[VENUENAME];
    event[PAYRATE] = _currentEvent.parseEventObject[PAYRATE];
    event[JOBTITLE] = _currentEvent.parseEventObject[JOBTITLE];
    event[USERNAME] = [PFUser currentUser].username;

    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            [[NSNotificationCenter defaultCenter]postNotificationName:NEWEVENTCREATED object:nil];
        } else {
            // There was a problem, check error.description
        }
    }];
}

-(void)deleteEventInParse
{
    PFQuery *query = [PFQuery queryWithClassName:EVENTMANAGER];
    [query findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error) {
        if (!error)
        {
            for (PFObject *event in events)
            {
                if ([event.objectId isEqualToString:_currentEvent.parseEventObject.objectId])
                {
                    [event deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded){
                            NSLog(@"BOOOOOM"); // this is my function to refresh the data
                             [[NSNotificationCenter defaultCenter]postNotificationName:EVENTDELETED object:nil];
                        } else {
                            NSLog(@"DELETE ERRIR");
                        }
                    }];
                }
            }
        }
        else
        {
            NSLog(@"%@",error);
        }
        
    }];
    
     PFObject *event = [PFObject objectWithClassName:@"EventManager"];
}


-(void)editEventInParse
{
      PFQuery *query = [PFQuery queryWithClassName:EVENTMANAGER];
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:_currentEvent.parseEventObject.objectId
                                 block:^(PFObject *event, NSError *error) {
                                     // Now let's update it with some new data. In this case, only cheatMode and score
                                     // will get sent to the cloud. playerName hasn't changed.
                                     event[GEOPOINT] = _currentEvent.parseEventObject[GEOPOINT];
                                     event[BRANDNAME] = _currentEvent.parseEventObject[BRANDNAME];
                                     event[CONTACTPERSON] = _currentEvent.parseEventObject[CONTACTPERSON];
                                     event[CONTACTPHONE] = _currentEvent.parseEventObject[CONTACTPHONE];
                                     event[ENDTIME] = _currentEvent.parseEventObject[ENDTIME];
                                     event[EVENTADDRESS] = _currentEvent.parseEventObject[EVENTADDRESS];
                                     event[STARTTIME] = _currentEvent.parseEventObject[STARTTIME];
                                     event[EVENTDATE] = _currentEvent.parseEventObject[EVENTDATE];
                                     event[CITY] = _currentEvent.parseEventObject[CITY];
                                     event[STATE] = _currentEvent.parseEventObject[STATE];
                                     event[ZIPCODE] = _currentEvent.parseEventObject[ZIPCODE];
                                     event[EVENTTYPE] = _currentEvent.parseEventObject[EVENTTYPE];
                                     event[NUMBEROFTALENT] = _currentEvent.parseEventObject[NUMBEROFTALENT];
                                     event[SPOTSREMAINING] = _currentEvent.parseEventObject[SPOTSREMAINING];
                                     event[VENUENAME] = _currentEvent.parseEventObject[VENUENAME];
                                     event[PAYRATE] = _currentEvent.parseEventObject[PAYRATE];
                                     event[JOBTITLE] = _currentEvent.parseEventObject[JOBTITLE];
                                     event[USERNAME] = [PFUser currentUser].username;
                                    // [event saveInBackground];
                                     
                                     [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         if (succeeded) {
                                             // The object has been saved.
                                             [[NSNotificationCenter defaultCenter]postNotificationName:EVENTEDITED object:nil];
                                         } else {
                                             // There was a problem, check error.description
                                         }
                                     }];

                                     
                                 }];
}



-(void) queryUserPhotos
{
    
}



@end
