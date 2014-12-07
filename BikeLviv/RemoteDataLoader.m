//
//  RemoteDataLoader.m
//  BikeLviv
//
//  Created by Ostap Horbach on 11/30/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import <Mantle.h>

#import "RemoteDataLoader.h"
#import "APIClient.h"
#import "Place.h"

NSString *const DateFormat = @"yyyy-MM-dd";
NSString * const RemoteDataLoaderDidFinishLoading = @"RemoteDataLoaderDidFinishLoading";

@interface RemoteDataLoader ()

@property (nonatomic, strong) APIClient *apiClient;

@property (nonatomic, strong) NSDate *lastUpdate;

@end

@implementation RemoteDataLoader

+ (instancetype)sharedLoader
{
    static RemoteDataLoader *_sharedLoader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLoader = [[RemoteDataLoader alloc] init];
        _sharedLoader.apiClient = [APIClient sharedManager];
    });
    
    return _sharedLoader;
}

- (NSString *)dateAsString:(NSDate *)date
{
    NSString *dateAsString = nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DateFormat;
    dateAsString = [dateFormatter stringFromDate:date];
    
    
    return dateAsString;
}

- (void)loadData
{
    NSDictionary *parameters = nil;
    if (self.lastUpdate) {
        parameters = @{@"afterDate" : [self dateAsString:self.lastUpdate]};
    }
    
    [self.apiClient GET:@"places" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", task.originalRequest.URL.absoluteString);
        self.lastUpdate = [NSDate date];
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
            
            NSMutableArray *places = [@[] mutableCopy];
            [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSError *error = nil;
                Place *place = [MTLJSONAdapter modelOfClass:[Place class] fromJSONDictionary:obj error:&error];
                
                NSManagedObject *mobj = [MTLManagedObjectAdapter managedObjectFromModel:place
                                           insertingIntoContext:context
                                                          error:&error];
                
                [places addObject:place];
            }];
            
            NSError *saveError;
            if (![context save:&saveError]) {
                NSLog(@"Unable to save context for %@", [Place managedObjectEntityName]);
            }
            
            if (places.count > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:RemoteDataLoaderDidFinishLoading
                                                                    object:self];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (NSDate *)lastUpdate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUpdate"];
}

- (void)setLastUpdate:(NSDate *)lastUpdate
{
    [[NSUserDefaults standardUserDefaults] setObject:lastUpdate forKey:@"lastUpdate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
