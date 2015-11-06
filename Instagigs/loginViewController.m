           //

//
//  loginViewController.m
//  Instagigs
//
//  Created by Jerry Phillips on 8/17/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "loginViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Constants.h"
#import "signInButtonCell.h"
#import "signInCell.h"
#import "InstagigSingelton.h"
#import "CreateProfilePartOne.h"
#import "FBLoginTableViewCell.h"
#import "MyProfile.h"

@interface loginViewController ()

@end

CGSize keyboardSize;

UIToolbar* numberToolbar;
InstagigSingelton *sharedData_;
BOOL up;
BOOL down;
@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _username.delegate = self;
    _password.delegate = self;
    
    _username.layer.cornerRadius = 25;
    _username.layer.masksToBounds = YES;
    
    _password.layer.cornerRadius = 25;
    _password.layer.masksToBounds = YES;
    
    _signInButton.layer.cornerRadius = 25;
    _signInButton.layer.masksToBounds = YES;
    
    _signInButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _signInButton.layer.borderWidth = 2;
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(done) name:DISMISSKEYBOARD object:nil];
    
    [_signInButton addTarget:self action:@selector(signInUser) forControlEvents:UIControlEventTouchUpInside];
    
    
    _locationManager.delegate = self;
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    
    [_fbLoginButton addTarget:self action:@selector(FBLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    _logoImageView.backgroundColor = INSTABLUE;
    
    _scrollView.delegate = self;
   
    
    
    tap.numberOfTapsRequired = 1;
    
    [tap addTarget:self action:@selector(done)];
    
    [_scrollView addGestureRecognizer:tap];

}

-(void) viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

//kill horizontal scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView setContentOffset: CGPointMake(0, scrollView.contentOffset.y)];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView = [sharedData_ doneToolBar:self.view];
    
    return YES;
}
- (void)viewDidAppear:(BOOL)animated
{
    
    if ([PFUser currentUser])
    {
        if ([PFUser currentUser][DATEOFBIRTH] == nil || [PFUser currentUser][GENDER] == nil || [PFUser currentUser][ADDRESSLINE1]==nil || [PFUser currentUser][EMAIL] == nil || [PFUser currentUser][HEIGHT] == nil)
        {
            sharedData_ = [InstagigSingelton instagGigObject];

                        [self performSegueWithIdentifier:@"createProf1" sender:self];
        }
        else
        {
            sharedData_ = [InstagigSingelton instagGigObject];

            //[self performSegueWithIdentifier:@"createProf1" sender:self];
           // [self performSegueWithIdentifier:@"myProfile" sender:self];
            //[self loginSnapStaffUser];
        }
    }

}

#pragma mark Keyboard Methods

- (void)keyboardWillShow:(NSNotification *)notification
{
    keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if (up == NO)
    {
        
     
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
        _scrollView.contentInset = contentInsets;
        _scrollView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        CGRect aRect = self.view.frame;
        aRect.size.height -= keyboardSize.height;
        if (!CGRectContainsPoint(aRect, _password.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, _password.frame.origin.y-keyboardSize.height);
            [_scrollView setContentOffset:scrollPoint animated:YES];
        }
        if (!CGRectContainsPoint(aRect, _username.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, _username.frame.origin.y-keyboardSize.height);
            [_scrollView setContentOffset:scrollPoint animated:YES];
        }
    
    
            
        up = YES;
    }
    
    

}

