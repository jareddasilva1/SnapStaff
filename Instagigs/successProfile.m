//
//  successProfile.m
//  Instagigs
//
//  Created by Jerry Phillips on 8/24/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "successProfile.h"

@interface successProfile ()

@end

@implementation successProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(go) withObject:nil afterDelay:2.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)go
{
    [self performSegueWithIdentifier:@"eventManager" sender:self];
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
