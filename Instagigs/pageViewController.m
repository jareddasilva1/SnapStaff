//
//  ViewController.h
//  ProfileViewer
//
//  Created by Ronald Concepcion on 9/17/15.
//  Copyright (c) 2015 Ronald Concepcion. All rights reserved.
//

#import "pageViewController.h"
#import "PageItemController.h"

@interface pageViewController () <UIPageViewControllerDataSource>

// List of image files to load
@property (nonatomic, strong) NSMutableArray *contentImages;

// Page View Controller
@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation pageViewController

// Synthesize the content images
@synthesize contentImages;

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setupPageControl];
}

/**
 * Creates the page view controller.
 */
- (void) createPageViewController:(NSDictionary *) images
{
    // Initialize the content images
    contentImages = [[NSMutableArray alloc] init];
    
    // Go through all the images
    for (int i = 0; i < images.count; i++)
    {
        // Get the current key name
        NSString* key = [NSString stringWithFormat:@"profile%d", i + 1];
        
        // Store the image associated with the key
        [contentImages addObject:[images objectForKey:key]];
        
        
    }
    
    // Get the page view controller from the storyboard
    UIPageViewController *pageController = [self.storyboard instantiateViewControllerWithIdentifier: @"PageController"];
    
    // Set the page controller's data source callback
    pageController.dataSource = self;
    
    // If there are any image files to load
    if([contentImages count])
    {
        // Get the first item controller
        NSArray* startingViewControllers = @[[self itemControllerForIndex: 0]];
        
        // Set the page controller's initial view
        [pageController setViewControllers: startingViewControllers
                                 direction: UIPageViewControllerNavigationDirectionForward
                                  animated: NO
                                completion: nil];
    }
    
    // Store the new page controller and add it as a child view
    self.pageViewController = pageController;
    [self addChildViewController: self.pageViewController];
    [self.view addSubview: self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController: self];
}

/**
 * Sets the page controller's UI colors.
 */
- (void) setupPageControl
{
    [[UIPageControl appearance] setPageIndicatorTintColor: [UIColor grayColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor: [UIColor whiteColor]];
    [[UIPageControl appearance] setBackgroundColor: [UIColor darkGrayColor]];
}

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerBeforeViewController:(UIViewController *) viewController
{
    // Cast the view controller as a Page Item Controller
    PageItemController *itemController = (PageItemController *) viewController;

    // Return the previous item controller
    return [self itemControllerForIndex: itemController.itemIndex - 1];
}

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerAfterViewController:(UIViewController *) viewController
{
    // Cast the view controller as a Page Item Controller
    PageItemController *itemController = (PageItemController *) viewController;
    
    // Return the next item controller
    return [self itemControllerForIndex: itemController.itemIndex+1];
}

/*
 * Creates an item controller for the specified index.
 */

//need to make a change here to set the start image for the image that the user initially selected ***Jerry Phillips
- (PageItemController *) itemControllerForIndex: (NSUInteger) itemIndex
{
    // If the specified item index is not bigger than the list of images
    if (itemIndex < [contentImages count])
    {
        // Get an Item Controller
        PageItemController *pageItemController = [self.storyboard instantiateViewControllerWithIdentifier: @"ItemController"];
        
        // Set the item index
        pageItemController.itemIndex = itemIndex;

        // Set the item's name with the image to load
        pageItemController.image = contentImages[itemIndex];
        
        // Return the newly created controller
        return pageItemController;
    }
    
    return nil;
}


- (NSInteger) presentationCountForPageViewController: (UIPageViewController *) pageViewController {
    return [contentImages count];
}

- (NSInteger) presentationIndexForPageViewController: (UIPageViewController *) pageViewController {
    return 0;
}

@end
