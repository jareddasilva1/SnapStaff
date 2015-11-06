//
//  createReportTableViewController.m
//  Instagigs
//
//  Created by Jerry Phillips on 9/1/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "createReportTableViewController.h"

#import "Constants.h"

#import "selectImageCollectionViewCell.h"

#import <Parse/Parse.h>

#import "InstagigSingelton.h"

#import  <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "imageControllerViewController.h"

@interface createReportTableViewController ()

@end
InstagigSingelton *sharedDataObject;
PFObject *eventReportObject;
NSMutableDictionary * imageDictionary;
NSInteger pictureItem;
@implementation createReportTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    PFQuery *query = [PFQuery queryWithClassName:REPORTS];
//    
//    [query whereKey:REPORTEVENT equalTo:_eventId];
//    
//    [query whereKey:REPORTEE equalTo:[PFUser currentUser]];
//    
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject * object, NSError *error)
//     {
//         if (!error && object != nil)
//         {
//             eventReportObject = object;
//         }
//         else
//         {
//             eventReportObject = [PFObject objectWithClassName:REPORTS];
//             
//         }
//     }];
    
    sharedDataObject = [InstagigSingelton instagGigObject];
    _notesField.text = @"";
    
    imageDictionary = [[NSMutableDictionary alloc] init];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

{
    pictureItem = indexPath.row;
     UIActionSheet *imageOptions = [[UIActionSheet alloc] initWithTitle:@"Camera Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    
    switch (indexPath.row)
    {
        case 0:
            if ([imageDictionary objectForKey:RECEIPT] != nil)
            {
                [self performSegueWithIdentifier:@"viewImage" sender:self];
            }
            else
            {
               [imageOptions showInView:self.view];
            }
            break;
        case 1:
            if ([imageDictionary objectForKey:TABLESETUP] != nil)
            {
                [self performSegueWithIdentifier:@"viewImage" sender:self];
            }
            else
            {
                [imageOptions showInView:self.view];
            }
            break;
        case 2:
            if ([imageDictionary objectForKey:SHELFDISPLAY] != nil)
            {
                [self performSegueWithIdentifier:@"viewImage" sender:self];
            }
            else
            {
                [imageOptions showInView:self.view];
            }
            break;
        case 3:
            if ([imageDictionary objectForKey:CUSTOMER1] != nil)
            {
                [self performSegueWithIdentifier:@"viewImage" sender:self];
            }
            else
            {
                [imageOptions showInView:self.view];
            }
            break;
        case 4:
            if ([imageDictionary objectForKey:CUSTOMER2] != nil)
            {
                [self performSegueWithIdentifier:@"viewImage" sender:self];
            }
            else
            {
                [imageOptions showInView:self.view];
            }
            break;
        case 5:
            if ([imageDictionary objectForKey:CUSTOMER3] != nil)
            {
                [self performSegueWithIdentifier:@"viewImage" sender:self];
            }
            else
            {
                [imageOptions showInView:self.view];
            }
            break;
        default:
            break;
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
    
    
    
    switch (buttonIndex)
    {
        case 0:
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
            
                   break;
        default:
            break;
    }
    
}


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    NSString *photoTitle;
    NSString *fileName = @"image";
    
    switch (pictureItem)
    {
        case 0:
            [imageDictionary setObject:chosenImage forKey:RECEIPT];
            photoTitle = RECEIPT;
            
            break;
        case 1:
            [imageDictionary setObject:chosenImage forKey:TABLESETUP];
            photoTitle = TABLESETUP;
            break;
        case 2:
            [imageDictionary setObject:chosenImage forKey:SHELFDISPLAY];
            photoTitle = SHELFDISPLAY;
            break;
        case 3:
            [imageDictionary setObject:chosenImage forKey:CUSTOMER1];
            photoTitle = CUSTOMER1;
            break;
        case 4:
            [imageDictionary setObject:chosenImage forKey:CUSTOMER2];
            photoTitle = CUSTOMER2;
            break;
        case 5:
            [imageDictionary setObject:chosenImage forKey:CUSTOMER3];
            photoTitle = CUSTOMER3;
            break;
            
            default:
            break;
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        NSData *image = UIImagePNGRepresentation(chosenImage);
        PFFile *userImage = [PFFile fileWithName:fileName data:image];
        eventReportObject[photoTitle] = userImage;
        [eventReportObject saveInBackground];
        [_crCollectionView reloadData];
    
    }];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 6)
    {
        if (indexPath.row == 2)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"selectImageCollectionViewCell";
    UINib *cellNib = [UINib nibWithNibName:@"selectImageCollectionViewCell" bundle:nil];
    [_crCollectionView registerNib:cellNib forCellWithReuseIdentifier: @"selectImageCollectionViewCell"];
    
    selectImageCollectionViewCell *cell = (selectImageCollectionViewCell*)[_crCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row)
    {
        case 0:
            cell.itemTitle.text = @"Receipt";
            if ([imageDictionary objectForKey:RECEIPT] != nil)
            {
                cell.itemImage.image = [imageDictionary objectForKey:RECEIPT];
            }
            return cell;
            break;
        case 1:
            cell.itemTitle.text = @"Table Set-up";
            if ([imageDictionary objectForKey:TABLESETUP] != nil)
            {
                cell.itemImage.image = [imageDictionary objectForKey:TABLESETUP];
            }
            return cell;
            break;
        case 2:
            cell.itemTitle.text = @"Shelf Display";
            if ([imageDictionary objectForKey:SHELFDISPLAY] != nil)
            {
                cell.itemImage.image = [imageDictionary objectForKey:SHELFDISPLAY];
            }
            return cell;
            break;
        case 3:
            cell.itemTitle.text = @"Customer #1";
            if ([imageDictionary objectForKey:CUSTOMER1] != nil)
            {
                cell.itemImage.image = [imageDictionary objectForKey:CUSTOMER1];
            }
            return cell;
            break;
        case 4:
            cell.itemTitle.text = @"Customer #2";
            if ([imageDictionary objectForKey:CUSTOMER2] != nil)
            {
                cell.itemImage.image = [imageDictionary objectForKey:CUSTOMER2];
            }
            return cell;
            break;
        case 5:
            cell.itemTitle.text = @"Customer #3";
            if ([imageDictionary objectForKey:CUSTOMER3] != nil)
            {
                cell.itemImage.image = [imageDictionary objectForKey:CUSTOMER3];
            }
            return cell;
            break;
            
        default:
            return nil;
            break;
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(done) name:DISMISSKEYBOARD object:nil];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView = [sharedDataObject doneToolBar:self.view];
    
}

