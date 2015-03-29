//
//  Player.h
//  iOS WarpWar
//
//  Created by Erik Jordan on 3/8/15.
//  Copyright (c) 2015 Erik Jordan. All rights reserved.
//

#import <Parse/Parse.h>

@interface Player : PFObject <PFSubclassing> // TODO: Can we move this protocol into .m file?

@property NSString* name;

@property NSNumber* pointsAvailable;

@property NSString* nickname;

@end
