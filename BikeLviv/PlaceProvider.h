//
//  PlaceProvider.h
//  BikeLviv
//
//  Created by Ostap Horbach on 12/11/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Place.h"

@interface PlaceProvider : NSObject

+ (PlaceProvider *)sharedInstance;

@property (nonatomic, strong) NSSet *selectedPlaceTypes;
@property (readonly) NSArray *selectedPlaces;
@property (readonly) NSArray *placeTypes;

@end
