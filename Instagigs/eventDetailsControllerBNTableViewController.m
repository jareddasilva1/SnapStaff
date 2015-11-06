//
//  eventDetailsControllerBNTableViewController.m
//  Instagigs
//
//  Created by Jerry Phillips on 8/28/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "eventDetailsControllerBNTableViewController.h"
#import "eventTextField.h"
#import "noteTableViewCell.h"
#import "signInButtonCell.h"
#import "Constants.h"
#import "InstagigSingelton.h"



@interface eventDetailsControllerBNTableViewController ()

@end

InstagigSingelton *sharedDATA;
BOOL eventDate;
BOOL startTime;
BOOL endTime;
UITextField *currentField;
NSArray *eventTypes;

@implementation eventDetailsControllerBNTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sharedDATA = [InstagigSingelton instagGigObject];
    
    if (sharedDATA.detailsType == CREATEEVENT) {
        sharedDATA.currentEvent = nil;
        sharedDATA.currentEvent= [[eventObject alloc]init];
    }
    
    self.tableView.estimatedRowHeight = 150;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
   // self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTintColor:INSTABLUE];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName :INSTABLUE};
    self.title = @"Create Event";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(done) name:DISMISSKEYBOARD object:nil];
}
#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

-(void)done
{
    [self.view endEditing:YES];
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"Brand:";
            break;
            
        case 1:
            return @"Venue Name:";
            
            break;
            
        case 2:
            return @"Venue Address";
            
            break;
            
        case 3:
            return @"Point of Contact";
            break;
            
        case 4:
            return @"Event Type";
            break;
            
        case 5:
            return @"Number of Talent:";
            break;
            
        case 6:
            return @"Event Date:";
            break;
            
        case 7:
            return @"Start Time:";
            break;
            
        case 8:
            return @"End Time:";
            
            break;
            
        case 9:
            return @"Notes:";
            break;
            
            
            
        default:
            return nil;
            break;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section)
    {
            
        case 3:
            return 2;
            
            break;
            
        case 9:
            if (_staffedPeopleToNotify != nil)
            {
                return 3;
            }
            else
            {
                return 2;
            }
            break;
            
        default:
            return 1;
            break;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor whiteColor];
    header.backgroundView.backgroundColor = INSTABLUE;
    header.textLabel.font = [UIFont fontWithName:@"OpenSansRegular" size:12.0];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentLeft;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    eventTextField *cell = [tableView dequeueReusableCellWithIdentifier:@"eventTextField"];
    noteTableViewCell *notesCell = [tableView dequeueReusableCellWithIdentifier:@"noteTableViewCell"];
    signInButtonCell *signInCell = [tableView dequeueReusableCellWithIdentifier:@"signInButtonCell"];
    
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"eventTextField" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (eventTextField *) currentObject;
                break;
            }
        }
    }
    
    if (notesCell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"noteTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                notesCell =  (noteTableViewCell *) currentObject;
                break;
            }
        }
    }
    
    if (signInCell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"signInButtonCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                signInCell =  (signInButtonCell *) currentObject;
                break;
            }
        }
    }
    cell.eventTextfield.delegate = self;
    
    switch (indexPath.section)
    {
        case 0:
            cell.eventTextfield.tag = 0;
            cell.eventTextfield.placeholder = @"Brand Name";
            if (sharedDATA.currentEvent.parseEventObject[BRANDNAME] != nil )
            {
                cell.eventTextfield.text = sharedDATA.currentEvent.parseEventObject[BRANDNAME];
            }
            return cell;
            break;
            
        case 1:
            
            cell.tag = 6;
            cell.eventTextfield.tag = 12;
            cell.eventTextfield.placeholder = @"Venue Name";
            cell.eventTextfield.text = sharedDATA.currentEvent.parseEventObject[VENUENAME];
            return cell;
            
            
            break;
            
        case 2:
            
            
            cell.eventTextfield.tag = 7;
            cell.eventTextfield.placeholder = @"Venue Address";
            cell.eventTextfield.text = sharedDATA.currentEvent.parseEventObject[EVENTADDRESS];
            return cell;
            break;
            
        case 3:
            if (indexPath.row == 0)
            {
                cell.eventTextfield.tag = 9;
                cell.eventTextfield.placeholder = @"Contact Person";
            }
            else
            {
                cell.eventTextfield.tag = 10;
                cell.eventTextfield.placeholder = @"Contact Phone Number";
            }
            
            return cell;
            break;
            
            
        case 4:
            cell.eventTextfield.tag = 8;
            cell.eventTextfield.placeholder = @"Event Type";
            if(sharedDATA.currentEvent.parseEventObject[EVENTTYPE]!= nil)
            {
                cell.eventTextfield.text = sharedDATA.currentEvent.parseEventObject[EVENTTYPE]  ;
            }
            return cell;
            break;
            
        case 5:
            cell.eventTextfield.tag = 4;
            cell.eventTextfield.placeholder = @"Number of Talent:";
            if(sharedDATA.currentEvent.parseEventObject[NUMBEROFTALENT]!= nil)
            {
                cell.eventTextfield.text = [sharedDATA.currentEvent.parseEventObject[NUMBEROFTALENT] stringValue] ;
            }
            return cell;
            break;
            
        case 6:
            cell.eventTextfield.tag = 1;
               cell.eventTextfield.placeholder = @"Date";
            cell.eventTextfield.text= [sharedDATA dateFormatter:sharedDATA.currentEvent.parseEventObject[EVENTDATE] justTime:NO numberic:NO];
            return cell;
            break;
            
        case 7:
            
            cell.eventTextfield.tag = 2;
            cell.eventTextfield.placeholder = @"Start Time";
            if (sharedDATA.currentEvent.parseEventObject[STARTTIME] != nil)
            {
                cell.eventTextfield.text = [sharedDATA dateFormatter:sharedDATA.currentEvent.parseEventObject[STARTTIME] justTime:YES numberic:NO];
            }
            return cell;
            
            break;
            
        case 8:
            cell.eventTextfield.tag = 3;
            cell.eventTextfield.placeholder = @"End Time";
            if (sharedDATA.currentEvent.parseEventObject[EVENTDATE] != nil)
            {
                cell.eventTextfield.text = [sharedDATA dateFormatter:sharedDATA.currentEvent.parseEventObject[ENDTIME] justTime:YES numberic:NO];
            }
            return cell;
            break;
            
        case 9:
            if (indexPath.row == 0)
            {
                
                notesCell.notes.tag = 5;
                notesCell.notes.delegate = self;
                notesCell.notes.text = @"";
                
                return notesCell;
                
                
            }
            if(_staffedPeopleToNotify != nil)
            {
                if (indexPath.row == 1)
                {
                    signInCell.label.text = @"DELETE";
                    
                    signInCell.backgroundColor = [UIColor redColor];
                    
                    return signInCell;
                }
                else
                {
                    signInCell.label.text = @"Next";
                    
                    signInCell.backgroundColor = INSTABLUE;
                    
                    return signInCell;
                }
            }
            else
            {
                signInCell.label.text = @"Next";
                
                signInCell.backgroundColor = INSTABLUE;
                
                return signInCell;
            }
            break;
            
            
        default:
            return nil;
            break;
    }
    
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 9 && _staffedPeopleToNotify != nil)
    {
        if (indexPath.row == 1)
        {
            [self deleteThisEvent];
        }
        if (indexPath.row == 2)
        {
            [self.view endEditing:YES];
            
            if ( sharedDATA.currentEvent.parseEventObject[STARTTIME] != nil
                && sharedDATA.currentEvent.parseEventObject[ENDTIME] != nil
                && sharedDATA.currentEvent.parseEventObject[BRANDNAME] != nil
                && sharedDATA.currentEvent.parseEventObject[VENUENAME] != nil
                && sharedDATA.currentEvent.parseEventObject[EVENTDATE] != nil
                && sharedDATA.currentEvent.parseEventObject[EVENTADDRESS] != nil
                && sharedDATA.currentEvent.parseEventObject[NUMBEROFTALENT] != nil
                && sharedDATA.currentEvent.parseEventObject[CONTACTPHONE] != nil
                && sharedDATA.currentEvent.parseEventObject[CONTACTPERSON] != nil)
                
            {
                [self showEventDetails];
                
            }
        }
    }
    
    if(indexPath.section == 9 && _staffedPeopleToNotify == nil)
    {
        if (indexPath.row == 1)
        {
            [self.view endEditing:YES];
            
            if ( sharedDATA.currentEvent.parseEventObject[STARTTIME] != nil
                && sharedDATA.currentEvent.parseEventObject[ENDTIME] != nil
                && sharedDATA.currentEvent.parseEventObject[BRANDNAME] != nil
//                && sharedDATA.currentEvent.parseEventObject[VENUENAME] != nil
                && sharedDATA.currentEvent.parseEventObject[EVENTDATE] != nil
//                && sharedDATA.currentEvent.parseEventObject[EVENTADDRESS] != nil
                && sharedDATA.currentEvent.parseEventObject[NUMBEROFTALENT] != nil
                && sharedDATA.currentEvent.parseEventObject[CONTACTPHONE] != nil
                && sharedDATA.currentEvent.parseEventObject[CONTACTPERSON] != nil)
                
            {
                // [self performSegueWithIdentifier:@"confirmEvent" sender:self];
               // [sharedDATA saveScheduledObject];
                [self showEventDetails];
            }
        }
    }
}



