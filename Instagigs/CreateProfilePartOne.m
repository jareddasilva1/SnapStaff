      //
//  CreateProfilePartOne.m
//  Instagigs
//
//  Created by Jerry Phillips on 8/17/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "CreateProfilePartOne.h"
#import  <Parse/Parse.h>
#import  "Constants.h"
#import "InstagigSingelton.h"

@interface CreateProfilePartOne ()

@end

CGSize keyboard_Size;

NSDate *birth;
NSString *gender;
NSNumber *zip;

PFUser *currentUser;

 NSString *comparePassword;

NSArray *stateArray;

InstagigSingelton *shared_Data;

@implementation CreateProfilePartOne

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _firstNameTextField.delegate = self;
    _lastNameTextField.delegate = self;
    _emailTextField.delegate = self;
    _passwordField.delegate = self;
    _confirmPasswordField.delegate = self;
    _addressLineTwo.delegate = self;
    _addressLineOne.delegate = self;
    _cityField.delegate = self;
    _statefield.delegate = self;
    _dateOfBirth.delegate = self;
    _zipCodeField.delegate = self;
    stateArray = @[@"AL",@"AK",@"AZ",@"AR",@"CA",@"CO",
                   @"CT",
                   @"DE",
                   @"FL",
                   @"GA",
                   @"HI",
                   @"ID",
                   @"IL",
                   @"IN",
                   @"IA",
                   @"KS",
                   @"KY",
                   @"LA",
                   @"ME",
                   @"MD",
                   @"MA",
                   @"MI",
                   @"MN",
                   @"MS",
                   @"MO",
                   @"MT",
                   @"NE",
                   @"NV",
                   @"NH",
                   @"NJ",
                   @"NM",
                   @"NY",
                   @"NC",
                   @"ND",
                   @"OH",
                   @"OK",
                   @"OR",
                   @"PA",
                   @"RI",
                   @"SC",
                   @"SD",
                   @"TN",
                   @"TX",
                   @"UT",
                   @"VT",
                   @"VA",
                   @"WA",
                   @"WV",
                   @"WI",
                   @"WY",];
    
    shared_Data = [[InstagigSingelton alloc] init];
    [_isMale addTarget:self action:@selector(male:) forControlEvents:UIControlEventTouchUpInside];
    [_isFemale addTarget:self action:@selector(female:) forControlEvents:UIControlEventTouchUpInside];
    // self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = INSTABLUE;
    
    NSMutableDictionary *stepOne = [[NSUserDefaults standardUserDefaults] objectForKey: @"userStepOne"];
    if (stepOne != nil)
    {
        _firstNameTextField.text = [stepOne objectForKey:@"firstname"];
        _lastNameTextField.text = [stepOne objectForKey:@"lastname"];
        _emailTextField.text = [stepOne objectForKey:@"email"];
        _passwordField.text = [stepOne objectForKey:@"password"];
        _dateOfBirth.text = [self dateFormat:[stepOne objectForKey:@"birthday"]];
        gender = [stepOne objectForKey:@"gender"];
        if ([gender isEqualToString:@"male"])
        {
            [shared_Data buttonState:_isMale :YES];
        }
        else
        {
            [shared_Data buttonState:_isFemale :YES];
        }
        _addressLineOne.text = [stepOne objectForKey:@"address1"];
        _addressLineTwo.text = [stepOne objectForKey:@"address2"];
        _cityField.text = [stepOne objectForKey:@"city"];
        _statefield.text = [stepOne objectForKey:@"state"];
        _zipCodeField.text= [[stepOne objectForKey:@"zip"]stringValue];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(done) name:DISMISSKEYBOARD object:nil];
}

-(void)done
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return stateArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [stateArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _statefield.text = [stateArray objectAtIndex:row];
}



-(void)keyboardWillShow:(NSNotification *)notification
{
    UITableViewCell *cell;
    UITextField *textField;
    UITextView *textView;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        cell = (UITableViewCell *) textField.superview.superview;
        
    }
    
    else
    {
        // Load resources for iOS 7 or later
        if (cell.tag !=7)
        {
            cell = (UITableViewCell *) textField.superview.superview.superview;
        }
        else
            cell = (UITableViewCell *) textView.superview.superview.superview;
        
        // TextField -> UITableVieCellContentView -> (in iOS 7!)ScrollView -> Cell!
        keyboard_Size = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        UIEdgeInsets contentInsets;
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboard_Size.height), 0.0);
        } else {
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboard_Size.width), 0.0);
        }
        
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
        [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
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


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}




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


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == _dateOfBirth)
    {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
        
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        
        [_datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        UIToolbar * bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _datePicker.frame.size.width, 44)];
        
        bar.translucent = YES;
        
        UIBarButtonItem * done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(saveTheDate)];
        
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [bar setItems:[NSArray arrayWithObjects:flexibleSpace, flexibleSpace, done, nil]];
        
        _datePicker.backgroundColor = [UIColor whiteColor];
        _dateOfBirth.inputView = _datePicker;
        textField.inputAccessoryView = bar;
    }
    
    if (textField == _statefield)
    {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
        picker.delegate = self;
       
        
        textField.inputAccessoryView = [shared_Data doneToolBar:self.view];
        textField.inputView = picker;
    }
    
    if (textField == _zipCodeField)
    {
        UIToolbar * bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _datePicker.frame.size.width, 44)];
        
        bar.translucent = YES;
        
        UIBarButtonItem * done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
        
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [bar setItems:[NSArray arrayWithObjects:flexibleSpace, flexibleSpace, done, nil]];
        textField.inputAccessoryView = bar;
    }
}


