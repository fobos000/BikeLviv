//
//  PlaceType.m
//  BikeLviv
//
//  Created by Ostap Horbach on 12/15/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import "PlaceType.h"

@implementation PlaceType

- (id)initWithDisplayName:(NSString *)displayName
            menuImageName:(NSString *)menuImageName
                    value:(PlaceTypeValue)value {
    self = [super init];
    if (self) {
        _displayName = displayName;
        _menuImageName = menuImageName;
        _value = value;
    }
    return self;
}

@end
