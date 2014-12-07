//
//  PlaceEntity.m
//  BikeLviv
//
//  Created by Ostap Horbach on 12/2/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import "PlaceEntity.h"


@implementation PlaceEntity

@dynamic address;
@dynamic createdAt;
@dynamic desc;
@dynamic homePage;
@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic phone;
@dynamic serverId;
@dynamic type;
@dynamic updatedAt;
@dynamic workTime;

+ (id)entityInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription entityForName:@"Place" inManagedObjectContext:context];
}

@end