-(void) showEventDetails
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"EventDetails" bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"@EventDetails"];
//    UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self.navigationController showViewController:vc sender:self];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag)
    {
        case 0:
            return sharedDATA.brandNames.count;
            break;
            
        case 1:
            return eventTypes.count;
            break;
            
        default:
            return 0;
            break;
    }
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    eventTypes = [NSArray arrayWithObjects:@"On-Premise",@"Off-Premise",@"Special Event", @"Social",  nil];
    PFObject * titleText;
    switch (pickerView.tag)
    {
        case 0:
            titleText = [sharedDATA.brandNames objectAtIndex:row];
            return titleText[BRANDNAME];
            break;
        case 1:
            return [eventTypes objectAtIndex:row];
        default:
            return nil;
            break;
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    PFObject * selected;
    switch (pickerView.tag)
    {
        case 0:
            selected = [sharedDATA.brandNames objectAtIndex:row];
            currentField.text = selected[BRANDNAME];
            sharedDATA.currentEvent.parseEventObject[BRANDNAME] = selected[BRANDNAME];
            
            break;
            
        case 1:
            currentField.text = [eventTypes objectAtIndex:row];
            sharedDATA.currentEvent.parseEventObject[EVENTTYPE] = [eventTypes objectAtIndex:row];
            break;
            
        default:
            break;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
            
        case 4:
            sharedDATA.currentEvent.parseEventObject[NUMBEROFTALENT] = [NSNumber numberWithInteger: [textField.text integerValue]];
            sharedDATA.currentEvent.parseEventObject[SPOTSREMAINING] = [NSNumber numberWithInteger:[textField.text integerValue]];
            break;
            
        case 6:
            sharedDATA.currentEvent.parseEventObject[VENUENAME] = textField.text;
            break;
            
        case 7:
            sharedDATA.currentEvent.parseEventObject[EVENTADDRESS] = textField.text;
            break;
        case 9:
            
            sharedDATA.currentEvent.parseEventObject[CONTACTPERSON] = textField.text;
            
            break;
            
        case 10:
            sharedDATA.currentEvent.parseEventObject[CONTACTPHONE] = textField.text;
            
            break;

        default:
            break;
    }
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    picker.backgroundColor = [UIColor whiteColor];
    
    UIPickerView *textPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
    textPicker.backgroundColor = [UIColor whiteColor];
    textPicker.delegate = self;
    picker.frame = CGRectMake(0, 200, self.view.frame.size.width, 200);
    [picker addTarget:self action:@selector(pickerValueChange:) forControlEvents:UIControlEventValueChanged];
    textField.inputAccessoryView = [sharedDATA doneToolBar:self.view];
    switch (textField.tag)
    {
        case 0:
            textPicker.tag = 0;
            textField.inputView = textPicker;
            textField.backgroundColor = [UIColor whiteColor];
            currentField = textField;
        // [self performSegueWithIdentifier:@"detailForEvent" sender:self];
            break;
            
        case 1:
            picker.datePickerMode = UIDatePickerModeDate;
            textField.inputView = picker;
            textField.backgroundColor = [UIColor whiteColor];
            currentField = textField;
            eventDate = YES;
            startTime = NO;
            endTime = NO;
            break;
        case 2:
            picker.datePickerMode = UIDatePickerModeTime;
            picker.minuteInterval = 15;
            textField.inputView = picker;
            textField.backgroundColor = [UIColor whiteColor];
            currentField = textField;
            startTime = YES;
            eventDate = NO;
            endTime = NO;
            break;
        case 3:
            picker.datePickerMode = UIDatePickerModeTime;
            textField.inputView = picker;
            picker.minuteInterval = 15;
            currentField = textField;
            endTime = YES;
            startTime = NO;
            eventDate = NO;
            break;
            
        case 4:
            [textField setKeyboardType:UIKeyboardTypeNumberPad];
            break;
            
        case 8:
            textPicker.tag = 1;
            textField.inputView = textPicker;
            currentField = textField;
            break;
        case 10:
            textField.keyboardType = UIKeyboardTypePhonePad;
            break;
            
        case 12:
            [self performSegueWithIdentifier:@"detailForEvent" sender:self];
            break;
            
        default:
            break;
    }
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.inputAccessoryView = [sharedDATA doneToolBar:self.view];
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    sharedDATA.currentEvent.parseEventObject[NOTES] = textView.text;
}

