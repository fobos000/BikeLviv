//
//  PlaceProvider.h
//  BikeLviv
//
//  Created by Ostap Horbach on 12/11/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Place.h"
#import "PlaceType.h"

@interface PlaceProvider : NSObject

+ (PlaceProvider *)sharedInstance;

- (void)selectPlaceType:(PlaceType *)placeType;
- (void)deselectPlaceType:(PlaceType *)placeType;

@property (nonatomic, strong, readonly) NSSet *selectedPlaceTypes;
@property (readonly) NSArray *selectedPlaces;
@property (readonly) NSArray *placeTypes;

@end
