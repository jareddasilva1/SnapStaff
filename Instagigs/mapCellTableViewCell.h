//
//  mapCellTableViewCell.h
//  Instagigs
//
//  Created by Jerry Phillips on 9/9/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface mapCellTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *venueName;
@property (strong, nonatomic) IBOutlet UILabel *venueAddress;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberOfVenue;
@property (strong, nonatomic) IBOutlet MKMapView *mapOfVenue;

@property(strong, nonatomic)MKPointAnnotation * pin;
@end
