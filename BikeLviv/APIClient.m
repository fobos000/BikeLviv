//
//  APISessionManager.m
//  BikeLviv
//
//  Created by Ostap Horbach on 11/30/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import "APIClient.h"

NSString * const kAPIURL = @"https://bike-lviv.herokuapp.com/api/v1/";

@implementation APIClient

+ (instancetype)sharedManager
{
    static APIClient *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIURL]];
        [_sharedManager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
    });
    
    return _sharedManager;
}

@end
