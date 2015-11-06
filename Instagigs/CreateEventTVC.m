//
//  CreateEventTVC.m
//  Instagigs
//
//  Created by Rahiem Klugh on 10/8/15.
//  Copyright © 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "CreateEventTVC.h"
#import "InstagigSingelton.h"
#import "Constants.h"

@interface CreateEventTVC ()

@end

@implementation CreateEventTVC
{
    NSArray *eventTypes;
    InstagigSingelton *sharedDATA2;
    NSNumber *payRate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    sharedDATA2 = [InstagigSingelton instagGigObject];
    
    _dateField.delegate = self;
    _startTimeField.delegate = self;
    _endTimeField.delegate = self;
    _eventTypeField.delegate = self;
    _contactNameField.delegate = self;
    _contactNumberField.delegate = self;
    _talentNumberField.delegate = self;
    _payRateField.delegate = self;
    
    if (sharedDATA2.detailsType == CREATEEVENT)
    {
        sharedDATA2.currentEvent = nil;
        sharedDATA2.currentEvent= [[eventObject alloc]init];
        self.title = @"Create Event";
        
        _brandTextLabel.hidden = YES;
        _brandImage.hidden = YES;
        _brandLabel.hidden = NO;
        
        _venueName.hidden = YES;
        _venueLocation.hidden = YES;
        _venueNamePlaceholder.hidden = NO;
    }
    else
    {
        self.title = @"Edit Event";
        
        [self updateBrandText];
        [self updateVenueText];
        
        _dateField.text = [sharedDATA2 dateFormatter:sharedDATA2.currentEvent.parseEventObject[EVENTDATE] justTime:NO numberic:NO];
        
        _startTimeField.text = [sharedDATA2 dateFormatter:sharedDATA2.currentEvent.parseEventObject[STARTTIME]justTime:YES numberic:NO];
        
        _endTimeField.text = [sharedDATA2 dateFormatter:sharedDATA2.currentEvent.parseEventObject[ENDTIME] justTime:YES numberic:NO];
        
        _brandTextLabel.text = sharedDATA2.currentEvent.parseEventObject[BRANDNAME];
        
        _eventTypeField.text = sharedDATA2.currentEvent.parseEventObject[EVENTTYPE];
        
        _contactNameField.text = sharedDATA2.currentEvent.parseEventObject[CONTACTPERSON];
        
        _contactNumberField.text = sharedDATA2.currentEvent.parseEventObject[CONTACTPHONE];
        
        _talentNumberField.text = [sharedDATA2.currentEvent.parseEventObject[NUMBEROFTALENT] stringValue];
        
        _notesField.text = sharedDATA2.currentEvent.parseEventObject[NOTES];
        
        _jobTitleLabel.text = sharedDATA2.currentEvent.parseEventObject[JOBTITLE];
        
       
        _payRateField.text =  [NSString stringWithFormat:@"$%@/hr", sharedDATA2.currentEvent.parseEventObject[PAYRATE]];
        
        [_nextButton setTitle:@"COMPLETE EDIT" forState:UIControlStateNormal];
    }
    
    
    
    
    UIBarButtonItem * edit = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEvent)];
    self.navigationItem.rightBarButtonItem = edit;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateVenueText) name:UPDATEVENUETEXT object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateBrandText) name:UPDATEBRANDTEXT object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelEvent) name:NEWEVENTCREATED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelEvent) name:EVENTEDITED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelEvent) name:EVENTDELETED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateJobText) name:UPDATEJOBTEXT object:nil];
}

