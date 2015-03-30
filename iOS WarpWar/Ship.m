//
//  Ship.m
//  iOS WarpWar
//
//  Created by Erik Jordan on 3/29/15.
//  Copyright (c) 2015 Erik Jordan. All rights reserved.
//

#import "Ship.h"

@interface Ship() <PFSubclassing>

@end


@implementation Ship

@dynamic name, xLocation, yLocation;

#pragma mark - Parse-specific code

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Ship";
}

@end
