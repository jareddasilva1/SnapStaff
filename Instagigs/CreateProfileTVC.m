//
//  CreateProfileTVC.m
//  Instagigs
//
//  Created by Rahiem Klugh on 10/24/15.
//  Copyright © 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "CreateProfileTVC.h"
#import "InstagigSingelton.h"
#import "InstagigUser.h"
#import "Constants.h"

@interface CreateProfileTVC ()

@end

static InstagigUser *sharedUser;
static InstagigSingelton *sharedSingleton;


@implementation CreateProfileTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    sharedSingleton = [InstagigSingelton instagGigObject];
    sharedUser = [[InstagigUser alloc] initWithParseUser:[PFUser currentUser]];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getProfileImage) name:PROFILEPICUPDATED object:nil];
    
    self.title = @"Complete Profile";

    _cityField.delegate = self;
    _statefield.delegate = self;
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
    
    
    inchText = @"0";
    
    languages = [[NSArray alloc]initWithObjects:@"English", @"Arabic", @"Chinese", @"French", @"German" , @"Italian", @"Korean", @"Russian", @"Spanish", @"Tagalong", @"Vietnamese", nil];
    
    //Set the default primary language to english
    __primaryLanguage.text = [languages objectAtIndex:0];

    _ethnicity.delegate = self;
    _height.delegate = self;
    _weight.delegate = self;
    _shirtSize.delegate = self;
    __primaryLanguage.delegate = self;
    _secondaryLanguage.delegate = self;
    
    weightData = [[NSMutableArray alloc] init];
    for (int i = 99; i < 250; i++)
    {
        NSNumber *num = [NSNumber numberWithInt:i];
        [weightData addObject:num];
    }
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.backgroundColor = [UIColor whiteColor];
    
    if (textField == _statefield)
    {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
        picker.delegate = self;
        
        
        textField.inputAccessoryView = [sharedSingleton doneToolBar:self.view];
        textField.inputView = picker;
    }
    
    if (textField == _zipCodeField)
    {
        UIToolbar * bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        
        bar.translucent = YES;
        
        UIBarButtonItem * done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
        
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [bar setItems:[NSArray arrayWithObjects:flexibleSpace, flexibleSpace, done, nil]];
        textField.inputAccessoryView = bar;
    }
    
    if (textField == _statefield)
    {
        
        
        _statePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
        _statePicker.tag = 0;
        
        _statePicker.delegate = self;
        _statePicker.dataSource = self;
        _statePicker.backgroundColor = [UIColor whiteColor];
        _statefield.inputView = _statePicker;
    }
    if (textField == __primaryLanguage)
    {
        
        
        _languagePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
        _languagePicker.tag = 0;
        
        _languagePicker.delegate = self;
        _languagePicker.dataSource = self;
        _languagePicker.backgroundColor = [UIColor whiteColor];
        __primaryLanguage.inputView = _languagePicker;
    }
    
    if (textField == _secondaryLanguage)
    {
        
        if (_languagePicker == nil)
        {
            _languagePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
            _languagePicker.tag = 0;
            _languagePicker.backgroundColor = [UIColor whiteColor];
            _languagePicker.delegate = self;
            _languagePicker.dataSource = self;
        }
        _languagePicker.tag = 1;
        _secondaryLanguage.inputView = _languagePicker;
    }
    if (textField == _ethnicity)
    {
        yearData = [[NSArray alloc] initWithObjects:@"American Indian or Alaskan Native",
                    @"Asian",
                    @"Black or African American",
                    @"Hawaiian or Other Pacific Islander",
                    @"White", @"Latino", nil];
        
        _ethnicityPicker = [[UIPickerView alloc ]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
        _ethnicityPicker.backgroundColor = [UIColor whiteColor];
        _ethnicityPicker.delegate = self;
        _ethnicityPicker.dataSource = self;
        
        _ethnicity.inputView = _ethnicityPicker;
        
    }
    
    
    
    if (textField == _height)
    {
        heightFootData = [[NSArray alloc] initWithObjects:@"4", @"5", @"6", nil];
        heightInchData = [[NSArray alloc] initWithObjects:@"0",@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10",@"11", nil];
        
        _heightSelection = [[UIPickerView alloc ]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
        _height.backgroundColor = [UIColor whiteColor];
        _heightSelection.delegate = self;
        _heightSelection.dataSource = self;
        
        
        _height.inputView = _heightSelection;
        
    }
    
    if (textField == _shirtSize)
    {
        shirtData = [NSArray arrayWithObjects:@"Xtra Small",@"Small", @"Medium", @"Large", @"Xtra Large", nil];
        _shirtSizeSelection = [[UIPickerView alloc ]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
        _shirtSizeSelection.delegate = self;
        _shirtSizeSelection.dataSource = self;
        _shirtSizeSelection.backgroundColor = [UIColor whiteColor];
        _shirtSize.inputView = _shirtSizeSelection;
    }
    UIToolbar * bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _ethnicityPicker.frame.size.width, 44)];
    
    bar.translucent = YES;
    
    UIBarButtonItem * done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [bar setItems:[NSArray arrayWithObjects:flexibleSpace, flexibleSpace, done, nil]];
    textField.inputAccessoryView = bar;
}

-(void)done
{
    [self.view endEditing:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField == _zipCodeField)
    {
        _zipCodeField.text = textField.text;
        // currentUser[ZIP] = [NSNumber numberWithInteger:[textField.text integerValue]];
        zip = [NSNumber numberWithInteger:[textField.text integerValue]];
    }
    
    if (textField == _cityField)
    {
        [_statefield becomeFirstResponder];
    }
    
    if (textField == _secondaryLanguage)
    {
        [PFUser currentUser][SECONDARYLANGUAGE] = __primaryLanguage.text;
        [[PFUser currentUser] saveInBackground];
    }
    
    if (textField == _height)
    {
        NSInteger foot = [footText integerValue];
        NSInteger inch = [inchText integerValue];
        
        NSInteger inchValue = foot*12 + inch;
        
        NSNumber *theHeight = [NSNumber numberWithInteger:inchValue];
        userHeight = theHeight;
    }
    if (textField == _weight)
        
    {
        
        NSNumber *num = [NSNumber numberWithInteger:[_weight.text integerValue]];
        NSString *displayValue = [NSString stringWithFormat:@"%@ lbs",textField.text];
        _weight.text = displayValue;
        userWeight = num;
    }
    
    if (textField == _shirtSize)
    {
        [PFUser currentUser][SHIRTSIZE] = _shirtSize.text;
        [[PFUser currentUser] saveInBackground];
    }
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == _heightSelection)
    {
        return 2;
    }
    
    
    
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _ethnicityPicker)
    {
        return yearData.count;
    }
    
    if (pickerView == _statePicker)
    {
        return stateArray.count;
    }
    if (pickerView == _languagePicker)
    {
        return languages.count;
    }
    
    if (pickerView == _heightSelection)
    {
        switch (component)
        {
            case 0:
                return heightFootData.count;
                break;
                
            case 1:
                return heightInchData.count;
                
            default:
                break;
        }
    }
    
    if (pickerView == _weightSelection)
    {
        return weightData.count;
    }
    if (pickerView == _shirtSizeSelection)
    {
        return shirtData.count;
    }
    return 0;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    if (pickerView == _statePicker)
    {
        return  [stateArray objectAtIndex:row];
    }
    
    if (pickerView == _languagePicker)
    {
        return [languages objectAtIndex:row];
    }
    if (pickerView == _ethnicityPicker)
    {
        return [yearData objectAtIndex:row];
    }
    if (pickerView == _heightSelection)
    {
        NSString *footText;
        NSString *inchText;
        switch (component) {
            case 0:
                
                footText = [NSString stringWithFormat: @"%@ ft",[heightFootData objectAtIndex:row]];
                return footText;
                break;
                
            case 1:
                inchText = [NSString stringWithFormat:@"%@ in", [heightInchData objectAtIndex:row]];
                return inchText;
                break;
            default:
                break;
        }
    }
    
    if (pickerView == _weightSelection)
    {
        NSString *string = [NSString stringWithFormat:@"%@ lbs", [[weightData objectAtIndex:row] stringValue] ];
        
        return string;
        
        
    }
    
    if (pickerView == _shirtSizeSelection)
    {
        return [shirtData objectAtIndex:row];
    }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *stringForText;
    if (pickerView == _statePicker)
    {
        _statefield.text = [stateArray objectAtIndex:row];
    }
    
    if (pickerView == _languagePicker)
    {
        if (pickerView.tag == 0) {
            
            __primaryLanguage.text = [languages objectAtIndex:row];
            [PFUser currentUser][PRIMARYLANGUAGE] = [languages objectAtIndex:row];
            [[PFUser currentUser] saveInBackground];
        }
        else
        {
            _secondaryLanguage.text = [languages objectAtIndex:row];
            [PFUser currentUser][SECONDARYLANGUAGE] = [languages objectAtIndex:row];
            [[PFUser currentUser] saveInBackground];
        }
        
        
        
    }
    
    if (pickerView == _ethnicityPicker)
    {
        
        _ethnicity.text = [yearData objectAtIndex: row];
        [PFUser currentUser][ETHNICITY] = [yearData objectAtIndex: row];
        [[PFUser currentUser] saveInBackground];
        
        
    }
    
    if (pickerView == _heightSelection)
    {
        switch(component)
        {
            case 0:
                footText = [heightFootData objectAtIndex:row];
                
                break;
            case 1:
                inchText = [heightInchData objectAtIndex:row];
                break;
                
        }
        
        stringForText = [NSString stringWithFormat:@"%@ ft, %@ in", footText, inchText];
        
        _height.text = stringForText;
    }
    
    if (pickerView == _shirtSizeSelection)
    {
        _shirtSize.text = [shirtData objectAtIndex:row];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 2;
            break;
        case 5:
            return 1;
            break;
            
        default:
            break;
    }
    return 0;
}



- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    
    if (indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"JobTitle" bundle: nil];
            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"@JobTitle"];
            [self.navigationController showViewController:vc sender:self];
        }
    }
    
}


-(void)createProfile
{
    
    
    UIAlertController * alert=  [UIAlertController
                                 alertControllerWithTitle:@"SnapStaff"
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Agree"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             
                         }];
    UIAlertAction* terms = [UIAlertAction
                            actionWithTitle:@"View Terms of Use"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [alert dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 
                             }];
    
    
    [alert addAction:ok];
    [alert addAction:terms];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)getProfileImage{
    _profileImage.layer.cornerRadius = _profileImage.frame.size.height/2;;
    _profileImage.layer.masksToBounds = YES;
    _profileImage.image = [sharedUser.mySnapGigImages objectForKey:PROFILE1];
    
    _firstNameLabel.text =  [PFUser currentUser][FIRSTNAME];
}




- (void)keyboardWillHide:(NSNotification *)notification
{
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

-(void)profileInfo
{

}

-(void) saveUserInfo
{
    PFUser *user = [PFUser currentUser];

    user[CITY] = _cityField.text;
    user[STATE] = _statefield.text;
    user[ZIP] = zip;
    user[PRIMARYLANGUAGE] = __primaryLanguage.text;
    user[SECONDARYLANGUAGE] = _secondaryLanguage.text;
    user[ETHNICITY] = _ethnicity.text;
    user[HEIGHT] = userHeight;
    user[WEIGHT] = userWeight;
    user[SHIRTSIZE] = _shirtSize.text;
    user[INSTAGRAM] = _instagramName.text;
    user[TWITTER] = _twitterName.text;
    user[BIO] = _aboutMe.text;
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            [self dismissViewControllerAnimated:YES completion:^{
                [self loginSnapStaffUser];
                sharedSingleton.userActionType = PROFILECREATED;
                [[NSNotificationCenter defaultCenter]postNotificationName:SHOWAVAILABLE object:nil];
            }];
        } else {
            // There was a problem, check error.description
        }
    }];
}


