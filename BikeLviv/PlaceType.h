//
//  PlaceType.h
//  BikeLviv
//
//  Created by Ostap Horbach on 12/15/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PlaceTypeCreate(dispName, menuImgName, val) \
        [[PlaceType alloc] initWithDisplayName:(dispName) menuImageName:(menuImgName) value:(val)]

typedef enum : NSUInteger {
    PlaceTypeBicycleShop,
    PlaceTypeCafe,
    PlaceTypeSupermarket,
    PlaceTypeParking
} PlaceTypeValue;

@interface PlaceType : NSObject

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *menuImageName;
@property (nonatomic) PlaceTypeValue value;

- (id)initWithDisplayName:(NSString *)displayName
            menuImageName:(NSString *)menuImageName
                    value:(PlaceTypeValue)value;

@end
