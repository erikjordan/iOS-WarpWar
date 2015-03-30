//
//  GameEngine.m
//  iOS WarpWar
//
//  Created by Erik Jordan on 11/6/14.
//  Copyright (c) 2014 Erik Jordan. All rights reserved.
//

#import "GameEngine.h"

@interface GameEngine() <GKLocalPlayerListener>

@end

@implementation GameEngine

NSString* const GameCenterLoginNeededName = @"GameCenterLoginNeededName";

/*
 Approach notes:
 
 Turn-based matches: https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/GameKit_Guide/ImplementingaTurn-BasedMatch/ImplementingaTurn-BasedMatch.html#//apple_ref/doc/uid/TP40008304-CH15-SW1
 Match data limit: 64k
 Use foreground notifications to do real-time UI updates: https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/GameKit_Guide/ImplementingaTurn-BasedMatch/ImplementingaTurn-BasedMatch.html#//apple_ref/doc/uid/TP40008304-CH15-SW8
 
 
 
 
 */


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

#pragma mark - GKLocalPlayerListener implementation

-(void)player:(GKPlayer *)player receivedTurnEventForMatch:(GKTurnBasedMatch *)match didBecomeActive:(BOOL)didBecomeActive
{
    [GKNotificationBanner showBannerWithTitle:@"Turn Event" message:[NSString stringWithFormat:@"Did become active: %d", (int)didBecomeActive] completionHandler:nil];
    
    // Important things to handle:
    // 1) It's now this player's turn
    // 2) Other player saved game data
}

- (void)player:(GKPlayer *)player didAcceptInvite:(GKInvite *)invite
{
    
}

- (void)player:(GKPlayer *)player matchEnded:(GKTurnBasedMatch *)match
{
    
}


@end
