//
//  GameEngine.m
//  iOS WarpWar
//
//  Created by Erik Jordan on 11/6/14.
//  Copyright (c) 2014 Erik Jordan. All rights reserved.
//

#import "GameEngine.h"

NSString* const GameCenterLoginNeededName = @"GameCenterLoginNeededName";

@implementation GameEngine

// TODO: May want logic around auth moved to separate class.

+ (GameEngine*) sharedInstance
{
	static GameEngine* sharedGameEngine = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken,
			^()
			{
				sharedGameEngine = [[self alloc] init];
			});
	
	return sharedGameEngine;
}

- (id) init
{
	if (self = [super init])
	{
	}
	
	return self;
}

- (void) nofifyAuthenticationNeeded
{
	[[NSNotificationCenter defaultCenter] postNotificationName:GameCenterLoginNeededName object:self];
}

- (void) start
{
	self.authenticatedPlayer = [GKLocalPlayer localPlayer];
	__weak GameEngine* weakSelf = self;
	
	self.authenticatedPlayer.authenticateHandler =
			^(UIViewController *viewController, NSError *error)
			{
				if (viewController != nil)
				{
					// Tell engine we need auth so we can interrogate it when ready to display auth controller
					[GameEngine sharedInstance].authenticationNeeded = YES;
					[GameEngine sharedInstance].authenticationViewController = viewController;
					[weakSelf nofifyAuthenticationNeeded];
				}
				else if (weakSelf.authenticatedPlayer.isAuthenticated)
				{
					// authenticatedPlayer: is an example method name. Create your own method that is called after the loacal player is authenticated.
				}
				else
				{
					// [self disableGameCenter];
				}
			};
}

@end
