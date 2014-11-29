//
//  FirstViewController.m
//  BikeLviv
//
//  Created by Ostap Horbach on 11/29/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

#import "MapViewController.h"
#import "APIClient.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[APIClient sharedInstance] GETmodelWithName:@"routes" commpletionBlock:^(id responseObject, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
