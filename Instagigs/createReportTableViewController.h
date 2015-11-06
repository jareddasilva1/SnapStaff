//
//  createReportTableViewController.h
//  Instagigs
//
//  Created by Jerry Phillips on 9/1/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface createReportTableViewController : UITableViewController <UICollectionViewDelegate, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *crCollectionView;
@property (strong, nonatomic) IBOutlet UITextField *totalAttended;
@property (strong, nonatomic) IBOutlet UITextField *totalSampled;
@property (strong, nonatomic) IBOutlet UITextField *accountSpend;
@property (strong, nonatomic) IBOutlet UITextView *notesField;
@property (strong, nonatomic) IBOutlet UITextField *bottleInventory;
@property (strong, nonatomic) NSString* eventId;
@end
