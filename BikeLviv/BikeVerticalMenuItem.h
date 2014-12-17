//
//  BikeVerticalMenuItem.h
//  BikeLviv
//
//  Created by Ostap Horbach on 12/17/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

#import "FCVerticalMenuItem.h"

typedef void (^SelectionBlock)(BOOL selected);

@interface BikeVerticalMenuItem : FCVerticalMenuItem

@property (nonatomic, strong) SelectionBlock selectionBlock;

@end
