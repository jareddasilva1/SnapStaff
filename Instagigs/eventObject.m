//
//  eventObject.m
//  Instagigs
//
//  Created by Jerry Phillips on 8/25/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "eventObject.h"
#import "Constants.h"

@implementation eventObject

-(id)init
{
    if (self = [super init])
    {
         _parseEventObject = [PFObject objectWithClassName:EVENTMANAGER];
    }
   
    return self;
    
}



@end
