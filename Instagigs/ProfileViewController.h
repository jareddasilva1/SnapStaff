//
//  ProfileViewController.h
//  Instagigs
//
//  Created by Rahiem Klugh on 9/30/15.
//  Copyright © 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "InstagigUser.h"

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property(nonatomic, strong)InstagigUser *the_CurrentUser;
@end
