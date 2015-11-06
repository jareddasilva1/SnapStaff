//
//  CreateProfilePartTwo.h
//  Instagigs
//
//  Created by Jerry Phillips on 8/20/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateProfilePartTwo : UITableViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UITextField *_primaryLanguage;

@property (strong, nonatomic) IBOutlet UITextField *secondaryLanguage;
@property (strong, nonatomic) IBOutlet UIButton *licenseYes;
@property (strong, nonatomic) IBOutlet UIButton *licenceNo;
@property (strong, nonatomic) IBOutlet UITextField *ethnicity;

@property (strong, nonatomic) IBOutlet UITextField *height;
@property (strong, nonatomic) IBOutlet UITextField *weight;
@property (strong, nonatomic) IBOutlet UITextField *shirtSize;
@property (strong, nonatomic) IBOutlet UIButton *tatoosYes;
@property (strong, nonatomic) IBOutlet UIButton *tatoosNo;
@property (nonatomic, retain) UIPickerView* ethnicityPicker;
@property (nonatomic, retain) UIPickerView* heightSelection;
@property (nonatomic, retain) UIPickerView* weightSelection;
@property (nonatomic, retain) UIPickerView* shirtSizeSelection;

@property(nonatomic, retain)UIPickerView * languagePicker;
@property (nonatomic) NSMutableDictionary *userInfoDict;
@end
