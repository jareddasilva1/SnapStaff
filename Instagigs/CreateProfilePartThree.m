//
//  CreateProfilePartThree.m
//  Instagigs
//
//  Created by Jerry Phillips on 8/20/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "CreateProfilePartThree.h"
#import  <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Parse/Parse.h>
#import "Constants.h"
#import "InstagigSingelton.h"

@interface CreateProfilePartThree ()

@end

UIActionSheet * imageOptions;
InstagigSingelton *dataShare;
@implementation CreateProfilePartThree

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationItem.backBarButtonItem.title = @"Back";
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    
    imageOptions = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"What pic would you like to use?", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil)  destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Use Facebook Profile Pic", nil) , NSLocalizedString(@"Upload a pic", nil) , NSLocalizedString(@"Take a selfie", nil) , nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc] init];
   
    [tap addTarget:self action:@selector(tappedPicOne)];
    
    tap.numberOfTapsRequired = 1;
    
    [tapTwo addTarget:self action:@selector(tappedPicTwo)];
    
    tapTwo.numberOfTapsRequired = 1;
 
    dataShare = [InstagigSingelton instagGigObject];
    
    [_imageOne addGestureRecognizer:tap];
    [_imageTwo addGestureRecognizer:tapTwo];
    _imageOne.image = nil;
    _imageTwo.image = nil;
    
    NSArray *arrayButtons = @[_atmosphereButton,_actorButton,_brandButton,_bartenderButton,_bottleButton,_bikiniButton,_dancer,_hairButton,_hostesButton,_promoButton,_photographerButton,_socialButton,_streetButton,_valetButton,_videoButton, _serverButton];
    
    for (UIButton *button  in arrayButtons)
    {
        [button addTarget:self action:@selector(ButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    _tagsArray = [[NSMutableArray alloc] init];
}

-(void)ButtonSelected: (UIButton*)sender
{
    [sender setImage:[UIImage imageNamed:@"CHECKMARK_INSIDE"] forState:UIControlStateNormal];
    
   // [[PFUser currentUser] addObject: sender.titleLabel.text forKey:@"tags"];
    [_tagsArray addObject:sender.titleLabel.text];
    [sender addTarget:self action:@selector(buttonDeSelected:) forControlEvents:UIControlEventTouchUpInside];
    //[[PFUser currentUser] saveInBackground];
}


-(void)buttonDeSelected: (UIButton*)sender
{
    [sender setImage:[UIImage imageNamed:@"CHECK_BOX-1"] forState:UIControlStateNormal];
    //[[PFUser currentUser] removeObject:sender.titleLabel.text forKey:@"tags"];
      [_tagsArray removeObject:sender.titleLabel.text];
    [sender addTarget:self action:@selector(ButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
   // [[PFUser currentUser] saveInBackground];

}

- (void) saveTagsToParse
{
    for (int i = 0; i <= [_tagsArray count] ; i++) {
         [[PFUser currentUser] addObject: [_tagsArray objectAtIndex:i] forKey:@"tags"];
    }
    
    [[PFUser currentUser] saveInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tappedPicOne
{
    _pictureItem = 1;
    
    [imageOptions showInView:self.view];
}

-(void)tappedPicTwo
{
    _pictureItem = 2;
    
    [imageOptions showInView:self.view];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor lightGrayColor];
    header.textLabel.font = [UIFont fontWithName:@"OpenSansRegular" size:12.0];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    return 35.0;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *takePhoto;
    ALAuthorizationStatus photoStatus = [ALAssetsLibrary authorizationStatus];
    AVAuthorizationStatus cameraStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"Looks like you have not allowed us use of your camera or photos. If you go to \"Settings\" then \"Privacy\" you can enable Instagigs access to your photos and camera." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", [PFUser currentUser][FACEBOOKID]]];
    NSMutableURLRequest *request;
    
    switch (buttonIndex)
    {
        case 0:
        {
            request = [NSMutableURLRequest requestWithURL:url];
            
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       if ( !error )
                                       {
                                           
                                           UIImage *image = [[UIImage alloc] initWithData:data];
                                           
                                           NSData *fileData = UIImageJPEGRepresentation(image, .75);
                                           
                                           PFFile *file = [PFFile fileWithName:@"profilePic" data:fileData];
                                           if(_pictureItem == 1)
                                           {
                                              [PFUser currentUser][PROFILE1] = file;
                                               _imageOne.image = image;
                                               
                                               [[PFUser currentUser]saveInBackground];
                                           }
                                        if(_pictureItem == 2)
                                           {
                                               [PFUser currentUser][PROFILE2] = file;
                                               _imageTwo.image = image;
                                               [[PFUser currentUser] saveInBackground];
                                           }
                                       }
                                   }];
            break;
        }
        case 1:
            
            if (photoStatus == ALAuthorizationStatusDenied)
            {
                 [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                takePhoto = [[UIImagePickerController alloc]init];
                takePhoto.delegate = self;
                takePhoto.allowsEditing = YES;
                takePhoto.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:takePhoto animated:YES completion:NULL];
            }

            break;
        case 2:
            if (cameraStatus == AVAuthorizationStatusDenied)
            {
               [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                takePhoto = [[UIImagePickerController alloc] init];
                takePhoto.delegate =self;
                takePhoto.allowsEditing = YES;
                takePhoto.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:takePhoto animated:YES completion:NULL];
            }
            break;
        default:
            break;
    }
    
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    NSString *photoTitle;
    NSString *fileName = @"profilePic";
    
    switch (_pictureItem)
    {
        case 1:
            _imageOne.image = chosenImage;
            [dataShare.theUser.mySnapGigImages setObject:chosenImage forKey:PROFILE1];
            photoTitle = PROFILE1;
            
            break;
        case 2:
            _imageTwo.image = chosenImage;
            [dataShare.theUser.mySnapGigImages setObject:chosenImage forKey:PROFILE2];
            photoTitle = PROFILE2;
            break;
    }
}


#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (indexPath.row == 1)
        {
            if (_imageOne.image != nil && _imageTwo.image != nil)
            {
                [self createUserProfile];
            }
            else
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"You must add 2 profile photos to continue." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
        }
    }
}

-(void) createUserProfile
{
    PFUser *newUser = [PFUser user];
    
    NSMutableDictionary *stepOne = [[NSUserDefaults standardUserDefaults] objectForKey: @"userStepOne"];
    NSMutableDictionary *stepTwo = [[NSUserDefaults standardUserDefaults] objectForKey: @"userStepTwo"];
    
    newUser[FIRSTNAME] = [stepOne objectForKey:@"firstname"];
    newUser[LASTNAME] = [stepOne objectForKey:@"lastname"];
    newUser[EMAIL] = [stepOne objectForKey:@"email"];
    newUser[USERNAME] = [stepOne objectForKey:@"username"];
    newUser[PASSWORD] = [stepOne objectForKey:@"password"];
    newUser[DATEOFBIRTH] = [stepOne objectForKey:@"birthday"];
    newUser[GENDER] = [stepOne objectForKey:@"gender"];
    newUser[ADDRESSLINE1] = [stepOne objectForKey:@"address1"];
    //newUser[ADDRESSLINE2] = [stepOne objectForKey:@"address2"];
    newUser[CITY] = [stepOne objectForKey:@"city"];
    newUser[STATE] = [stepOne objectForKey:@"state"];
    newUser[ZIP] = [stepOne objectForKey:@"zip"];
    
    newUser[PRIMARYLANGUAGE] = [stepTwo objectForKey:@"primarylanguage"];
    //newUser[SECONDARYLANGUAGE] = [stepTwo objectForKey:@"secondarylanguage"];
    newUser[ETHNICITY] = [stepTwo objectForKey:@"ethnicity"];
    newUser[HEIGHT] = [stepTwo objectForKey:@"height"];
    newUser[WEIGHT] = [stepTwo objectForKey:@"weight"];
    newUser[SHIRTSIZE] = [stepTwo objectForKey:@"shirtzise"];
    newUser[VALIDDRIVERSLICENSE] = [stepTwo objectForKey:@"validlicense"];
    newUser[TATTOOS] = [stepTwo objectForKey:@"tattoos"];
    
    NSString *fileName = @"profilePic";
    
    NSData *image = UIImagePNGRepresentation(_imageOne.image);
    PFFile *userImage = [PFFile fileWithName:fileName data:image];
    newUser[PROFILE1] =userImage;
    
    NSData *image2 = UIImagePNGRepresentation(_imageTwo.image);
    PFFile *userImage2 = [PFFile fileWithName:fileName data:image2];
    newUser[PROFILE2] =userImage2;
    
    [newUser addObject: _tagsArray forKey:@"tags"];
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        else
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self performSegueWithIdentifier:@"successProfile" sender:self];
        }
    }];
}

- (IBAction)privacyPolicyButtonPressed:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
}
@end
