//
//  Create New Event.h
//  Instagigs
//
//  Created by Jerry Phillips on 8/24/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"

@interface Create_New_Event : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *container;

@property (strong, nonatomic) IBOutlet UIButton *closeButton;

@property(nonatomic, strong) eventObject* eventObject;
@end
