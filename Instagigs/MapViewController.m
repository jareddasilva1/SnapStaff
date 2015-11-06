//
//  MapViewController.m
//  FreeShyt
//
//  Created by Rahiem Klugh on 6/3/15.
//  Copyright (c) 2015 TouchCore Logic, LLC. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set the logo image on the nav bar
    UIImage*image = [UIImage imageNamed:@"FreeShytLogoOrange"];
    UIImageView*logoView = [[UIImageView alloc] initWithImage:image];
    float targetHeight = self.navigationController.navigationBar.frame.size.height;
    [logoView setFrame:CGRectMake(0, 0, 0, targetHeight)];
    [logoView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.navigationItem.titleView = logoView;
    // Show our location
    // Get Coords
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    
    self.whiteLocationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.whiteLocationBar.layer.opacity = 0.6;
    self.whiteLocationBar.layer.shadowOffset = CGSizeMake(0, 1);
    self.whiteLocationBar.layer.shadowOpacity = 0.3;
    self.whiteLocationBar.layer.shadowRadius = 4.0;
    self.whiteLocationBar.clipsToBounds = NO;
    
    [self getCurrentLocation];
    //[self.locManager startUpdatingLocation];
    //[self requestAlwaysAuthorization];
}

-(void) getCurrentLocation{
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
       // longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
       // latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
           self.locationLabel.text = [NSString stringWithFormat:@"Near %@, %@",placemark.locality,placemark.administrativeArea];
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)requestAlwaysAuthorization
//{
//    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
//    
//    // If the status is denied or only granted for when in use, display an alert
//    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
//        NSString *title;
//        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
//        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
//                                                            message:message
//                                                           delegate:self
//                                                  cancelButtonTitle:@"Cancel"
//                                                  otherButtonTitles:@"Settings", nil];
//        
//        [alertView show];
//    }
//    // The user has not enabled any location services. Request background authorization.
//    else if (status == kCLAuthorizationStatusNotDetermined) {
//        [self.locManager requestAlwaysAuthorization];
//    }
//}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // Get Coords
    CLLocationCoordinate2D coord = self.mapView.userLocation.location.coordinate;
    
    NSLog(@"Location %@", userLocation);
    
    //Zoom Region
    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(coord, 1000.0, 1000.0);
    
    // [self.myMapView setCenterCoordinate:phoneLocation animated:YES];
    // Show our location
    [self.mapView setRegion:zoomRegion animated:YES];
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
