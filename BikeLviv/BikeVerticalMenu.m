//
//  BikeVerticalMenu.m
//  BikeLviv
//
//  Created by Ostap Horbach on 12/16/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import "BikeVerticalMenu.h"

@implementation BikeVerticalMenu

- (id)init
{
    self = [super init];
    if (self) {
        self.font = [UIFont fontWithName:@"Helvetica-Light" size:10];
    }
    return self;
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view
{
    [super showFromRect:rect inView:view];
    
    int itemsPerRow = 4;
    float minimumInteritemSpacing = 15;
    float itemWidth = (rect.size.width - minimumInteritemSpacing * (itemsPerRow + 1)) / itemsPerRow;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.menuCollection.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 20);
    flowLayout.minimumInteritemSpacing = minimumInteritemSpacing;
    flowLayout.sectionInset = UIEdgeInsetsMake(minimumInteritemSpacing,
                                               minimumInteritemSpacing,
                                               minimumInteritemSpacing,
                                               minimumInteritemSpacing);
    [flowLayout invalidateLayout];
}

@end
