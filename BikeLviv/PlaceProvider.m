//
//  PlaceProvider.m
//  BikeLviv
//
//  Created by Ostap Horbach on 12/11/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import <Mantle.h>

#import "PlaceProvider.h"
#import "PlaceEntity.h"

@implementation PlaceProvider

+ (PlaceProvider *)sharedInstance
{
    static PlaceProvider *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [PlaceProvider new];
    });
    
    return sharedInstance;
}

- (void)setPlaceTypes:(NSSet *)placeTypes
{
    _placeTypes = placeTypes;
}

- (NSArray *)selectedPlaces
{
    NSMutableArray *selectedPlaces = [@[] mutableCopy];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type IN %@", [_placeTypes allObjects]];
    NSArray *selectedPlaceEntities = [PlaceEntity MR_findAllWithPredicate:predicate];
    
    for (PlaceEntity *placeEntity in selectedPlaceEntities) {
        NSError *error;
        Place *place = [MTLManagedObjectAdapter modelOfClass:[Place class] fromManagedObject:placeEntity error:&error];
        if (place) {
            [selectedPlaces addObject:place];
        } else {
            NSLog(@"%@", error);
        }
    }
    
    return [NSArray arrayWithArray:selectedPlaces];
}

@end
