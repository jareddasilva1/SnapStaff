//
//  ProfileInfoTVC.h
//  
//
//  Created by Rahiem Klugh on 10/14/15.
//
//

#import <UIKit/UIKit.h>

@interface ProfileInfoTVC : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityState;
@property (strong, nonatomic) IBOutlet UILabel *height;
@property (strong, nonatomic) IBOutlet UILabel *weight;
@property (strong, nonatomic) IBOutlet UILabel *languages;
@property (strong, nonatomic) IBOutlet UILabel *ethnicity;
@property (strong, nonatomic) IBOutlet UITextField *aboutMe;

@end
