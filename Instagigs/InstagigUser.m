//
//  InstagigUser.m
//  Instagigs
//
//  Created by Jerry Phillips on 8/18/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "InstagigUser.h"
#import "Constants.h"


// temporary staffed Gigs array
NSMutableArray * tempEventIds;
@implementation InstagigUser


// init with a Parse user
-(id)initWithParseUser: (PFObject *)user
{
    if (self = [super init])
    {
        
    _userInfo = user;
    _myCompletedSnapGigs = [[NSMutableDictionary alloc] init];
    _myScheduledSnapGigs = [[NSMutableDictionary alloc] init];
        _mySnapGigImages = [[NSMutableDictionary alloc] init];
        [self getAllGigs];
        [self getImages];
        
        //Subscribe all users to the talent channel in parse
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        NSArray *subscribedChannels = currentInstallation.channels;
        
        for (NSString *  channel in subscribedChannels)
        {
            if ([channel isEqualToString:@"Talent"])
            {
                break;
            }
            else
            {
                [currentInstallation addUniqueObject:@"Talent" forKey:@"channels"];
                currentInstallation[@"snapStaffUser"] = user.objectId;
                [currentInstallation saveInBackground];
            }
        }
    }
    
    return self;
}

// get the images of the user
-(void)getImages
{
    
    for (int i = 1; i < 10; i++)
    {
        NSString *key = [NSString stringWithFormat:@"profile%@",[@(i) stringValue]];
        
        if (_userInfo[key] != nil)
        {
            PFFile *userImageFile = _userInfo[key];
            [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:imageData];
                    
                    [_mySnapGigImages setObject:image forKey:key];
                    [[NSNotificationCenter defaultCenter]postNotificationName:PROFILEPICUPDATED object:nil];
                    if (i == 9) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:PROFILEPICUPDATED object:nil];
                    }
                    
                }
            }];
            
        }
    }
}

// get the users past and future events
-(void)getAllGigs
{
    PFQuery * query = [PFQuery queryWithClassName:STAFFMANAGER];
    
    [query whereKey:STAFFEDPERSEON equalTo:_userInfo.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *arrayOfStaffObjects, NSError *error)
     {
         if (!error)
         {
             tempEventIds = [[NSMutableArray alloc] init];
             for (PFObject *object in arrayOfStaffObjects)
             {
                 [tempEventIds addObject:object[EVENTOBJECT]];
             }
             [self getAllEvents];
             
         }
         
     }];
    
}

//
-(NSString *)returnEventDate: (NSString *)objectId
{
    PFObject * dateObject;
    
    NSArray *array = [_myScheduledSnapGigs allKeys];
    for (NSString *key in array)
    {
        NSArray *objects = _myScheduledSnapGigs[key];
        for (PFObject * object in objects)
        {
            if ([object.objectId isEqualToString:objectId])
            {
                dateObject = object;
            }
        }
       
    }
    
    
    return [self dateFormatter:dateObject[EVENTDATE] justTime:NO numberic:NO];
}


// seperate the events into there appropriate array
-(void)getAllEvents
{
    PFQuery * query = [PFQuery queryWithClassName:EVENTMANAGER];
    
    [query whereKey:@"objectId" containedIn:tempEventIds];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * eventObjectsArray, NSError *error)
     {
         if (!error)
         {
             NSDate *date = [NSDate date];
             for (PFObject * object in eventObjectsArray)
             {
                 if ([object[EVENTDATE] compare:date] == NSOrderedAscending)
                 {
                     if ([_myCompletedSnapGigs objectForKey:[self dateFormatter:object[EVENTDATE] justTime:NO numberic:NO]] != nil)
                     {
                         NSMutableArray *array = [_myCompletedSnapGigs objectForKey:[self dateFormatter:object[EVENTDATE] justTime:NO numberic:NO]];
                         
                         [array addObject:object];
                     }
                     else
                     {
                         NSMutableArray *array = [[ NSMutableArray alloc] initWithObjects:object, nil];
                         
                         [_myCompletedSnapGigs setObject:array forKey:[self dateFormatter:object[EVENTDATE] justTime:NO numberic:NO]];
                         
                         
                     }
                 }
                 if ([object[EVENTDATE] compare:date] == NSOrderedDescending)
                 {
                     if ([_myScheduledSnapGigs objectForKey:[self dateFormatter:object[EVENTDATE] justTime:NO numberic:NO]] != nil)
                     {
                         NSMutableArray *array = [_myScheduledSnapGigs objectForKey:[self dateFormatter:object[EVENTDATE] justTime:NO numberic:NO]];
                         
                         [array addObject:object];
                     }
                     else
                     {
                         NSMutableArray *array = [[ NSMutableArray alloc] initWithObjects:object, nil];
                         
                         [_myScheduledSnapGigs setObject:array forKey:[self dateFormatter:object[EVENTDATE] justTime:NO numberic:NO]];
                     }
                 }
             }
             
             [[NSNotificationCenter defaultCenter]postNotificationName:EVENTSUPDATED object:nil];
         }
         
     }];
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

-(NSString *)calculateAge: (NSDate *)date
{
    NSDate * today = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:date
                                       toDate:today
                                       options:0];
    
    NSInteger age = [ageComponents year];
    
    return [NSString stringWithFormat:@" %@ yrs", [@(age) stringValue]];
    
}


@end