-(void)done
{
    [self.view endEditing:YES];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    _notesField.text = textView.text;
    eventReportObject[CUSTOMERFEEDBACK] = textView.text;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _totalAttended)
    {
        _totalAttended.text = textField.text;
        eventReportObject[TOTALATTENDED] = [NSNumber numberWithInteger:[textField.text integerValue]];
        
    }
    if (textField == _totalSampled)
    {
        _totalSampled.text = textField.text;
        eventReportObject[TOTALSAMPLED] = [NSNumber numberWithInteger:[textField.text integerValue]];
        
    }
    if (textField == _accountSpend)
    {
        _accountSpend.text = textField.text;
        eventReportObject[ACCOUNTSPEND] = [NSNumber numberWithFloat:[textField.text floatValue]];
        
    }
    if (textField == _bottleInventory)
    {
        _bottleInventory.text = textField.text;
        eventReportObject[BOTTLEINVENTORY] = [NSNumber numberWithInteger:[textField.text integerValue]];
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

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


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([segue.identifier isEqualToString:@"viewImage"])
    {
        UINavigationController *nav = segue.destinationViewController;
        
        imageControllerViewController *image = (imageControllerViewController *)nav.topViewController;
        
        switch (pictureItem)
        {
            case 0:
              image.image = [imageDictionary objectForKey:RECEIPT];
                
                break;
            case 1:
                image.image = [imageDictionary objectForKey:TABLESETUP];
               
                break;
            case 2:
                image.image = [imageDictionary objectForKey:SHELFDISPLAY];
               
                break;
            case 3:
                image.image = [imageDictionary objectForKey:CUSTOMER1];
               
                break;
            case 4:
                image.image = [imageDictionary objectForKey:CUSTOMER2];
                
                break;
            case 5:
                image.image = [imageDictionary objectForKey:CUSTOMER3];
               
                break;
                
            default:
                break;
        }

        
        
    }
}


@end
