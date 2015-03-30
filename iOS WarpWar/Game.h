//
//  Game.h
//  iOS WarpWar
//
//  Created by Erik Jordan on 3/29/15.
//  Copyright (c) 2015 Erik Jordan. All rights reserved.
//

#import <Parse/Parse.h>

#import "Player.h"

@interface Game : PFObject

@property Player* player1;

@property Player* player2;

@property NSArray* player1Ships;

@property NSArray* player2Ships;

@end
