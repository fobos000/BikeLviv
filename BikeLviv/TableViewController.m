//
//  SecondViewController.m
//  BikeLviv
//
//  Created by Ostap Horbach on 11/29/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import "TableViewController.h"
#import "RemoteDataLoader.h"
#import "PlaceEntity.h"

@interface TableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *places;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatedPlaces)
                                                 name:RemoteDataLoaderDidFinishLoading
                                               object:nil];
    
    self.places = [PlaceEntity MR_findAll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updatedPlaces
{
    self.places = [PlaceEntity findAll];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    PlaceEntity *place = self.places[indexPath.row];
    cell.textLabel.text = place.desc;
    
    return cell;
}

@end
