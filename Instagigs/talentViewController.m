//
//  talentViewController.m
//  Instagigs
//
//  Created by Jerry Phillips on 9/7/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "talentViewController.h"
#import "Constants.h"
#import "InstagigSingelton.h"
#import "imageCollectionViewCell.h"
#import "imageTableViewCell.h"
#import "noteTableViewCell.h"
#import  <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "talentInfoTableViewCell.h"
#import "pageViewController.h"


@interface talentViewController ()

@end

NSInteger profile_Number;
NSArray * title_Array;

@implementation talentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatedImages) name:PROFILEPICUPDATED object:nil];
    
    _main_ProfileImageView.layer.cornerRadius = 50;
   
   _main_ProfileImageView.layer.masksToBounds = YES;
    _main_ProfileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _main_ProfileImageView.layer.borderWidth = 1;
    _main_ProfileImageView.image = [_the_CurrentUser.mySnapGigImages objectForKey:PROFILE1];
    _tTableVIew.estimatedRowHeight = 200;
    _tTableVIew.rowHeight = UITableViewAutomaticDimension;
    
    _city_Field.text = [NSString stringWithFormat:@"%@, %@", _the_CurrentUser.userInfo[CITY], _the_CurrentUser.userInfo[STATE]];
    _age_Label.text = [self calculateAge:_the_CurrentUser.userInfo[DATEOFBIRTH]];
    _heightLabel.text = [self calculateheight:_the_CurrentUser.userInfo[HEIGHT]];
    NSNumber *weight = _the_CurrentUser.userInfo[WEIGHT];
    
    _weightLabel.text = [NSString stringWithFormat:@"%@ lbs", weight];
    _sizeLabel.text = _the_CurrentUser.userInfo[SHIRTSIZE];
   
    NSString *langOne = [_the_CurrentUser.userInfo[PRIMARYLANGUAGE] substringToIndex:3];
    NSString *langTwo;
    if (_the_CurrentUser.userInfo[SECONDARYLANGUAGE] != nil)
    {
        langTwo = [_the_CurrentUser.userInfo[SECONDARYLANGUAGE] substringToIndex:3];
    }
    else
    {
        langTwo = @"";
    }
    _langLabel.text = [NSString stringWithFormat:@"%@, %@", langOne, langTwo];
    
    
    _nameAndPlaceLabel.text = [NSString stringWithFormat:@"%@ %@.",_the_CurrentUser.userInfo[FIRSTNAME], [_the_CurrentUser.userInfo[LASTNAME] substringToIndex:1]];
  
    title_Array = @[@"FIRST NAME",@"LAST NAME",@"EMAIL",@"ADDRESS",@"ADDRESS LINE TWO",@"CITY",@"STATE", @"ZIP", @"DATE OF BIRTH", @"GENDER",@"HEIGHT", @"WEIGHT", @"PRIMARY LANGUAGE", @"SECONDARY LANGUAGE", @"SHIRT SIZE", @"TATTOOS", @"ETHNICITY" ];
    
}

