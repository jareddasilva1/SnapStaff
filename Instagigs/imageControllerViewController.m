//
//  imageControllerViewController.m
//  Instagigs
//
//  Created by Jerry Phillips on 9/1/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "imageControllerViewController.h"

@interface imageControllerViewController ()

@end

@implementation imageControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView.image = _image;
    
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
