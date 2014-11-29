//
//  DirectionService.h
//  BikeRoute
//
//  Created by Ostap Horbach on 8/14/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class GMSPath;


typedef void (^DirectionBlock)(GMSPath *);

@interface DirectionService : NSObject

+ (void)findDirectionForPoints:(NSArray *)points withBlock:(DirectionBlock)block;
+ (void)findDirectionForOrigin:(CLLocationCoordinate2D)origin
                   destination:(CLLocationCoordinate2D)destination
                     withBlock:(DirectionBlock)block;

@end
