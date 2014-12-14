//
//  MainTabBarViewController.m
//  BikeLviv
//
//  Created by Ostap Horbach on 12/14/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import <FCVerticalMenu.h>

#import "MainTabBarViewController.h"
#import "PlaceProvider.h"

@interface MainTabBarViewController ()

@property (nonatomic, strong) FCVerticalMenu *verticalMenu;

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *menuItems = [@[] mutableCopy];
    for (NSString *placeTypeName in [PlaceProvider sharedInstance].placeTypes) {
        FCVerticalMenuItem *menuItem = [[FCVerticalMenuItem alloc] initWithTitle:placeTypeName andIconImage:[UIImage imageNamed:@"settings-icon"]];
        
        menuItem.actionBlock = ^{
            NSLog(@"test element 1");
        };
        
        [menuItems addObject:menuItem];
    }
    
    self.verticalMenu = [[FCVerticalMenu alloc] initWithItems:menuItems];
    self.verticalMenu.appearsBehindNavigationBar = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuItemTapped:(id)sender {
    if (self.verticalMenu.isOpen) {
        [self.verticalMenu dismissWithCompletionBlock:nil];
    } else {
        [self.verticalMenu showFromNavigationBar:self.navigationController.navigationBar inView:self.view];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
