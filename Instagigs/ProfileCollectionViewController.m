//
//  ProfileCollectionViewController.m
//  collectionview
//
//  Created by Rahiem Klugh on 10/1/15.
//  Copyright (c) 2015 Rahiem Klugh. All rights reserved.
//

#import "ProfileCollectionViewController.h"
#import "ProfileHeaderView.h"
#import "ImagesCollectionViewCell.h"
#import "Constants.h"
#import "LGSemiModalNavViewController.h"
#import "InstagigUser.h"
#import "InstagigSingelton.h"
#import  <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Parse/Parse.h>

@interface ProfileCollectionViewController ()
@property (nonatomic, assign) LGViewControllerFormat format;
@end

static InstagigUser *sharedUser;
static InstagigSingelton *sharedSingleton;
@implementation ProfileCollectionViewController

static NSString * const reuseIdentifier = @"imageCell";
static NSString * const reuseIdentifierHeader = @"ProfileHeaderView";
NSArray *recipeImages;


-(id)initWithFormat:(LGViewControllerFormat)format{
    
    self = [super init];
    if (self) {
        _format = format;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    
    // Register cell classes
    //    [self.collectionView registerClass:[ImagesCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    UIButton *btnNext1 =[[UIButton alloc] init];
    [btnNext1 setBackgroundImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    
    btnNext1.frame = CGRectMake(100, 100, 30, 8);
    UIBarButtonItem *btnNext =[[UIBarButtonItem alloc] initWithCustomView:btnNext1];
    [btnNext1 addTarget:self action:@selector(editAccount) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = btnNext;
    
    // Do any additional setup after loading the view.
    // Initialize recipe image array
    recipeImages = @[@"1.png", @"3.png", @"5.png"];
    
    PFUser *user = [PFUser currentUser];
    
    //Photo number calc
    photos = [self getPhotos];
    photosinc = 0;
    PhotoToSave = [NSString stringWithFormat:@"profile%i", photos+1];
    
    self.title= [NSString stringWithFormat:@"%@", user[FIRSTNAME]];
    
    //[self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setTranslucent:YES];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barTintColor = INSTABLUE;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName :[UIColor whiteColor]};
    
    
    sharedUser = [[InstagigUser alloc] initWithParseUser:[PFUser currentUser]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getProfileImage) name:PROFILEPICUPDATED object:nil];
    
    
}

-(void)getProfileImage
{
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
    [self.collectionView reloadData];
    [self.collectionView setNeedsDisplay];
    //    _backgroundImage.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height/2);
    //
    //    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //    blurEffectView.alpha = 0.90;
    //    blurEffectView.frame = _backgroundImage.bounds;
    //    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //
    //    [_backgroundImage addSubview:blurEffectView];
}


-(void)dismissViewControllerWasPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)buttonWasPressed{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ProfileInfo" bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"@ProfileInfo"];
    
    //LGViewController *lgVC = [[LGViewController alloc]initWithFormat:LGViewControllerFormatGoBack];
    LGSemiModalNavViewController *semiModal = [[LGSemiModalNavViewController alloc]initWithRootViewController:vc];
    semiModal.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 250);
    
    semiModal.backgroundShadeColor = [UIColor blackColor];
    semiModal.animationSpeed = 0.35f;
    semiModal.tapDismissEnabled = YES;
    semiModal.backgroundShadeAlpha = 0.4;
    semiModal.scaleTransform = CGAffineTransformMakeScale(.94, .94);
    
    
    [self presentViewController:semiModal animated:YES completion:nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

-(void) editAccount
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Profile Menu"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Add Photo From Camera",@"Take a Selfie", @"Add Photo From Facebook", @"Edit Profile", nil];
    
    [actionSheet showInView:self.view];
}



