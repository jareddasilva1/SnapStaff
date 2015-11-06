//
//  ProfileInfoTVC.m
//  
//
//  Created by Rahiem Klugh on 10/14/15.
//
//

#import "ProfileInfoTVC.h"
#import "Constants.h"
#import "ProfileInfoTVCell1.h"
#import "InstagigUser.h"

@interface ProfileInfoTVC ()

@end

@implementation ProfileInfoTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
      self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];  //Remove the extra cells
    
    self.title = @"Profile Info";
    
    self.navigationController.navigationBar.barTintColor = INSTABLUE;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName :[UIColor whiteColor]};
    
    [self getUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getUserInfo
{
    PFUser *user = [PFUser currentUser];

    
    if (user[SECONDARYLANGUAGE] != nil) {
          _languages.text = [NSString stringWithFormat:@"%@, %@", user[PRIMARYLANGUAGE], user[SECONDARYLANGUAGE]];
    }
    else
    {
         _languages.text = [NSString stringWithFormat:@"%@", user[PRIMARYLANGUAGE]];
    }
    _languages.text = [NSString stringWithFormat:@"%@", user[PRIMARYLANGUAGE]];
    _ethnicity.text = [NSString stringWithFormat:@"%@",user[ETHNICITY]];
//    _aboutMe.text = [NSString stringWithFormat:@"%@", user [BIO]];
    _nameLabel.text = [NSString stringWithFormat:@"%@", user[FIRSTNAME]];
    _cityState.text = [NSString stringWithFormat:@"%@, %@", user[CITY], user[STATE]];
    
    NSNumber *height = user[HEIGHT];
   
    _height.text =  [NSString stringWithFormat:@"%@",  height];
    _weight.text =  [NSString stringWithFormat:@"%@ lbs", user[WEIGHT]];
    
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
    return 1;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString* CellIdentifier = @"infoCell1";
//    ProfileInfoTVCell1* brandCell = (ProfileInfoTVCell1*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    
//    // Configure the cell...
//    if (brandCell == nil) {
//        brandCell = [[ProfileInfoTVCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    brandCell.contentView.frame = brandCell.bounds;
//    brandCell.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
//    
////    PFObject *object = [shared_data1.brandNames objectAtIndex:indexPath.row];
////    
////    brandCell.brandName.text = object[BRANDNAME];
////    brandCell.brandImage.image = [shared_data1 fetchBrandImage:object[BRANDNAME]];
//    
//    return brandCell;
//}


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
