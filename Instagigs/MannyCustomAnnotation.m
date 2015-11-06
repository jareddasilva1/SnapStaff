//
//  MannyCustomAnnotation.m
//  MannyWilson
//
//  Created by Rahiem Klugh on 10/6/14.
//  Copyright (c) 2014 Bryan Garces. All rights reserved.
//

#import "MannyCustomAnnotation.h"

@implementation MannyCustomAnnotation
{
    UIImageView *_imageView;
}



-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location
{
    self = [super init];
    
    if(self)
    {
        _title = newTitle;
        _coordinate = location;
    }
    
    return  self;
}

- (MKAnnotationView *)annotationView
{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MannyCustomAnnotation"];
    
    
    UIImage *orangeImage = [UIImage imageNamed:@"BlueGps"];
    CGRect resizeRect;
    //rescale image based on zoom level
    resizeRect.size.height = orangeImage.size.height * 0.3f;
    resizeRect.size.width = orangeImage.size.width  * 0.3f ;
   // NSLog(@"height =  %f, width = %f, zoomLevel = %f", resizeRect.size.height, resizeRect.size.width,zoomLevel );
    resizeRect.origin = (CGPoint){0,0};
    UIGraphicsBeginImageContext(resizeRect.size);
    [orangeImage drawInRect:resizeRect];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = resizedImage;//[UIImage imageNamed:@"droppin_with_shadow.png"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //annotationView.centerOffset = CGPointMake(0, -annotationView.image.size.height / 2);
    return annotationView;
}



@end