-(void)addPhoto
{
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return sharedUser.mySnapGigImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImagesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // load the image for this cell

    PhotoToDisplay = [NSString stringWithFormat:@"profile%li", (long)indexPath.row +1];
    
    cell.imageView.image = [sharedUser.mySnapGigImages objectForKey:PhotoToDisplay];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    
    ProfileHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                     UICollectionElementKindSectionHeader withReuseIdentifier:@"ProfileHeaderView" forIndexPath:indexPath];
    
    headerView.tagView.layer.borderWidth = 1.5;
    headerView.tagView.layer.borderColor =  [UIColor lightGrayColor].CGColor;
    
    //headerView.profileImage.layer.shadowColor = [UIColor whiteColor].CGColor;
    headerView.profileImage.layer.cornerRadius = headerView.profileImage.frame.size.height/2;;
    headerView.profileImage.layer.borderWidth = 2;
    headerView.profileImage.layer.masksToBounds = YES;
    headerView.profileImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    headerView.profileImage.image = [sharedUser.mySnapGigImages objectForKey:PROFILE1];
    
    headerView.
    viewProfileButton.layer.cornerRadius = 5;
    headerView.viewProfileButton.layer.masksToBounds = YES;
    headerView.viewProfileButton.layer.borderColor = [UIColor whiteColor].CGColor;
    headerView.viewProfileButton.layer.borderWidth = 1;
    
    headerView.nameLabel.text = @"Miami, FL";
    headerView.cityStateLabel.text = @"25 Years Old";
    
    
    [headerView.instagramButton addTarget:self action:@selector(instagramButtonPressed)forControlEvents:UIControlEventTouchDown];
    [headerView.facebookButton addTarget:self action:@selector(facebookButtonPressed)forControlEvents:UIControlEventTouchDown];
    [headerView.twitterButton addTarget:self action:@selector(twitterButtonPressed)forControlEvents:UIControlEventTouchDown];
    [headerView.viewProfileButton addTarget:self action:@selector(buttonWasPressed)forControlEvents:UIControlEventTouchDown];
    
    [self updateSectionHeader:headerView forIndexPath:indexPath];
    
    headerView.backgroundImage.image = [sharedUser.mySnapGigImages objectForKey:PROFILE1];
    headerView.backgroundImage.alpha = 0.5;
    
    return headerView;
}


- (void)facebookButtonPressed
{
     //
}

- (void)twitterButtonPressed
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter your twitter name to link your twitter account" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"GO" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //  [action doSomething];
                                                              UITextField *alertText = alert.textFields.firstObject;
                                                              [self updateTwitter:alertText.text];
                                                          }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancel];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        if ([PFUser currentUser][TWITTER]!= nil) {
            textField.text = [PFUser currentUser][TWITTER];
        }
        else
        {
            textField.placeholder = @"@username";
        }
        
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    if (alert) {
        
        //go and get the action field
        
     
        
        
    }
}


- (void)instagramButtonPressed
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter your instagram name to link your instagram account" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"GO" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              UITextField *alertText = alert.textFields.firstObject;
                                                              [self updateIG:alertText.text];
                                                          }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancel];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        if ([PFUser currentUser][INSTAGRAM]!= nil) {
            textField.text = [PFUser currentUser][INSTAGRAM];
        }
        else
        {
            textField.placeholder = @"@username";
        }
    
        
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)updateTwitter: (NSString*) name
{
    PFUser *user = [PFUser currentUser];
    user[TWITTER] = name;
    [user saveInBackground];
}
-(void)updateIG: (NSString*) name
{
    PFUser *user = [PFUser currentUser];
    user[INSTAGRAM] = name;
    [user saveInBackground];
}

- (void)updateSectionHeader:(UICollectionReusableView *)header forIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [NSString stringWithFormat:@"header #%li", (long)indexPath.row];
    
    NSLog(@"HELLO: %@", text);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize returnSize = CGSizeZero;
    
    returnSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width /3)-3, ([UIScreen mainScreen].bounds.size.width /3)-3);
    //returnSize = CGSizeMake(123.0, 123.0);
    
    return returnSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}


// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(2,2,2,2);  // top, left, bottom, right
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
        case 0:  //Cam
        {
            
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
        }
        case 1: //Selfie
            
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
        case 2: //FB
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
                                           
                                           
                                           [PFUser currentUser][PhotoToSave] = file;
                                           [[PFUser currentUser]saveInBackground];
                                       }
                                   }];
            
            
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
    
    [sharedSingleton.theUser.mySnapGigImages setObject:chosenImage forKey:PROFILE1];
  //  photoTitle = PROFILE1;
    
    NSData *fileData = UIImageJPEGRepresentation(chosenImage, .75);
    PFFile *file = [PFFile fileWithName:fileName data:fileData];

    [PFUser currentUser][PhotoToSave] = file;
        
    [[PFUser currentUser]saveInBackground];
     [self dismissViewControllerAnimated:YES completion:nil];
    
}



-(int) getPhotos
{
    
    int photonumber = 0;
    
    if ([PFUser currentUser][PROFILE1]) {
        photonumber++;
    }
    if ([PFUser currentUser][PROFILE2]) {
        photonumber++;
    }
    if ([PFUser currentUser][PROFILE3]) {
        photonumber++;
    }
    if ([PFUser currentUser][PROFILE4]) {
        photonumber++;
    }
    if ([PFUser currentUser][PROFILE5]) {
        photonumber++;
    }
    if ([PFUser currentUser][PROFILE6]) {
        photonumber++;
    }
    if ([PFUser currentUser][PROFILE7]) {
        photonumber++;
    }
    if ([PFUser currentUser][PROFILE8]) {
        photonumber++;
    }
    if ([PFUser currentUser][PROFILE9]) {
        photonumber++;
    }
    
    return photonumber;
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end