-(void)pickerValueChange:(UIDatePicker*)picker
{
    if (eventDate == YES)
    {
        eventDate = NO;
        currentField.text = [sharedDATA dateFormatter:picker.date justTime:NO numberic:NO];
        sharedDATA.currentEvent.parseEventObject[EVENTDATE] = picker.date;
        
    }
    if (startTime == YES)
    {
        
        currentField.text = [sharedDATA dateFormatter:picker.date justTime:YES numberic:NO];
        sharedDATA.currentEvent.parseEventObject[STARTTIME] = picker.date;
    }
    if (endTime == YES)
    {
        
        currentField.text = [sharedDATA dateFormatter:picker.date justTime:YES numberic:NO];
        sharedDATA.currentEvent.parseEventObject[ENDTIME] = picker.date;
    }
}



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

- (IBAction)killView:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//method to delete this event
-(void)deleteThisEvent
{
    //prompt user if they are sure they want to kill the event
    UIAlertController *deleteEvent = [UIAlertController alertControllerWithTitle:@"ARE YOU SURE?" message:@"You are about to delete this event. If you prceed it can not be undone." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"DELETE" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
                             {
                                 [  sharedDATA.currentEvent.parseEventObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullabler)
                                  {
                                      //re-populate the scheduled events dictionary
                                      [sharedDATA queryEvents];
                                      
                                      // these are navigation views but they are behaing like modal's? iOS 9 issue? had to call presentingView 3 times to kill the view on creation
                                      [[[self presentingViewController]presentingViewController] dismissViewControllerAnimated:YES completion:nil];
                                      
                                      
                                      
                                  }];
                                 
                             }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [deleteEvent addAction:delete];
    [deleteEvent addAction:cancel];
    
    [self presentViewController:deleteEvent animated:YES completion:nil];
    
}
@end
