//
//  loginViewController.h
//  Instagigs
//
//  Created by Jerry Phillips on 8/17/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface loginViewController : UIViewController < UITextFieldDelegate, CLLocationManagerDelegate, UIScrollViewDelegate>
- (IBAction)createAccount:(id)sender;
- (IBAction)forgotPassword:(id)sender;
// this is the tableview that is housing the login fields

- (IBAction)FBLogin:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *backGroundView;

@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;

@property (strong, nonatomic) IBOutlet UITextField *password;

@property (strong, nonatomic) IBOutlet UITextField *username;

@property (strong, nonatomic) IBOutlet UIButton *fbLoginButton;

@property (strong, nonatomic) IBOutlet UIImageView *orImage;

@property(strong, nonatomic)CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) IBOutlet UIButton *signInButton;
@end
