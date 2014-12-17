//
//  BikeVerticalMenuItemCollectionViewCell.h
//  BikeLviv
//
//  Created by Ostap Horbach on 12/17/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import "BikeVerticalMenuItem.h"

@interface BikeVerticalMenuItemCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) BikeVerticalMenuItem *theMenuItem;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *placeholderLabel;

@end
