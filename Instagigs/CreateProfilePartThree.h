//
//  CreateProfilePartThree.h
//  Instagigs
//
//  Created by Jerry Phillips on 8/20/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateProfilePartThree : UITableViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageOne;

@property (strong, nonatomic) IBOutlet UIImageView *imageTwo;
@property (strong, nonatomic) IBOutlet UIButton *atmosphereButton;
@property (strong, nonatomic) IBOutlet UIButton *brandButton;
@property (strong, nonatomic) IBOutlet UIButton *bottleButton;
@property (strong, nonatomic) IBOutlet UIButton *dancer;
@property (strong, nonatomic) IBOutlet UIButton *hostesButton;
@property (strong, nonatomic) IBOutlet UIButton *photographerButton;
@property (strong, nonatomic) IBOutlet UIButton *socialButton;
@property (strong, nonatomic) IBOutlet UIButton *valetButton;
@property (strong, nonatomic) IBOutlet UIButton *actorButton;
@property (strong, nonatomic) IBOutlet UIButton *bartenderButton;
@property (strong, nonatomic) IBOutlet UIButton *bikiniButton;
@property (strong, nonatomic) IBOutlet UIButton *hairButton;
@property (strong, nonatomic) IBOutlet UIButton *promoButton;
@property (strong, nonatomic) IBOutlet UIButton *serverButton;
@property (strong, nonatomic) IBOutlet UIButton *streetButton;
@property (strong, nonatomic) IBOutlet UIButton *videoButton;
- (IBAction)privacyPolicyButtonPressed:(id)sender;

@property (nonatomic) NSInteger pictureItem;
@property (nonatomic) NSMutableArray *tagsArray;

@end
