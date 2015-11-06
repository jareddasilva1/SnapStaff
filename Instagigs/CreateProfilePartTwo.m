//
//  CreateProfilePartTwo.m
//  Instagigs
//
//  Created by Jerry Phillips on 8/20/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "CreateProfilePartTwo.h"
#import <Parse/Parse.h>
#import "Constants.h"
#import "InstagigSingelton.h"

@interface CreateProfilePartTwo ()

@end

NSArray *yearData;

NSArray *heightFootData;

NSArray *heightInchData;



NSMutableArray * weightData;

NSArray *shirtData;
NSString *footText;
NSString *inchText;
NSArray * languages;
NSString *validDriversLicense;
NSString *tattoos;
NSNumber *userHeight;
NSNumber *userWeight;

InstagigSingelton* sharedData;

@implementation CreateProfilePartTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    
    inchText = @"0";
    
    languages = [[NSArray alloc]initWithObjects:@"English", @"Arabic", @"Chinese", @"French", @"German" , @"Italian", @"Korean", @"Russian", @"Spanish", @"Tagalong", @"Vietnamese", nil];
    
    //Set the default primary language to english
    __primaryLanguage.text = [languages objectAtIndex:0];
    
    _licenseYes.tag = 0;
    [_licenceNo addTarget:self action:@selector(doYouHave:) forControlEvents:UIControlEventTouchUpInside];
    
    _licenceNo.tag = 1;
     [_licenseYes addTarget:self action:@selector(doYouHave:) forControlEvents:UIControlEventTouchUpInside];
   
    _tatoosYes.tag = 4;
     [_tatoosNo addTarget:self action:@selector(doYouHave:) forControlEvents:UIControlEventTouchUpInside];
    
    _tatoosNo.tag = 5;
    
     [_tatoosYes addTarget:self action:@selector(doYouHave:) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.backgroundColor = [UIColor whiteColor];
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

-(void)done
{
    [self.view endEditing:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
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

-(void)doYouHave:(UIButton *)sender
{
    sharedData = [[InstagigSingelton alloc] init];
    switch (sender.tag)
    {
        case 0:
            [sharedData buttonState:sender :YES];
            [sharedData buttonState:_licenceNo :NO];
            validDriversLicense = @"YES";
            break;
            
        case 1:
            [sharedData buttonState:sender :YES];
            [sharedData buttonState:_licenseYes :NO];
            validDriversLicense = @"NO";
            break;
            
   
            case 4:
            [sharedData buttonState:sender :YES];
            [sharedData buttonState:_tatoosNo :NO];
            tattoos = @"YES";
            break;
            
            case 5:
            [sharedData buttonState:sender :YES];
            [sharedData buttonState:_tatoosYes :NO];
            tattoos = @"NO";
            break;
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 8)
    {
        [self.view endEditing:YES];
        
        BOOL isComplete = YES;
        NSString *message;
        
        if (__primaryLanguage.text.length == 0) {
            isComplete = NO;
            message = @"Primary language missing.";
        }
        else if (_ethnicity.text.length == 0) {
            isComplete = NO;
            message = @"Ethnicity missing.";
        }
        else if (validDriversLicense == nil) {
            isComplete = NO;
            message = @"Valid drivers license info missing.";
        }
        else if (_height.text.length == 0) {
            isComplete = NO;
            message = @"Height missing.";
        }
        else if (_weight.text.length == 0) {
            isComplete = NO;
            message = @"Weight missing.";
        }
        else if (_shirtSize.text.length == 0) {
            isComplete = NO;
            message = @"Shirt size missing.";
        }
        else if (tattoos == nil) {
            isComplete = NO;
            message = @"Tattoo info missing.";
        }
        
        if (isComplete)
        {
            [self saveUserInfo];
            [self performSegueWithIdentifier:@"lastStep" sender:self];
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

-(void) saveUserInfo
{
    //Save all user data
    _userInfoDict = [[NSMutableDictionary alloc] init];
    
    [_userInfoDict setObject:__primaryLanguage.text forKey:@"primarylanguage"];
    [_userInfoDict setObject:_secondaryLanguage.text forKey:@"secondarylanguage"];
    [_userInfoDict setObject:_ethnicity.text forKey:@"ethnicity"];
    [_userInfoDict setObject:userHeight forKey:@"height"];
    [_userInfoDict setObject:userWeight forKey:@"weight"];
    [_userInfoDict setObject:_shirtSize.text forKey:@"shirtzise"];
    
    if ([validDriversLicense isEqualToString:@"YES"]) {
       [_userInfoDict setObject:@YES forKey:@"validlicense"];
    }
    else
    {
       [_userInfoDict setObject:@NO forKey:@"validlicense"];
    }
    
    if ([tattoos isEqualToString:@"YES"]) {
        [_userInfoDict setObject:@YES forKey:@"tattoos"];
    }
    else
    {
        [_userInfoDict setObject:@NO forKey:@"tattoos"];
    }
   
    
    [[NSUserDefaults standardUserDefaults] setObject:_userInfoDict forKey:@"userStepTwo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}







@end