-(void)done
{
     [self.view endEditing:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    up = NO;
    
   
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
    {
        _scrollView.contentInset = contentInsets;
        _scrollView.scrollIndicatorInsets = contentInsets;
    } completion:nil];

    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 3;
//    
//}

//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    switch (textField.tag)
//    {
//        case 0:
//            _usernameText = textField.text;
//            
//            break;
//            
//        case 1:
//            _passwordText  = textField.text;
//            
//            break;
//        default:
//            break;
//    }
//}

//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    signInButtonCell *signinButton = [tableView dequeueReusableCellWithIdentifier:@"signInButtonCell"];
//    
//    
//    signInCell *signinCell = [tableView dequeueReusableCellWithIdentifier:@"signInCell"];
//    
//
//    
//    if (signinButton == nil)
//    {
//        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"signInButtonCell" owner:self options:nil];
//        for (id currentObject in topLevelObjects){
//            if ([currentObject isKindOfClass:[UITableViewCell class]]){
//                signinButton =  (signInButtonCell *) currentObject;
//                break;
//            }
//        }
//    }
//    
//    if (signinCell == nil)
//    {
//        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"signInCell" owner:self options:nil];
//        for (id currentObject in topLevelObjects){
//            if ([currentObject isKindOfClass:[UITableViewCell class]]){
//                signinCell =  (signInCell *) currentObject;
//                break;
//            }
//        }
//    }
//
// 
//    
//    
//    switch (indexPath.row)
//    {
//            
//        case 0:
//            
//            signinCell.signInText.delegate = self;
//            signinCell.signInText.tag = 0;
//            
//            return signinCell;
//            break;
//            
//            case 1:
//            
//            signinCell.signInText.delegate = self;
//            signinCell.signInText.secureTextEntry = YES;
//            signinCell.signInText.tag = 1;
//                        signinCell.signInText.placeholder = @"PASSWORD";
//            
//            return signinCell;
//            break;
//            
//        case 2:
//            return signinButton;
//            break;
//            
//          
//            
//        default:
//            return nil;
//            break;
//    }
//
//}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Remove seperator inset
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    // Prevent the cell from inheriting the Table View's margin settings
//    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
//    
//    // Explictly set your cell's layout margins
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == 2)
//    {
//        [self.view endEditing:YES];
//        [self signInUser];
//    }
//}


- (IBAction)createAccount:(id)sender
{
    [self performSegueWithIdentifier:@"createProf1" sender:self];
}


//fire email to user to reset their password
- (IBAction)forgotPassword:(id)sender
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Forgot Password?" message:@"Please enter your password below to reset." preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter your email address";
        [textField addTarget:self action:@selector(alertTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UITextField *textBox = alert.textFields.firstObject;
      
             [PFUser requestPasswordResetForEmailInBackground:textBox.text];
        
       
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    ok.enabled = NO;
    
    [self presentViewController:alert animated:YES completion:nil];

}

//enable the resetbutton
-(void)alertTextFieldDidChange:(UITextField *)sender
{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController)
    {
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = login.text.length > 2;
    }
}
- (void)FBLogin:(UIButton*)sender
{
    NSArray *permissions = @[@"public_profile", @"email"];
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (error)
        {
            NSLog(error.description);
        }
        
        if (user.isNew) {
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"first_name, last_name, gender, email, id"}];
            
            
            
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
                        
                                
                                [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                                 {
                                     
                                     if (succeeded)
                                     {
                                         sharedData_ = [InstagigSingelton instagGigObject];
                                         //[self performSegueWithIdentifier:@"createProf1" sender:nil];
                                           [self loginSnapStaffUser];
                                         
                                        
                                     }}];
                                
                                
                            }
                            
                        }];
                        
                        
            });
        }

        if (! user.isNew)
        {
             if ([PFUser currentUser][ADDRESSLINE1] == nil || [PFUser currentUser][CITY] == nil || [PFUser currentUser][SHIRTSIZE ] == nil)
             {
                 // [self performSegueWithIdentifier:@"createProf1" sender:self];
                   [self loginSnapStaffUser];
             }
             else
             {
                 sharedData_ = [InstagigSingelton instagGigObject];
                 //[self performSegueWithIdentifier:@"createProf1" sender:self];
                   // [self performSegueWithIdentifier:@"myProfile" sender:self];
                   [self loginSnapStaffUser];
             }
        
        }
    }];
    
}
-(void)signInUser
{
    [self.view endEditing:YES];
[PFUser logInWithUsernameInBackground:_username.text  password:_password.text
                                block:^(PFUser *user, NSError *error) {
                                    if (user)
                                    {
                                        sharedData_ = [InstagigSingelton instagGigObject];
                                        [self loginSnapStaffUser];
                                    }
                                    
                                    else
                                    {
                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Bad Username or Password" message:@"Your username or password is not correct please try again." preferredStyle:UIAlertControllerStyleAlert];
                                        
                                        
                                        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                                        
                                        [alert addAction:ok];
                                        
                                        [self presentViewController:alert animated:YES completion:nil];
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
