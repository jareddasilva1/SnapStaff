//
//  EventDetailsViewController.h
//  Instagigs
//
//  Created by Rahiem Klugh on 9/29/15.
//  Copyright © 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"
#import <MapKit/MapKit.h>
#import "MannyCustomAnnotation.h"

@interface EventDetailsViewController : UIViewController <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *spotsRemainingLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueAddress;
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (strong, nonatomic) IBOutlet MKMapView *eventMapView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *spotsLeftText;
@property (weak, nonatomic) IBOutlet UILabel *eventDate;
@property (weak, nonatomic) IBOutlet UIButton *bottomButtonCenter;
@property (weak, nonatomic) IBOutlet UIButton *contactNumberButton;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UIImageView *brandImage;
@property (strong, nonatomic) IBOutlet UILabel *eventType;
@property (strong, nonatomic) IBOutlet UILabel *notes;
@property (strong, nonatomic) IBOutlet UILabel *payRate;
@property (strong, nonatomic) IBOutlet UILabel *jobTitle;
- (IBAction)bottomButtonPressed:(id)sender;

@property(strong,nonatomic)eventObject *theEvent;
@property (strong, nonatomic) IBOutlet UIImageView *transparentTopBar;
- (IBAction)callContactNumber:(id)sender;

@end
