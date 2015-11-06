//
//  ViewController.h
//  ProfileViewer
//
//  Created by Ronald Concepcion on 9/17/15.
//  Copyright (c) 2015 Ronald Concepcion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pageViewController : UIViewController

@property(nonatomic)NSInteger startHere;
/**
 * Creates the page view controller with images.
 * @param images List of images to load.
 */
- (void) createPageViewController:(NSDictionary*) images;



@end

