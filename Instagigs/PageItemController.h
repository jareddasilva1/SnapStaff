//
//  ViewController.h
//  ProfileViewer
//
//  Created by Ronald Concepcion on 9/17/15.
//  Copyright (c) 2015 Ronald Concepcion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageItemController : UIViewController

// Item controller information
@property (nonatomic) NSUInteger itemIndex;
@property (nonatomic, strong) UIImage *image;

// IBOutlets
@property (nonatomic, weak) IBOutlet UIImageView *contentImageView;

@end