-(void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    _dateOfBirth.text =  [self dateFormat:datePicker.date];
    
    birth = datePicker.date;
}

-(void) saveTheDate
{
    [self.view endEditing:YES ];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField == _zipCodeField)
    {
        _zipCodeField.text = textField.text;
       // currentUser[ZIP] = [NSNumber numberWithInteger:[textField.text integerValue]];
        zip = [NSNumber numberWithInteger:[textField.text integerValue]];
    }
    if (textField == _firstNameTextField)
    {
        [_lastNameTextField becomeFirstResponder];
    }
    if (textField == _lastNameTextField)
    {
        [_emailTextField becomeFirstResponder];
        
    }
    
    if (textField == _emailTextField)
    {
        if(![self NSStringIsValidEmail:_emailTextField.text])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Email" message:@"Please enter a valid email address." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                        [_emailTextField becomeFirstResponder];
            }];
 
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
            _emailTextField.text = nil;
         
        }
        else
        {
                  [_passwordField becomeFirstResponder];
        }
    }
    
    if (textField == _passwordField)
    {
        if (_passwordField.text.length < 6)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Password is too short" message:@"Please enter a password with at least 6 characters." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            comparePassword = _passwordField.text;
            
            [_confirmPasswordField becomeFirstResponder];
        }
    }
    
    if (textField == _confirmPasswordField)
    {
        if ([_confirmPasswordField.text isEqualToString:comparePassword])
        {
            [_addressLineOne becomeFirstResponder];
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Passwords Do Not Match" message:@"The passwords you entered do not match please re-enter." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
    if (textField == _addressLineOne)
    {
        [_addressLineOne becomeFirstResponder];
    }
    
    if (textField == _addressLineTwo)
    {
        [_cityField becomeFirstResponder];
    }
    
    if (textField == _cityField)
    {
        [_statefield becomeFirstResponder];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.row == 12)
    {
        BOOL isComplete = YES;
        NSString *message;
        
        if (_firstNameTextField.text.length == 0) {
            isComplete = NO;
            message = @"First name missing.";
        }
        else if (_lastNameTextField.text.length == 0) {
            isComplete = NO;
            message = @"Last name missing.";
        }
        else if (_emailTextField.text.length == 0) {
            isComplete = NO;
            message = @"email incomplete.";
        }
        else if (_passwordField.text.length == 0) {
            isComplete = NO;
            message = @"Password missing.";
        }
        else if (_dateOfBirth.text.length == 0) {
            isComplete = NO;
            message = @"Date of birth missing.";
        }
        else if (gender == nil) {
            isComplete = NO;
            message = @"gender missing.";
        }
        else if (_addressLineOne.text.length == 0) {
            isComplete = NO;
            message = @"Address incomplete.";
        }
        else if (_cityField.text.length == 0) {
            isComplete = NO;
            message = @"city missing.";
        }
        else if (_statefield.text.length == 0) {
            isComplete = NO;
            message = @"state missing.";
        }
        else if (_zipCodeField.text.length == 0) {
            isComplete = NO;
            message = @"zip missing.";
        }
        
        if (isComplete)
        {
            [self saveUserInfo];
            [self performSegueWithIdentifier:@"createProfileTwo" sender:self];
        }
        
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Information Required" message:message preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    
    }
}

// Validates email
-(BOOL) NSStringIsValidEmail:(NSString *)checkString {
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void) saveUserInfo
{
    //Save all user data
    _userInfoDict = [[NSMutableDictionary alloc] init];
    
    [_userInfoDict setObject:_firstNameTextField.text forKey:@"firstname"];
    [_userInfoDict setObject:_lastNameTextField.text forKey:@"lastname"];
    [_userInfoDict setObject:_emailTextField.text forKey:@"email"];
    [_userInfoDict setObject:_emailTextField.text forKey:@"username"];
    [_userInfoDict setObject:_firstNameTextField.text forKey:@"firstname"];
    [_userInfoDict setObject:_confirmPasswordField.text forKey:@"password"];
    [_userInfoDict setObject:birth forKey:@"birthday"];
    [_userInfoDict setObject:gender forKey:@"gender"];
    [_userInfoDict setObject:_addressLineOne.text forKey:@"address1"];
    [_userInfoDict setObject:_addressLineTwo.text forKey:@"address2"];
    [_userInfoDict setObject:_cityField.text forKey:@"city"];
    [_userInfoDict setObject:_statefield.text forKey:@"state"];
    [_userInfoDict setObject:[NSNumber numberWithInteger:[_zipCodeField.text integerValue]] forKey:@"zip"];
    
    [[NSUserDefaults standardUserDefaults] setObject:_userInfoDict forKey:@"userStepOne"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


- (void)male:(UIButton *)sender
{
    [shared_Data buttonState:sender :YES];
    [shared_Data buttonState:_isFemale :NO];
    gender = @"male";
}

- (void)female:(UIButton *)sender
{
    [shared_Data buttonState:sender :YES];
    [shared_Data buttonState:_isMale :NO];
     gender = @"female";
}

-(NSString*) dateFormat:(NSDate*)theDate
{
    NSDateFormatter *dateformatter = [[ NSDateFormatter alloc] init];
    
    [dateformatter setDateStyle:NSDateFormatterLongStyle];
    
    NSString * string = [dateformatter stringFromDate:theDate];
    
    return string;
    
}
- (IBAction)closeMe:(UIBarButtonItem *)sender
{
    NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
