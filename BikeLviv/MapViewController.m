//
//  FirstViewController.m
//  BikeLviv
//
//  Created by Ostap Horbach on 11/29/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

#import "MapViewController.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pinDetailViewBottomSpaceConstraint;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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

@end
