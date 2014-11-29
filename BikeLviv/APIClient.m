//
//  APIClient.m
//  BikeLviv
//
//  Created by Ostap Horbach on 11/29/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>

#import "APIClient.h"

NSString * const kAPIURL = @"https://bike-lviv.herokuapp.com/api/v1/";

@implementation APIClient

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *)pathForModelName:(NSString *)modelName
{
    NSAssert(modelName.length, @"Invalid model name");
    return [NSString stringWithFormat:@"%@%@", kAPIURL, modelName];
}

- (void)GETmodelWithName:(NSString *)modelName commpletionBlock:(void (^)(id responseObject, NSError* error))block
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[self pathForModelName:modelName] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if (block) {
            block(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (block) {
            block(nil, error);
        }
    }];
}

@end
