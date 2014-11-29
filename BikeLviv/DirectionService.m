//
//  DirectionService.m
//  BikeRoute
//
//  Created by Ostap Horbach on 8/14/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import "DirectionService.h"
#import <GoogleMaps/GoogleMaps.h>

static NSString *kMDDirectionsURL = @"http://maps.googleapis.com/maps/api/directions/json?";

@implementation DirectionService

+ (void)findDirectionForPoints:(NSArray *)points withBlock:(DirectionBlock)block
{
    
}

+ (void)findDirectionForOrigin:(CLLocationCoordinate2D)origin
                   destination:(CLLocationCoordinate2D)destination
                     withBlock:(DirectionBlock)block
{
    NSString *urlString = [NSMutableString stringWithFormat:@"%@&origin=%f,%f&destination=%f,%f&sensor=false",
     kMDDirectionsURL, origin.latitude, origin.longitude, destination.latitude, destination.longitude];
    
    urlString = [urlString
             stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:nil];
        NSDictionary *routes = [json objectForKey:@"routes"][0];
        NSDictionary *route = [routes objectForKey:@"overview_polyline"];
        NSString *overview_route = [route objectForKey:@"points"];
        GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(path);
            }
        });
    });
}


@end
