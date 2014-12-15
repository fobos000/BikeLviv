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
#import "PlaceProvider.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pinDetailViewBottomSpaceConstraint;
@property (nonatomic, strong) NSArray *places;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PlaceProvider sharedInstance] addObserver:self
                                     forKeyPath:NSStringFromSelector(@selector(selectedPlaceTypes))
                                        options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                        context:nil];
    
//    [self displayPlaces];
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

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(selectedPlaceTypes))]) {
        [self displayPlaces];
    }
}

- (void)displayPlaces
{
    self.places = [PlaceProvider sharedInstance].selectedPlaces;

    for (Place *place in self.places) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(place.latitude, place.longitude);
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = self.mapView;
    }
}

@end
