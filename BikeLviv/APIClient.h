//
//  APIClient.h
//  BikeLviv
//
//  Created by Ostap Horbach on 11/29/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIClient : NSObject

- (void)GETmodelWithName:(NSString *)modelName commpletionBlock:(void (^)(id responseObject, NSError* error))block;

+ (instancetype)sharedInstance;

@end
