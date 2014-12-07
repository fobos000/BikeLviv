//
//  FirstViewController.m
//  BikeLviv
//
//  Created by Ostap Horbach on 11/29/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

#import "MapViewController.h"
#import "RemoteDataLoader.h"
#import "PlaceEntity.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pinDetailViewBottomSpaceConstraint;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatedPlaces)
                                                 name:RemoteDataLoaderDidFinishLoading
                                               object:nil];
    
    self.places = [PlaceEntity MR_findAll];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.pinDetailViewBottomSpaceConstraint.constant = 0.0f;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updatedPlaces
{
    self.places = [PlaceEntity MR_findAll];

    for (PlaceEntity *place in self.places) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(place.latitude.doubleValue, place.longitude.doubleValue);
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = self.mapView;
    }
}

@end
