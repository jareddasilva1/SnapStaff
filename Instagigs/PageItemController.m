//
//  ViewController.h
//  ProfileViewer
//
//  Created by Ronald Concepcion on 9/17/15.
//  Copyright (c) 2015 Ronald Concepcion. All rights reserved.
//

#import "PageItemController.h"

@interface PageItemController ()

@end

@implementation PageItemController
@synthesize itemIndex;
@synthesize image;
@synthesize contentImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create the image using the image name
    contentImageView.image = image;
}

- (void) setImage: (UIImage *) _image
{
    // Update the image name
    image = _image;
    
    // Update the image view
    contentImageView.image = _image;
}

@end
