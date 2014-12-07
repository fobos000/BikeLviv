//
//  Place.m
//  BikeLviv
//
//  Created by Ostap Horbach on 11/30/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import "Place.h"
#import <Mantle/Mantle.h>

@implementation Place

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"serverId": @"id",
             @"desc": @"description",
             @"workTime": @"work_time",
             @"updatedAt": @"updated_at",
             @"phone": @"phone",
             @"address": @"address",
             @"name": @"name",
             @"homePage": @"home_page",
             @"createdAt": @"created_at",
             @"longitude": @"longitude",
             @"latitude": @"latitude",
             @"type": @"type"
             };
}

/*
 id": 12,
 "description": "\u041a\u0456\u043b\u044c\u043a\u0456\u0441\u0442\u044c \u043f\u0430\u0440\u043a\u043e\u043c\u0456\u0441\u0446\u044c - 4",
 "work_time": "10:00-20:00",
 "updated_at": "2014-11-11T07:46:07.427Z",
 "phone": "(032) 298-95-68",
 "address": "\u0432\u0443\u043b. \u0413\u043e\u0440\u043e\u0434\u043e\u0446\u044c\u043a\u0430, 175",
 "name": "\u0421\u043a\u0440\u0438\u043d\u044f",
 "home_page": null,
 "created_at": "2014-10-22T11:28:16.315Z",
 "longitude": "23.9947",
 "latitude": "49.8351",
 "type": "Supermarket"
 */

+ (NSValueTransformer *)URLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)HTMLURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"BicycleShop": @(PlaceTypeBicycleShop),
                                                                           @"Cafe": @(PlaceTypeCafe),
                                                                           @"Supermarket": @(PlaceTypeSupermarket),
                                                                           @"Parking": @(PlaceTypeParking)
                                                                           }];
}

+ (NSValueTransformer *)updatedAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    return self;
}

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName
{
    return @"Place";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{};
}

+ (NSSet *)propertyKeysForManagedObjectUniquing
{
    return [NSSet setWithObject:@"serverId"];
}

@end
