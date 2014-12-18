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

@interface PlaceProvider ()

@property (nonatomic, strong) NSMutableSet *selectedPlaceTypesInternal;

@end

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

- (id)init
{
    self = [super init];
    if (self) {
        _selectedPlaceTypesInternal = [NSMutableSet set];
        _selectedPlaceTypes = [NSSet set];
    }
    return self;
}

- (void)selectPlaceType:(PlaceType *)placeType {
    [_selectedPlaceTypesInternal addObject:placeType];
    [self willChangeValueForKey:NSStringFromSelector(@selector(selectedPlaceTypes))];
    _selectedPlaceTypes = [NSSet setWithSet:_selectedPlaceTypesInternal];
    [self didChangeValueForKey:NSStringFromSelector(@selector(selectedPlaceTypes))];
}

- (void)deselectPlaceType:(PlaceType *)placeType {
    [_selectedPlaceTypesInternal removeObject:placeType];
    [self willChangeValueForKey:NSStringFromSelector(@selector(selectedPlaceTypes))];
    _selectedPlaceTypes = [NSSet setWithSet:_selectedPlaceTypesInternal];
    [self didChangeValueForKey:NSStringFromSelector(@selector(selectedPlaceTypes))];
}

- (NSArray *)selectedPlaces
{
    NSMutableArray *selectedPlaces = [@[] mutableCopy];
    
    NSArray *selectedTypeValues = [[_selectedPlaceTypes allObjects] valueForKey:@"value"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type IN %@", selectedTypeValues];
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

- (NSArray *)placeTypes
{
    return @[PlaceTypeCreate(NSLocalizedString(@"Bycicle Shops", nil), nil, PlaceTypeBicycleShop),
             PlaceTypeCreate(NSLocalizedString(@"Cafes", nil), nil, PlaceTypeCafe),
             PlaceTypeCreate(NSLocalizedString(@"Supermarkets", nil), nil, PlaceTypeSupermarket),
             PlaceTypeCreate(NSLocalizedString(@"Parkings", nil), nil, PlaceTypeParking)];
}

@end
