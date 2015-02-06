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
#import "BikeLviv-Swift.h"
#import "DirectionService.h"

@interface MapViewController () <GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pinDetailViewBottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet MapDetailView *placeDetailView;
@property (nonatomic, strong) UIGestureRecognizer *swipeRecognizer;
@property (nonatomic, strong) NSMutableArray *displayedMarkers;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    [[PlaceProvider sharedInstance] addObserver:self
                                     forKeyPath:NSStringFromSelector(@selector(selectedPlaceTypes))
                                        options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                        context:nil];
    
    [self.mapView addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(myLocation))
                      options:0
                      context:nil];
    
    // Hack to enable users location on iOS 8
    [[CLLocationManager new] requestWhenInUseAuthorization];
    
    // Enable users location
    self.mapView.myLocationEnabled = YES;
    
    // Set map to initial position
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:49.841945
                                                            longitude:24.031713
                                                                 zoom:12];
    self.mapView.camera = camera;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(myLocation))]) {
        // my location updated, do something
        
        _mapView.camera = [GMSCameraPosition cameraWithTarget:_mapView.myLocation.coordinate
                                                         zoom:14];
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
    if (self.displayedMarkers.count == 0) return;
    
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

- (void)setRouteWithPath:(GMSPath *)path {
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
    GMSCameraPosition *position = [_mapView cameraForBounds:bounds insets:UIEdgeInsetsZero];
    [_mapView animateToCameraPosition:position];
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeWidth = 3;
    polyline.map = _mapView;
}

#pragma mark - GMSMapViewDelegate

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    Place *tappedPlace = marker.userData;
    self.placeDetailView.nameLabel.text = tappedPlace.name;
    self.placeDetailView.descriptionTextField.text = tappedPlace.desc;
    self.placeDetailView.routeTappedFunction = ^{
        if (mapView.myLocation) {
            CLLocationCoordinate2D destination = {tappedPlace.latitude, tappedPlace.longitude};
            [DirectionService findDirectionForOrigin:mapView.myLocation.coordinate
                                         destination:destination
                                           withBlock:^(GMSPath *path) {
                                               [self setRouteWithPath:path];
                                           }];
        }
        
    };
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(swipeDownDetailView)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.placeDetailView addGestureRecognizer:swipeRecognizer];
    
    self.pinDetailViewBottomSpaceConstraint.constant = 0.0f;
    [self.view setNeedsUpdateConstraints];

    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
    
    // Center selecter marker
    
    CGPoint pointForMarker = [self.mapView.projection pointForCoordinate:marker.position];
    pointForMarker.y += CGRectGetHeight(self.mapView.bounds) / 4;
    CLLocationCoordinate2D coordinate = [self.mapView.projection coordinateForPoint:pointForMarker];
    
    GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                                    longitude:coordinate.longitude
                                                                         zoom:self.mapView.camera.zoom];
    [self.mapView animateToCameraPosition:cameraPosition];
    
    
    return YES;
}

- (void)swipeDownDetailView {
    self.pinDetailViewBottomSpaceConstraint.constant = -CGRectGetHeight(self.placeDetailView.frame);
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
    [self.placeDetailView removeGestureRecognizer:[self.placeDetailView.gestureRecognizers firstObject]];
}

@end
