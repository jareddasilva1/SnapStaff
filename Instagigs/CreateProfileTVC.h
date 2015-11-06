//
//  CreateProfileTVC.h
//  Instagigs
//
//  Created by Rahiem Klugh on 10/24/15.
//  Copyright © 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateProfileTVC : UITableViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *stateArray;
    NSNumber *zip;
    NSArray *shirtData;
    NSString *footText;
    NSString *inchText;
    NSArray * languages;
    NSNumber *userHeight;
    NSNumber *userWeight;
    
    NSArray *yearData;
    
    NSArray *heightFootData;
    
    NSArray *heightInchData;
    
    NSMutableArray * weightData;
}

@property (strong, nonatomic) IBOutlet UITextField *cityField;
@property (strong, nonatomic) IBOutlet UITextField *statefield;
@property (strong, nonatomic) IBOutlet UITextField *zipCodeField;
@property (strong, nonatomic) IBOutlet UITextField *_primaryLanguage;
@property (strong, nonatomic) IBOutlet UITextField *secondaryLanguage;
@property (strong, nonatomic) IBOutlet UITextField *ethnicity;
@property (strong, nonatomic) IBOutlet UITextField *height;
@property (strong, nonatomic) IBOutlet UITextField *weight;
@property (strong, nonatomic) IBOutlet UITextField *shirtSize;
@property (strong, nonatomic) IBOutlet UITextField *instagramName;
@property (strong, nonatomic) IBOutlet UITextField *twitterName;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *aboutMe;
- (IBAction)editProfileButtonPressed:(id)sender;

@property (nonatomic, retain) UIPickerView* ethnicityPicker;
@property (nonatomic, retain) UIPickerView* heightSelection;
@property (nonatomic, retain) UIPickerView* weightSelection;
@property (nonatomic, retain) UIPickerView* shirtSizeSelection;
@property(nonatomic, retain)UIPickerView * languagePicker;
@property(nonatomic, retain)UIPickerView * statePicker;
@property (nonatomic) NSMutableDictionary *userInfoDict;

- (IBAction)changePhotoButtonPressed:(id)sender;

@end
