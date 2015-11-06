//
//  CreateEventTVC.h
//  Instagigs
//
//  Created by Rahiem Klugh on 10/8/15.
//  Copyright © 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateEventTVC : UITableViewController <UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *startTimeField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeField;
@property (weak, nonatomic) IBOutlet UITextField *eventTypeField;
@property (weak, nonatomic) IBOutlet UITextField *contactNameField;
@property (weak, nonatomic) IBOutlet UITextField *contactNumberField;
@property (weak, nonatomic) IBOutlet UITextField *talentNumberField;
@property (weak, nonatomic) IBOutlet UITextField *notesField;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *brandImage;
@property (strong, nonatomic) IBOutlet UILabel *venueNamePlaceholder;
@property (strong, nonatomic) IBOutlet UILabel *venueName;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UITextField *payRateField;
@property (strong, nonatomic) IBOutlet UILabel *venueLocation;
@property (strong, nonatomic) IBOutlet UILabel *jobTitleLabel;
- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;

@end
