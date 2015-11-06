//
//  CreateProfilePartOne.h
//  Instagigs
//
//  Created by Jerry Phillips on 8/17/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateProfilePartOne : UITableViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (strong, nonatomic) IBOutlet UITextField *addressLineOne;
@property (strong, nonatomic) IBOutlet UIButton *isMale;
@property (strong, nonatomic) IBOutlet UIButton *isFemale;
@property (strong, nonatomic) IBOutlet UITextField *dateOfBirth;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextField *addressLineTwo;
@property (strong, nonatomic) IBOutlet UITextField *cityField;
@property (strong, nonatomic) IBOutlet UITextField *statefield;
@property (strong, nonatomic) IBOutlet UITextField *zipCodeField;

@property (nonatomic) NSMutableDictionary *userInfoDict;

- (IBAction)closeMe:(UIBarButtonItem *)sender;


@end
