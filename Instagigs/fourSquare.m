//
//  fourSquare.m
//  Instagigs
//
//  Created by Jerry Phillips on 9/19/15.
//  Copyright © 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "fourSquare.h"
#import "Constants.h"
#import <UIKit/UIKit.h>

NSString * autoCompletion;
NSString *searchTerms;
NSMutableData *retrievedData;



@implementation fourSquare

-(void)getplaces:(NSString *)searchCriteria
{
    searchTerms = searchCriteria;
    [self startUpdates];
    
  
}

-(void)startUpdates
{
    // Create the location manager if it does not already exists.
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    // Request foreground access
    [_locationManager requestWhenInUseAuthorization];
    
    
    
    // Set the location manager delegate
    _locationManager.delegate = self;
    
    
    // Pause location update automatically if neccesary
    _locationManager.pausesLocationUpdatesAutomatically = YES;
    
    
   
    
    
        // Start the location manager updating
        [_locationManager startUpdatingLocation];
   
}



-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    retrievedData = [[NSMutableData alloc]init];
}

-(void) connection:(NSURLConnection *) connection didReceiveData:(NSData *)data
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    [retrievedData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSMutableArray *tempStorage;
    if (retrievedData.length > 0)
    {
        
        
        tempStorage = [NSJSONSerialization JSONObjectWithData:retrievedData options:NSJSONReadingMutableContainers error:nil];
        
        _searchResults = [[NSMutableArray alloc] init];
        
        
        NSArray *tempArray = [[tempStorage valueForKey:@"response"] valueForKey:@"minivenues"];
        
        //eliminate the values that do not have addresses
        
        for (NSArray *array in tempArray)
        {
            if ([[array valueForKey:LOCATION] valueForKey:ADDRESS] != nil)
            {
                [_searchResults addObject: array];
            }
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:SEARCHCOMPLETED object:nil];
    }
    
}

// Delegate method from the CLLocationManagerDelegate protocol
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // Delegate method from the CLLocationManagerDelegate protocol.
    
    // If it's a relatively recent event, turn off updates to save power.
    
    CLLocation* location = [locations lastObject];
    NSDate *locDate = location.timestamp;
    NSTimeInterval howRecent = [locDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        // If the event is recent, do something with it.
        
        NSString* latittude =[NSString stringWithFormat: @"%+.6f", location.coordinate.latitude];
        NSString * longitude = [NSString stringWithFormat: @"%+.6f", location.coordinate.longitude];
        
        
        
        
        [_locationManager stopUpdatingLocation];
        
        
        autoCompletion = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/suggestcompletion?ll=%@,%@&client_id=%@&client_secret=%@&v=%@&radius=100000&query=%@",latittude,longitude,FSCLIENTKEY,FSCLIENTSECRET,[self returnDate],searchTerms];
        
        NSURL *url = [NSURL URLWithString:autoCompletion];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
}

//return a formatted date for FourSquare search
-(NSString *)returnDate
    {
        
        NSDate *now = [NSDate date];
        NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSString *theDate = [formatter stringFromDate:now];
        
        return theDate;
    }

@end
