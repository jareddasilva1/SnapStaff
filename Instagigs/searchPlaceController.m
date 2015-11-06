//
//  searchPlaceController.m
//  Instagigs
//
//  Created by Jerry Phillips on 8/25/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "searchPlaceController.h"
#import "Constants.h"
#import "placeCell.h"
#import "fourSquare.h"
#import "InstagigSingelton.h"
#import <Parse/Parse.h>

@interface searchPlaceController ()

@end

UISearchBar *searchBar;
InstagigSingelton * DataShare;
fourSquare *searchVenue;

@implementation searchPlaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    searchVenue =[[fourSquare alloc]init];
    _gTableView.estimatedRowHeight = 96;
    searchBar = [[UISearchBar alloc] init];
    
    searchBar.delegate = self;
    
    
    self.navigationItem.titleView = searchBar;
    searchBar.placeholder = @"Search for Venue";
    DataShare = [InstagigSingelton instagGigObject];
    // self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = INSTABLUE;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(done) name:DISMISSKEYBOARD object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableViewData) name:SEARCHCOMPLETED object:nil];
}

-(void)done
{
    [searchBar resignFirstResponder];
}
-(void)viewDidDisappear:(BOOL)animated
{
    //remove notifications
    [[NSNotificationCenter defaultCenter]removeObserver:DISMISSKEYBOARD];
    [[NSNotificationCenter defaultCenter]removeObserver:SEARCHCOMPLETED];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //[[NSNotificationCenter defaultCenter]postNotificationName:MOVECONTENT object:nil];
    
    searchBar.inputAccessoryView = [DataShare doneToolBar:self.view];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    //[[NSNotificationCenter defaultCenter]postNotificationName:MOVECONTENT object:nil];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length > 2)
    {
        [searchVenue.searchResults removeAllObjects];
        [searchVenue getplaces:searchText];
        
    }
    
}


-(void)reloadTableViewData
{
    [_gTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchVenue.searchResults.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    placeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeCell"];
    
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"placeCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (placeCell*) currentObject;
                break;
            }
        }
    }
    
    NSArray *object = [searchVenue.searchResults objectAtIndex:indexPath.row];
    cell.venueName.text =[object valueForKey:NAME ];
    cell.venueAddress.text = [[object valueForKey:LOCATION] valueForKey:ADDRESS];
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *object = [searchVenue.searchResults objectAtIndex:indexPath.row];
    
    //latitude of venue
    double lat = [[[object valueForKey:LOCATION] valueForKey:LAT]doubleValue];
    
    //longitude of venue
    double lng = [[[object valueForKey:LOCATION] valueForKey:LNG]doubleValue];
    
    DataShare.currentEvent.parseEventObject[VENUENAME] = [object valueForKey:NAME ];
    
    DataShare.currentEvent.parseEventObject[EVENTADDRESS] = [[object valueForKey:LOCATION] valueForKey:ADDRESS];
    DataShare.currentEvent.parseEventObject[GEOPOINT] = [PFGeoPoint geoPointWithLatitude:lat longitude:lng];
    
    //[self performSegueWithIdentifier:@"detailForEvent" sender:self];
    [self displayAddress:lat long:lng];
}

-(NSString*) displayAddress:(double)lat long: (double) lon
{
    
    __block NSString *city;
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:lat longitude: lon]; //insert your coordinates
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         NSLog(@"addressDictionary %@", placemark.addressDictionary);
         
         NSLog(@"placemark %@",placemark.region);
         NSLog(@"placemark %@",placemark.country);  // Give Country Name
         NSLog(@"placemark %@",placemark.locality); // Extract the city name
         NSLog(@"location %@",placemark.name);
         NSLog(@"location %@",placemark.ocean);
         NSLog(@"location %@",placemark.postalCode);
         NSLog(@"location %@",placemark.subLocality);
         NSLog(@"location %@",placemark.location);
         //Print the location to console
         NSLog(@"I am currently at %@",locatedAt);
         
         city = [NSString stringWithFormat:@"%@, %@",placemark.locality,placemark.administrativeArea];
         
         DataShare.currentEvent.parseEventObject[CITY] = placemark.locality;
         DataShare.currentEvent.parseEventObject[STATE] = placemark.administrativeArea;
         DataShare.currentEvent.parseEventObject[ZIPCODE] = [NSNumber numberWithInteger: [placemark.postalCode integerValue]];
         
         [self dismissAndUpdateTextField];
         
     }];
    
    return city;
}

-(void) dismissAndUpdateTextField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEVENUETEXT object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
