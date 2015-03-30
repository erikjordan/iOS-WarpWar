//
//  Game.m
//  iOS WarpWar
//
//  Created by Erik Jordan on 3/29/15.
//  Copyright (c) 2015 Erik Jordan. All rights reserved.
//

#import "Game.h"

@interface Game() <PFSubclassing>

@end


@implementation Game

@dynamic player1, player2, player1Ships, player2Ships;

#pragma mark - Parse-specific code

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Game";
}

@end
