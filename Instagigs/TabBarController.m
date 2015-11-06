//
//  TabBarController.m
//  Instagigs
//
//  Created by Rahiem Klugh on 9/28/15.
//  Copyright © 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "TabBarController.h"
#import "Constants.h"
#import "InstagigSingelton.h"

@interface TabBarController ()

@end

static InstagigSingelton *sharedSingleton;
@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Admin//
   /*1. Scheduled
     2. Events  (Staffed/Completed)
     3. Notifications
     */
    
    //Talent//
    /*1. My Gigs
      2. Events  (Avail/Completed)
      3. Profile
      4. Notifications
     */
    sharedSingleton = [InstagigSingelton instagGigObject];
    
    // Do any additional setup after loading the view.
    UIViewController *mygigs = [[UIStoryboard storyboardWithName:@"MyGigs" bundle:nil] instantiateInitialViewController];
    UIViewController *events = [[UIStoryboard storyboardWithName:@"Events" bundle:nil] instantiateInitialViewController];
    UIViewController *notifications, *profile;
    
    if ([_ENVIRONMENT isEqualToString:@"TALENT"] || [_ENVIRONMENT isEqualToString:@"ADMIN"])
    {
            notifications = [[UIStoryboard storyboardWithName:@"Notifications" bundle:nil] instantiateInitialViewController];
            profile = [[UIStoryboard storyboardWithName:@"Profile" bundle:nil] instantiateInitialViewController];
    }
    else
    {
            notifications = [[UIStoryboard storyboardWithName:@"NotificationsAdmin" bundle:nil] instantiateInitialViewController];
    }

    NSMutableArray *tabList = [[NSMutableArray alloc] init];
    [tabList addObject:mygigs];
    [tabList addObject:events];
    
    if ([_ENVIRONMENT isEqualToString:@"TALENT"] || [_ENVIRONMENT isEqualToString:@"ADMIN"])
    {
        [tabList addObject:profile];
    }
    [tabList addObject:notifications];
    [self setViewControllers:tabList animated:YES];
    
    
    if (sharedSingleton.userActionType == PROFILECREATED) {
           [self setSelectedViewController:events];
    }
    else
    {
           [self setSelectedViewController:mygigs];
    }
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)selectingViewController {
    if (![selectingViewController isViewLoaded]) {
        //this is the first time we meet
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
