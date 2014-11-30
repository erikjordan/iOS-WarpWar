//
//  GameEngine.h
//  iOS WarpWar
//
//  Created by Erik Jordan on 11/6/14.
//  Copyright (c) 2014 Erik Jordan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

// Notification names
extern NSString* const GameCenterLoginNeededName;

@interface GameEngine : NSObject

@property GKLocalPlayer* authenticatedPlayer;
@property BOOL authenticationNeeded;
@property UIViewController* authenticationViewController;

+ (GameEngine*) sharedInstance;

- (void) start;

@end
