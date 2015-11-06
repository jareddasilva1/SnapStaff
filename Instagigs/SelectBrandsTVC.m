//
//  SelectBrandsTVC.m
//  Instagigs
//
//  Created by Rahiem Klugh on 10/9/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "SelectBrandsTVC.h"
#import "InstagigSingelton.h"
#import "Constants.h"
#import "BrandsTableViewCell.h"

@interface SelectBrandsTVC ()

@end

@implementation SelectBrandsTVC
{
    InstagigSingelton *shared_data1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    shared_data1 =[InstagigSingelton instagGigObject];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    self.title = @"Select Brand";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    return shared_data1.brandNames.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"brandCell";
    BrandsTableViewCell* brandCell = (BrandsTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    // Configure the cell...
    if (brandCell == nil) {
        brandCell = [[BrandsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    brandCell.contentView.frame = brandCell.bounds;
    brandCell.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;

    PFObject *object = [shared_data1.brandNames objectAtIndex:indexPath.row];
   
    brandCell.brandName.text = object[BRANDNAME];
    brandCell.brandImage.image = [shared_data1 fetchBrandImage:object[BRANDNAME]];

    return brandCell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
     PFObject *object = [shared_data1.brandNames objectAtIndex:indexPath.row];
    indexPath = [self.tableView indexPathForSelectedRow];
    NSString *brandName = object[BRANDNAME];
    
    shared_data1.currentEvent.parseEventObject[BRANDNAME] = brandName;
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEBRANDTEXT object:nil];
    
    [self performSelector:@selector(removeSelf) withObject:nil afterDelay:0.2];

}

- (void)removeSelf
{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
