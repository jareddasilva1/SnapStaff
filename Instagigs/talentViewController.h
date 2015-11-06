//
//  talentViewController.h
//  Instagigs
//
//  Created by Jerry Phillips on 9/7/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "InstagigUser.h"

@interface talentViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, UITextViewDelegate>


@property (strong, nonatomic) IBOutlet UILabel *nameAndPlaceLabel;
- (IBAction)closeTalentProfile:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITableView *tTableVIew;
@property (strong, nonatomic) IBOutlet UIImageView *main_ProfileImageView;
@property(strong, nonatomic) UICollectionView *image_CollectionView;
@property (strong, nonatomic) IBOutlet UILabel *city_Field;
@property (strong, nonatomic) IBOutlet UILabel *age_Label;
@property (strong, nonatomic) IBOutlet UILabel *heightLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightLabel;
@property (strong, nonatomic) IBOutlet UILabel *langLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (nonatomic) BOOL editable;
@property (nonatomic, strong)UITextField *current_TextField;
@property(nonatomic, strong)InstagigUser *the_CurrentUser;

@end
