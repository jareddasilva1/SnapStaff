//
//  MapViewController.h
//  FreeShyt
//
//  Created by Rahiem Klugh on 6/3/15.
//  Copyright (c) 2015 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locManager;
@property (strong, nonatomic) IBOutlet UIImageView *whiteLocationBar;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@end
