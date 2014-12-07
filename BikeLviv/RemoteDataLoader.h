//
//  RemoteDataLoader.h
//  BikeLviv
//
//  Created by Ostap Horbach on 11/30/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const RemoteDataLoaderDidFinishLoading;

@interface RemoteDataLoader : NSObject

+ (instancetype)sharedLoader;

- (void)loadData;

@end
