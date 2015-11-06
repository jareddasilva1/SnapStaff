//
//  InstagigUser.h
//  Instagigs
//
//  Created by Jerry Phillips on 8/18/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface InstagigUser : NSObject
-(id)initWithParseUser: (PFObject *)user;
@property(nonatomic, strong)PFObject* userInfo;
@property(nonatomic, strong)NSMutableDictionary *myScheduledSnapGigs;
@property(nonatomic, strong)NSMutableDictionary *myCompletedSnapGigs;
@property(nonatomic, strong)NSMutableDictionary *mySnapGigImages;
-(NSString *)dateFormatter:(NSDate*)passedDate justTime:(BOOL)justTheTime numberic:(BOOL)numeric;
-(void)getAllGigs;
-(NSString *)returnEventDate: (NSString *)objectId;
@property(nonatomic, strong) NSString *refEventId;
-(NSString *)calculateAge: (NSDate *)date;
-(void)getImages;
@end