-(void)cancelEvent
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (sharedDATA2.detailsType)
    {
        case CREATEEVENT:
            return 5;
            break;
        case EDITEVENT:
            return 6;
            break;
        default:
            return 4;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 3;
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


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIPickerView *textPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
    textPicker.backgroundColor = [UIColor whiteColor];
    textPicker.delegate = self;
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
    [_datePicker addTarget:self action:@selector(pickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    _datePicker.backgroundColor = [UIColor whiteColor];
    UIToolbar * bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _datePicker.frame.size.width, 44)];
    bar.translucent = YES;
    UIBarButtonItem * done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(hidePicker)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [bar setItems:[NSArray arrayWithObjects:flexibleSpace, flexibleSpace, done, nil]];
   
    
    switch (textField.tag)  //Tags are all set in storyboards textfield
    {
        case 1: //Brand
            
            break;
        case 2:  //Venue name and location

            break;
        case 3:  //Date
            [_datePicker setDatePickerMode:UIDatePickerModeDate];
            _datePicker.tag = 3;
            _dateField.inputView = _datePicker;
             textField.inputAccessoryView = bar;
            break;
        case 4: //Start time
            [_datePicker setDatePickerMode:UIDatePickerModeTime];
            _datePicker.tag = 4;
            _startTimeField.inputView = _datePicker;
            textField.inputAccessoryView = bar;
            break;
        case 5: //End time
            [_datePicker setDatePickerMode:UIDatePickerModeTime];
            _datePicker.tag = 5;
            _endTimeField.inputView = _datePicker;
            textField.inputAccessoryView = bar;
            break;
        case 6: //Event type
            _eventTypeField.inputView = textPicker;
             textField.inputAccessoryView = bar;
             textPicker.tag = 6;
            break;
        case 7: //Contact Name
            //Regular text field
            
            break;
        case 8: //Contact Number
            _contactNumberField.keyboardType = UIKeyboardTypePhonePad;
            break;
        case 9: //Number of talent
            _talentNumberField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 10: // Pay Rate
            //Regular text field
            break;

        case 11: // Notes
               //Regular text field
            break;
        default:
            break;
    }
    
   
    
}

-(void) hidePicker
{
    [self.view endEditing:YES];

}
-(void)pickerValueChanged:(UIDatePicker *)datePicker
{
    if (datePicker.tag == 3)
    {
        _dateField.text = [sharedDATA2 dateFormatter:datePicker.date justTime:NO numberic:NO];
        sharedDATA2.currentEvent.parseEventObject[EVENTDATE] = datePicker.date;
        
    }
    if (datePicker.tag == 4)
    {
        
        _startTimeField.text = [sharedDATA2 dateFormatter:datePicker.date justTime:YES numberic:NO];
          sharedDATA2.currentEvent.parseEventObject[STARTTIME] = datePicker.date;
    }
    if (datePicker.tag == 5)
    {
        
        _endTimeField.text = [sharedDATA2 dateFormatter:datePicker.date justTime:YES numberic:NO];
         sharedDATA2.currentEvent.parseEventObject[ENDTIME] = datePicker.date;
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    eventTypes = [NSArray arrayWithObjects:@"Buy Back",@"On-Premise",@"Off-Premise",@"Merchandise", @"Pick up / Drop off",@"Special Event", @"Social",  nil];
    if (pickerView.tag == 6)
    {
        return eventTypes.count;
    }
    else
    {
        return 0;
    }

}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 6)
    {
        return [eventTypes objectAtIndex:row];
    }
    else
    {
        return 0;
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 6)
    {
        _eventTypeField.text = [eventTypes objectAtIndex:row];
    }

}

-(void)updateVenueText
{
    _venueName.hidden = NO;
    _venueLocation.hidden = NO;
    _venueNamePlaceholder.hidden = YES;
    
    _venueName.text = sharedDATA2.currentEvent.parseEventObject[VENUENAME];
    _venueLocation.text =  sharedDATA2.currentEvent.parseEventObject[EVENTADDRESS];
}

-(void)updateBrandText
{
    NSString *brandName =sharedDATA2.currentEvent.parseEventObject[BRANDNAME];
    _brandTextLabel.hidden = NO;
    _brandImage.hidden = NO;
    _brandLabel.hidden = YES;
    _brandTextLabel.text = brandName ;
    _brandImage.image = [sharedDATA2 fetchBrandImage:brandName];
}

