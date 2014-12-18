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
@property (nonatomic, strong) NSMutableArray *displayedMarkers;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PlaceProvider sharedInstance] addObserver:self
                                     forKeyPath:NSStringFromSelector(@selector(selectedPlaceTypes))
                                        options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                        context:nil];
    
    // Set map to initial position
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:49.841945
                                                            longitude:24.031713
                                                                 zoom:12];
    self.mapView.camera = camera;
    
}

- (void)viewDidAppear:(BOOL)animated {
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
        [self updateMarkers];
    }
}

- (NSMutableArray *)displayedMarkers {
    if (!_displayedMarkers) {
        _displayedMarkers = [@[] mutableCopy];
    }
    return _displayedMarkers;
}

- (void)updateCameraToDisplayedMarkers
{
    if (!self.displayedMarkers) return;
    
    CLLocationCoordinate2D firstLocation = ((GMSMarker *)self.displayedMarkers.firstObject).position;
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:firstLocation
                                                                       coordinate:firstLocation];
    
    for (GMSMarker *marker in self.displayedMarkers) {
        bounds = [bounds includingCoordinate:marker.position];
    }
    
    [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds]];
}

- (void)updateMarkers
{
    NSArray *places = [PlaceProvider sharedInstance].selectedPlaces;
    NSArray *displayedPlaces = [self.displayedMarkers
                                valueForKey:NSStringFromSelector(@selector(userData))];

    
    NSMutableSet *placeToDeleteSet = [NSMutableSet setWithArray:displayedPlaces];
    [placeToDeleteSet minusSet:[NSSet setWithArray:places]];
    
    for (Place *place in placeToDeleteSet) {
        GMSMarker *markerToDelete = [self findMarkerForPlace:place];
        markerToDelete.map = nil;
        [self.displayedMarkers removeObject:markerToDelete];
    }
    
    NSMutableSet *placeToDisplaySet = [NSMutableSet setWithArray:places];
    [placeToDisplaySet minusSet:[NSSet setWithArray:displayedPlaces]];
    
    for (Place *place in placeToDisplaySet) {
        GMSMarker *markerToDisplay = [self findOrCreateMarkerForPlace:place];
        markerToDisplay.map = self.mapView;
        [self.displayedMarkers addObject:markerToDisplay];
    }
    
    [self updateCameraToDisplayedMarkers];
}

- (GMSMarker *)findMarkerForPlace:(Place *)place {
    GMSMarker *markerForPlace = nil;
    
    for (GMSMarker *marker in self.displayedMarkers) {
        Place *markersPlace = marker.userData;
        if (markersPlace.serverId == place.serverId) {
            markerForPlace = marker;
            break;
        }
    }
    
    return markerForPlace;
}

- (GMSMarker *)findOrCreateMarkerForPlace:(Place *)place {
    GMSMarker *markerForPlace = nil;
    
    markerForPlace = [self findMarkerForPlace:place];
    
    if (!markerForPlace) {
        markerForPlace = [[GMSMarker alloc] init];
        markerForPlace.position = CLLocationCoordinate2DMake(place.latitude, place.longitude);
        markerForPlace.appearAnimation = kGMSMarkerAnimationPop;
        markerForPlace.userData = place;
    }
    
    return markerForPlace;
}

@end
