//
//  Player.m
//  iOS WarpWar
//
//  Created by Erik Jordan on 3/8/15.
//  Copyright (c) 2015 Erik Jordan. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "Player.h"

@interface Player() <PFSubclassing>

@end


@implementation Player

@dynamic name, pointsAvailable, nickname; // TODO: Should we specify backing store name here?

#pragma mark - Parse-specific code

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Player"; // TODO: Do this dynamically?
}

@end