-(void)updateJobText
{
    NSString *job =sharedDATA2.currentEvent.parseEventObject[JOBTITLE];
    _jobTitleLabel.text = job ;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SelectBrand" bundle: nil];
            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"@SelectBrand"];
            [self.navigationController showViewController:vc sender:self];
        }
        else
        {
            [self performSegueWithIdentifier:@"searchLocation" sender:self];
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"JobTitle" bundle: nil];
            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"@JobTitle"];
            [self.navigationController showViewController:vc sender:self];
        }
    }
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{

    if (textField == _payRateField)
        
    {
        
        NSNumber *num = [NSNumber numberWithInteger:[_payRateField.text integerValue]];
        NSString *displayValue = [NSString stringWithFormat:@"$%@/hr",textField.text];
        _payRateField.text = displayValue;
        payRate = num;
    }
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

- (IBAction)nextButtonPressed:(id)sender
{
    [self verifyEventInput];
}

- (IBAction)deleteButtonPressed:(id)sender
{
    //Delete Event
    
    UIAlertController * alert=  [UIAlertController
                                 alertControllerWithTitle:@"Delete Event"
                                 message:@"Are you sure you want to delete this event?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Yes"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [sharedDATA2 deleteEventInParse];
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showEditCompleteAlert
{
    //Edit Event
    
    UIAlertController * alert=  [UIAlertController
                                 alertControllerWithTitle:@"Complete Edit"
                                 message:@"Are you sure you want to edit this event?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Yes"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [sharedDATA2 editEventInParse];
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) verifyEventInput
{
    [self.view endEditing:YES];

        BOOL isComplete = YES;
        NSString *message;
        
        if ([_brandLabel.text isEqualToString:@"Brand"] && [_brandTextLabel.text isEqualToString:@"Brand Name"]) {
            isComplete = NO;
            message = @"Brand missing.";
        }
        else if ([_venueNamePlaceholder.text isEqualToString:@"Venue name and location"] && [_venueName.text isEqualToString:@"Venue Name"]) {
            isComplete = NO;
            message = @"Venue missing.";
        }
        else if (_dateField.text.length == 0) {
            isComplete = NO;
            message = @"Event date missing.";
        }
        else if (_startTimeField.text.length == 0) {
            isComplete = NO;
            message = @"Start Time missing.";
        }
        else if (_endTimeField.text.length == 0) {
            isComplete = NO;
            message = @"End time missing.";
        }
        else if (_eventTypeField.text.length == 0) {
            isComplete = NO;
            message = @"Event type missing.";
        }
        else if (_contactNameField.text.length == 0) {
            isComplete = NO;
            message = @"Contact name missing.";
        }
        else if (_contactNumberField.text.length == 0) {
            isComplete = NO;
            message = @"Contact number missing.";
        }
        else if (_talentNumberField.text.length == 0) {
            isComplete = NO;
            message = @"Talent number missing.";
        }
        
        if (isComplete)
        {
            [self holdEventInfo];
            
            switch (sharedDATA2.detailsType) {
                case CREATEEVENT:
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"EventDetails" bundle: nil];
                    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"@EventDetails"];
                    [self.navigationController showViewController:vc sender:self];
                    break;
                }
                case EDITEVENT:
                    //Update event
                    [self showEditCompleteAlert];
                    break;
                    
                default:
                    break;
            }
 
        }
        
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Information Required" message:message preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    
}

-(void) holdEventInfo
{
    sharedDATA2.currentEvent.parseEventObject[BRANDNAME] =  _brandTextLabel.text;
    sharedDATA2.currentEvent.parseEventObject[EVENTTYPE] = _eventTypeField.text;
    sharedDATA2.currentEvent.parseEventObject[NUMBEROFTALENT] = [NSNumber numberWithInteger: [_talentNumberField.text integerValue]];
    sharedDATA2.currentEvent.parseEventObject[SPOTSREMAINING] = [NSNumber numberWithInteger:[_talentNumberField.text integerValue]];
    sharedDATA2.currentEvent.parseEventObject[VENUENAME] = _venueName.text;
    sharedDATA2.currentEvent.parseEventObject[EVENTADDRESS] = _venueLocation.text;
    sharedDATA2.currentEvent.parseEventObject[CONTACTPERSON] = _contactNameField.text;
    sharedDATA2.currentEvent.parseEventObject[CONTACTPHONE] = _contactNumberField.text;
    sharedDATA2.currentEvent.parseEventObject[NOTES] = _notesField.text;
    sharedDATA2.currentEvent.parseEventObject[JOBTITLE] = _jobTitleLabel.text;
    
    NSString *stringWithoutSpaces = [_payRateField.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
    NSString *stringWithoutSpaces2 = [stringWithoutSpaces stringByReplacingOccurrencesOfString:@"/hr" withString:@""];
    
    sharedDATA2.currentEvent.parseEventObject[PAYRATE] =  [NSNumber numberWithInteger:[stringWithoutSpaces2 integerValue]];
    NSLog(@"PayRate: %@",   sharedDATA2.currentEvent.parseEventObject[PAYRATE]);
}

@end
