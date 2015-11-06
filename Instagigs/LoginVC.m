//
//  LoginVC.m
//  Instagigs
//
//  Created by Rahiem Klugh on 10/24/15.
//  Copyright © 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "LoginVC.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Constants.h"
#import "InstagigSingelton.h"
#import "UIImage+animatedGIF.h"

@interface LoginVC ()

@end

static InstagigSingelton *sharedSingleton;
@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _usernameField.delegate = self;
    _passwordField.delegate = self;
    
    _usernameField.layer.cornerRadius = 25;
    _usernameField.layer.masksToBounds = YES;
    
    _passwordField.layer.cornerRadius = 25;
    _passwordField.layer.masksToBounds = YES;
    
    _signInButton.layer.cornerRadius = 25;
    _signInButton.layer.masksToBounds = YES;
    
    _signInButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _signInButton.layer.borderWidth = 2;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    sharedSingleton = [InstagigSingelton instagGigObject];

    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"logo" withExtension:@"gif"];
    UIImage *testImage = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    self.imageView.image = testImage;
    [self.imageView startAnimating];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)connectWithFacebookPressed:(id)sender {
    [self loginFBUser];
    
}



-(void)loginFBUser
{
    NSArray *permissions = @[@"public_profile", @"email"];
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (error)
        {
            NSLog(error.description);
        }
        
        if (user.isNew) {
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"first_name, last_name, gender, email, id,picture.width(500).height(500)"}];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                    
                    
                    if (!error)
                    {
                        
                        
                        NSDictionary *userData = (NSDictionary *) result;
                        
                        
                        [PFUser currentUser][FIRSTNAME] = userData[@"first_name"];
                        [PFUser currentUser][LASTNAME] = userData[@"last_name"];
                        [PFUser currentUser][GENDER] =  userData[@"gender"];
                        [PFUser currentUser][EMAIL] = userData[@"email"];
                        [PFUser currentUser][USERNAME] = userData[@"email"];
                        [PFUser currentUser][FACEBOOKID] = userData[@"id"];
                        
                        
                        //Get FB profile pic
                        NSString *imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
                        NSData *image = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStringOfLoginUser]];
                        NSString *fileName = @"profilePic";
                        PFFile *userImage = [PFFile fileWithName:fileName data:image];
                        [PFUser currentUser][PROFILE1] =userImage;
                        
                        
                        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                         {
                             
                             if (succeeded)
                             {
                                 sharedSingleton = [InstagigSingelton instagGigObject];
                                 [self performSegueWithIdentifier:@"createProfile" sender:nil];
                                 // [self loginSnapStaffUser];
                                 
                                 
                             }}];
                        
                        
                    }
                    
                }];
                
                
            });
        }
        
        if (! user.isNew)
        {
            if ([PFUser currentUser][ADDRESSLINE1] == nil || [PFUser currentUser][CITY] == nil || [PFUser currentUser][SHIRTSIZE ] == nil)
            {
                [self performSegueWithIdentifier:@"createProfile" sender:self];
                // [self loginSnapStaffUser];
            }
            else
            {
                sharedSingleton = [InstagigSingelton instagGigObject];
                // [self loginSnapStaffUser];
            }
            
        }
    }];
    

}

-(void) loginSnapStaffUser
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"@TabBarController"];
    [self presentViewController:viewController animated:YES completion:nil];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isUserLoggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
