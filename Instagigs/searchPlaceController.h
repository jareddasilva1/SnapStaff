//
//  searchPlaceController.h
//  Instagigs
//
//  Created by Jerry Phillips on 8/25/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchPlaceController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *gTableView;

- (IBAction)close:(id)sender;


@property (strong, nonatomic) NSMutableArray * placeResults;

@end
