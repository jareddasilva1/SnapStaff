//
//  fourSquare.h
//  Instagigs
//
//  Created by Jerry Phillips on 9/19/15.
//  Copyright © 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface fourSquare : NSObject <CLLocationManagerDelegate>

-(void)getplaces: (NSString *)searchCriteria;
@property(nonatomic, strong)CLLocation *myLocation;
@property(nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic, strong)NSMutableArray *searchResults;
@end
