//
//  ProfileViewController.m
//  Instagigs
//
//  Created by Rahiem Klugh on 9/30/15.
//  Copyright © 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "ProfileViewController.h"
#import "Constants.h"
#import "InstagigSingelton.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.title = [PFUser currentUser][FIRSTNAME];
     //self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName :INSTABLUE};
  
    UIButton *btnNext1 =[[UIButton alloc] init];
    [btnNext1 setBackgroundImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    
    btnNext1.frame = CGRectMake(100, 100, 30, 8);
    UIBarButtonItem *btnNext =[[UIBarButtonItem alloc] initWithCustomView:btnNext1];
    [btnNext1 addTarget:self action:@selector(editAccount) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = btnNext;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    self.profileImage.layer.shadowColor = [UIColor blackColor].CGColor;
    //self.profileImage.layer.opacity = 0.6;
    self.profileImage.layer.shadowOffset = CGSizeMake(0, 1);
    self.profileImage.layer.shadowOpacity = 0.3;
    self.profileImage.layer.shadowRadius = 4.0;
    self.profileImage.clipsToBounds = NO;
}

-(void) viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

-(void) editAccount
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
