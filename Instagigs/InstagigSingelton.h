//
//  InstagigSingelton.h
//  Instagigs
//
//  Created by Jerry Phillips on 8/18/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "InstagigUser.h"
#import "eventObject.h"

typedef enum
{
    CREATEEVENT = 1,
    EDITEVENT,
    VIEWREPORT,
    CREATEREPORT,
    VIEWSTAFF,
    VIEWSTAFF2,
    REQUESTBOOKING,
    REQUESTRECEIVED,
} EventDetailsType;

typedef enum
{
    PROFILECREATED = 1,
    PROFILEEDITED,
} UserActionType;


@interface InstagigSingelton : NSObject 
+(InstagigSingelton *) instagGigObject;

// if we are talent side we need a single instance of this user to refer back to the data
@property(nonatomic, strong) InstagigUser *theUser;
@property(nonatomic, readwrite) EventDetailsType detailsType;
@property(nonatomic, readwrite) UserActionType userActionType;

-(void)buttonState:(UIButton *)sender :(BOOL)selected;
@property(nonatomic, strong) eventObject * currentEvent;
-(UIToolbar *)doneToolBar:(UIView*)view;
-(NSString *)dateFormatter:(NSDate*)passedDate justTime:(BOOL)justTheTime numberic:(BOOL)numeric;
@property(strong, nonatomic)NSMutableArray *brandNames;
@property(strong, nonatomic)NSMutableArray *jobTitles;
//admin side only
@property(nonatomic) BOOL createEvent;
@property(nonatomic) BOOL scheduled;
@property(nonatomic) BOOL staffed;
@property(nonatomic) BOOL completed;
//talent side only
@property(nonatomic) BOOL myGigs;
@property(nonatomic) BOOL available;
@property(nonatomic) BOOL myProfile;
@property(nonatomic) BOOL talentCompleted;

@property(nonatomic, strong) NSMutableDictionary *scheduledEvents;
@property(nonatomic, strong) NSMutableDictionary *availableEvents;
@property (nonatomic, strong) NSMutableDictionary *staffedEvents;
@property (nonatomic, strong) NSMutableDictionary *completedEvents;
@property (nonatomic, strong) NSMutableDictionary *allEvents;

-(NSString *)orderTheDates: (NSArray *)titles :(NSInteger)index;



-(void)saveScheduledObject;

-(void)queryEvents;
-(void)queryCompletedEvents;
-(void)queryAvailableEvents;
-(void)saveBrandImagesToDevice;
-(void)createEventInParse;
-(void)deleteEventInParse;
-(void)editEventInParse;
-(UIImage*) fetchBrandImage: (NSString*) brandName;

@end