-(void) loginSnapStaffUser
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"@TabBarController"];
    [self presentViewController:viewController animated:YES completion:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changePhotoButtonPressed:(id)sender {
}
- (IBAction)editProfileButtonPressed:(id)sender {
    
    
    BOOL isComplete = YES;
    NSString *message;
    //
    //        if (_firstNameTextField.text.length == 0) {
    //            isComplete = NO;
    //            message = @"First name missing.";
    //        }
    //        else if (_lastNameTextField.text.length == 0) {
    //            isComplete = NO;
    //            message = @"Last name missing.";
    //        }
    //        else if (_emailTextField.text.length == 0) {
    //            isComplete = NO;
    //            message = @"email incomplete.";
    //        }
    //        else if (_passwordField.text.length == 0) {
    //            isComplete = NO;
    //            message = @"Password missing.";
    //        }
    //        else if (_dateOfBirth.text.length == 0) {
    //            isComplete = NO;
    //            message = @"Date of birth missing.";
    //        }
    //        else if (gender == nil) {
    //            isComplete = NO;
    //            message = @"gender missing.";
    //        }
    //        else if (_addressLineOne.text.length == 0) {
    //            isComplete = NO;
    //            message = @"Address incomplete.";
    //        }
    //        else if (_cityField.text.length == 0) {
    //            isComplete = NO;
    //            message = @"city missing.";
    //        }
    //        else if (_statefield.text.length == 0) {
    //            isComplete = NO;
    //            message = @"state missing.";
    //        }
    //        else if (_zipCodeField.text.length == 0) {
    //            isComplete = NO;
    //            message = @"zip missing.";
    //        }
    
    if (isComplete)
    {
        [self saveUserInfo];
    }
    
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Information Required" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}
@end
