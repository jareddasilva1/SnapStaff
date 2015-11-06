//
//  LoginVC.h
//  Instagigs
//
//  Created by Rahiem Klugh on 10/24/15.
//  Copyright © 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *signInButton;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)connectWithFacebookPressed:(id)sender;

@end