//update the profile pic when is has downloaded
-(void)updatedImages
{
    _main_ProfileImageView.image = [_the_CurrentUser.mySnapGigImages objectForKey:PROFILE1];
    [_tTableVIew reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     InstagigSingelton *sharedData = [InstagigSingelton instagGigObject];
    
     UIActionSheet *select_Image = [[UIActionSheet alloc]initWithTitle:@"Add a profile pic" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use Facebook profile",@"Take a selfie",@"Upload a pic", nil];
    if (indexPath.row == sharedData.theUser.mySnapGigImages.count)
    {
        profile_Number = indexPath.row+1;
        [select_Image showInView:self.view];
    }
    else
    {
          [self performSegueWithIdentifier:@"viewImages" sender:self];
    }
   
    
    
}

#pragma UICOLLECTIONVIEW METHODS

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
  
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    InstagigSingelton *sharedData = [InstagigSingelton instagGigObject];
    
    return sharedData.theUser.mySnapGigImages.count + 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InstagigSingelton *sharedData = [InstagigSingelton instagGigObject];
    static NSString *cellIdentifier = @"imageCollectionViewCell";
    UINib *cellNib = [UINib nibWithNibName:@"imageCollectionViewCell" bundle:nil];
    [collectionView registerNib:cellNib forCellWithReuseIdentifier:@"imageCollectionViewCell"];
    
    imageCollectionViewCell *cell = (imageCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSInteger count = sharedData.theUser.mySnapGigImages.count;
    
    if (indexPath.row == count)
    {
        return cell;
    }
    else
    {
        cell.imageView.backgroundColor = [UIColor clearColor];
        NSString *key = [NSString stringWithFormat:@"profile%ld", indexPath.row+1];
        cell.imageView.image = [sharedData.theUser.mySnapGigImages objectForKey:key];
        
        
    }
    
    return cell;
    
    
}


-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor lightGrayColor];
    header.textLabel.font = [UIFont fontWithName:@"OpenSansRegular" size:12.0];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentLeft;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2)
    {
        return title_Array.count;
    }
    
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"PHOTOS";
            break;
            
            
        case 1:
            return @"ABOUT ME";
            break;
            
            
        case 2:
            return @"INFO";
            break;
            
        
            
        default:
            return nil;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    imageTableViewCell * imageCell = [tableView dequeueReusableCellWithIdentifier:@"imageTableViewCell"];
    
    noteTableViewCell *noteCell = [tableView dequeueReusableCellWithIdentifier:@"noteTableViewCell"];
    
    talentInfoTableViewCell *talentCell = [tableView dequeueReusableCellWithIdentifier:@"talentInfoTableViewCell"];
    
    
    
    if (imageCell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"imageTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                imageCell =  (imageTableViewCell *) currentObject;
                break;
            }
        }
    }
    
    if (noteCell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"noteTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                noteCell =  (noteTableViewCell *) currentObject;
                break;
            }
        }
    }
    
    if (talentCell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"talentInfoTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                talentCell =  (talentInfoTableViewCell *) currentObject;
                break;
            }
        }
    }
    
    
    if (indexPath.section == 0)
    {
        _image_CollectionView = imageCell.collectionView;
        
        _image_CollectionView.delegate = self;
        _image_CollectionView.dataSource = self;
        
        imageCell.imageView.backgroundColor = [UIColor clearColor];
        return imageCell;
    }
    
    if (indexPath.section == 1)
    {
        return noteCell;
    }
    
    if (indexPath.section == 2)
    {
        talentCell.labeText.text = [title_Array objectAtIndex:indexPath.row];
        talentCell.TalenttextField.delegate = self;
        
        
        switch (indexPath.row)
        {
                
            case 0:
                if (_the_CurrentUser.userInfo[FIRSTNAME] != nil)
                {
                    talentCell.TalenttextField.text = _the_CurrentUser.userInfo[FIRSTNAME];
                }
                break;
            case 1:
                if (_the_CurrentUser.userInfo[LASTNAME] != nil)
                {
                    talentCell.TalenttextField.text = _the_CurrentUser.userInfo[LASTNAME];
                }
                break;
            case 2:
                if (_the_CurrentUser.userInfo[EMAIL] != nil)
                {
                    talentCell.TalenttextField.text = _the_CurrentUser.userInfo[EMAIL];
                }
                break;
            case 3:
                if (_the_CurrentUser.userInfo[ADDRESSLINE1] != nil)
                {
                    talentCell.TalenttextField.text = _the_CurrentUser.userInfo[ADDRESSLINE1];
                }
                break;
            case 4:
                if (_the_CurrentUser.userInfo[ADDRESSLINE2] != nil)
                {
                    talentCell.TalenttextField.text = _the_CurrentUser.userInfo[ADDRESSLINE2];
                }
                break;
            case 5:
                if (_the_CurrentUser.userInfo[CITY] != nil)
                {
                    talentCell.TalenttextField.text = _the_CurrentUser.userInfo[CITY];
                }
                break;
            case 6:
                if (_the_CurrentUser.userInfo[STATE] != nil)
                {
                    talentCell.TalenttextField.text = _the_CurrentUser.userInfo[STATE] ;
                    
                }
                break;
            case 7:
                if (_the_CurrentUser.userInfo[@"zip"] != nil)
                {
                    talentCell.TalenttextField.text =  talentCell.TalenttextField.text = _the_CurrentUser.userInfo[@"zip"] ;
                }
                break;
            case 8:
                if (_the_CurrentUser.userInfo[DATEOFBIRTH] != nil)
                {
                    talentCell.TalenttextField.text = [_the_CurrentUser dateFormatter:_the_CurrentUser.userInfo[DATEOFBIRTH] justTime:NO numberic:NO] ;
                }
                break;
            case 9:
                if (_the_CurrentUser.userInfo[GENDER] != nil)
                {
                    talentCell.TalenttextField.text = _the_CurrentUser.userInfo[GENDER] ;
                    
                }
                break;
            case 10:
                if (_the_CurrentUser.userInfo[HEIGHT] != nil)
                {
                    NSInteger feet = [_the_CurrentUser.userInfo[HEIGHT] integerValue]/12;
                    
                    NSInteger inch = [_the_CurrentUser.userInfo[HEIGHT] integerValue]%12;
                    talentCell.TalenttextField.text = [NSString stringWithFormat:@"%ldft, %ldin", (long)feet, (long)inch]  ;
                }
                break;
            case 11:
                if (_the_CurrentUser.userInfo[WEIGHT] != nil)
                {
                    talentCell.TalenttextField.text = [_the_CurrentUser.userInfo[WEIGHT] stringValue]  ;
                }
                break;
            case 12:
                if (_the_CurrentUser.userInfo[PRIMARYLANGUAGE] != nil)
                {
                    talentCell.TalenttextField.text = _the_CurrentUser.userInfo[PRIMARYLANGUAGE]   ;
                }
                break;
            case 13:
                if (_the_CurrentUser.userInfo[SECONDARYLANGUAGE] != nil)
                {
                    talentCell.TalenttextField.text = _the_CurrentUser.userInfo[SECONDARYLANGUAGE]   ;
                }
              
                break;
            case 14:
                if (_the_CurrentUser.userInfo[SHIRTSIZE] != nil)
                {
                    talentCell.TalenttextField.text = _the_CurrentUser.userInfo[SHIRTSIZE]   ;
                }
          
                break;
            case 15:
                if (_the_CurrentUser.userInfo[TATTOOS] != nil)
                {
                    NSString *answer;
                    if ([_the_CurrentUser.userInfo[TATTOOS] isEqual:@NO])
                    {
                        answer = @"NONE";
                    }
                    else
                    {
                        answer = @"YES";
                    }
                    talentCell.TalenttextField.text = answer  ;
                }
             
                break;
            case 16:
                  
                if (_the_CurrentUser.userInfo[ETHNICITY] != nil)
                {
                
                    talentCell.TalenttextField.text = _the_CurrentUser.userInfo[ETHNICITY]   ;
                }
                
            
                break;
                
            default:
                break;
        }
        
        return talentCell;
    }
    
    return nil;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _current_TextField = textField;
    
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    if ([segue.identifier isEqualToString:@"viewImages"])
    {
        
        UINavigationController *nav = segue.destinationViewController;
        
        pageViewController *imageViews = (pageViewController *)nav.topViewController;
        
        [imageViews createPageViewController: _the_CurrentUser.mySnapGigImages];
        
    }
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
    
    InstagigSingelton *sharedData = [InstagigSingelton instagGigObject];
    
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
                                           
                                           NSString *profileName = [NSString stringWithFormat:@"profile%ld", (long)profile_Number];
                                               [PFUser currentUser][profileName] = file;
                                           [sharedData.theUser.mySnapGigImages setObject:image forKey:profileName];
                                           [_image_CollectionView reloadData];
                                           
                                               [[PFUser currentUser]saveInBackground];
                                       
                                       }
                                   }];
            break;
        }
        case 1:
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
                [self presentViewController:takePhoto animated:YES completion:nil];
            }
            break;
        default:
            break;

        case 2:
            
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
                [self presentViewController:takePhoto animated:YES completion:nil];
            }
            
            break;
          }
    
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    NSString *photoTitle;
    NSString *fileName = @"profilePic";
    
    InstagigSingelton *sharedData = [InstagigSingelton instagGigObject];
    
     NSData *fileData = UIImageJPEGRepresentation(chosenImage, .75);
    
    
    PFFile *file = [PFFile fileWithName:@"profilePic" data:fileData];
    
    photoTitle = [NSString stringWithFormat:@"profile%ld", (long)profile_Number];
    [PFUser currentUser][photoTitle] = file;
    [sharedData.theUser.mySnapGigImages setObject:chosenImage forKey:photoTitle];
    [_image_CollectionView reloadData];
    
    [[PFUser currentUser]saveInBackground];

    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
        
        
    
    
    
}

-(NSString *)calculateAge: (NSDate *)date
{
    NSDate * today = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:date
                                       toDate:today
                                       options:0];
    
    NSInteger age = [ageComponents year];
    
    return [@(age) stringValue];
    
}

-(NSString *)calculateheight: (NSNumber *)height
{
    NSInteger total = [height integerValue];
    
    NSInteger foot = total/12;
    
    NSInteger inch = total%12;
    
    return [NSString stringWithFormat:@"%ld' %ld\" ", (long)foot, (long)inch];
}


- (IBAction)closeTalentProfile:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
