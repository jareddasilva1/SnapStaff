

//
//  eventViewTableViewController.h
//  Instagigs
//
//  Created by Jerry Phillips on 9/11/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProfile.h"

@interface eventViewTableViewController : UITableViewController<UIPopoverPresentationControllerDelegate>

//array of the passed events
@property(nonatomic, strong)NSArray * eventsArray;

//presentingController
@property(nonatomic, strong)MyProfile *sendingController;
@end
;