//
//  BikeVerticalMenu.m
//  BikeLviv
//
//  Created by Ostap Horbach on 12/16/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import "BikeVerticalMenu.h"
#import "BikeVerticalMenuItemCollectionViewCell.h"

@implementation BikeVerticalMenu

- (id)init
{
    self = [super init];
    if (self) {
        self.font = [UIFont fontWithName:@"Helvetica-Light" size:10];
        self.textColor = [UIColor darkGrayColor];
        self.borderColor = [UIColor darkGrayColor];
        
        [self.menuCollection registerClass:[BikeVerticalMenuItemCollectionViewCell class]
                forCellWithReuseIdentifier:@"menuItem"];
        self.menuCollection.allowsMultipleSelection = NO;
        self.closeOnSelection = NO;
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BikeVerticalMenuItemCollectionViewCell *cell = (BikeVerticalMenuItemCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"menuItem" forIndexPath:indexPath];
    
    cell.theMenuItem = self.items[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BikeVerticalMenuItemCollectionViewCell *cell = (BikeVerticalMenuItemCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.theMenuItem.selectionBlock) {
        cell.theMenuItem.selectionBlock(YES);
    }
    
    if (self.closeOnSelection) {
        self.bounce = NO;
        [self dismissWithCompletionBlock:^{
            self.bounce = YES;
        }];
    }
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.menuCollection selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    BikeVerticalMenuItem *menuItem = self.items[indexPath.row];
    menuItem.selectionBlock(YES);
}

- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath {
    BikeVerticalMenuItemCollectionViewCell *cell = (BikeVerticalMenuItemCollectionViewCell*)[self.menuCollection cellForItemAtIndexPath:indexPath];
    
    if (cell.theMenuItem.selectionBlock) {
        cell.theMenuItem.selectionBlock(NO);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self deselectItemAtIndexPath:indexPath];
}

@end
