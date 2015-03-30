//
//  MapViewController.m
//  iOS WarpWar
//
//  Created by Erik Jordan on 10/4/13.
//  Copyright (c) 2013 Erik Jordan. All rights reserved.
//

#import <GameKit/GameKit.h>

#import "GameEngine.h"
#import "HexView.h"
#import "MapViewController.h"
#import "Ship.h"

@interface MapViewController ()

@property (nonatomic) HexView *hexView;
@property (nonatomic) IBOutlet UIScrollView *scrollView;
@property NSMutableDictionary* buttonToShipLookup;

@end

@implementation MapViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.buttonToShipLookup = [[NSMutableDictionary alloc] init];
    
    // TODO: Fix the toolbar obscuring the map.
	
	// Using autolayout with the scroller seems to cause problems
	// http://stackoverflow.com/questions/13499467/uiscrollview-doesnt-use-autolayout-constraints
	// On second thought, not sure this applies, it may have more to do about when using constraints
	// *within* a scroll view, not around it.
	
	self.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
	self.scrollView.maximumZoomScale = 2.0;
	
	// self.scrollView.contentSize = self.hexView.bounds.size; // Apparently don't need to do this anymore, but:
	// Need a constraint that binds all edges of the hex view to the scroll view parent. Then the contentSize property seems
	// to be set automatically.
	
	// This is the trick to get this all working: you must add the view manually, not via the storyboard/xib
	self.hexView = [[HexView alloc] initWithFrame:CGRectMake(0., 0., 500., 800.)]; // Frame is moot as we override it anyway.
	
	[self.scrollView addSubview:self.hexView];
	self.scrollView.contentSize = self.hexView.bounds.size;
	
	// Now we can set our minimum scale so the user can't zoom out further than matching the width of the hexView to the window.
	self.scrollView.minimumZoomScale = self.scrollView.frame.size.width / self.hexView.frame.size.width;
    
	[[NSNotificationCenter defaultCenter] addObserverForName:GameCenterLoginNeededName
			object:nil
			queue:nil
			usingBlock:
					^(NSNotification* notification)
					{
						if ([GameEngine sharedInstance].authenticationNeeded)
						{
							[self presentViewController:[GameEngine sharedInstance].authenticationViewController animated:YES completion:nil];
							// TODO: Handle case where user cancels the login
						}
					}];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadGame];
}

- (void)addGamePieces
{
    // Place each piece on the board
    for (Ship* ship in [GameEngine sharedInstance].currentGame.player1Ships)
    {
        [ship fetchInBackgroundWithBlock:
            ^(PFObject *object, NSError *error)
            {
                [self placeShipOnMap:ship];
            }];
    }

    for (Ship* ship in [GameEngine sharedInstance].currentGame.player2Ships)
    {
        [ship fetchInBackgroundWithBlock:
           ^(PFObject *object, NSError *error)
            {
                [self placeShipOnMap:ship];
            }];
    }
}

- (void)placeShipOnMap:(Ship*)ship
{
	UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)]; // Set location below, rather than here
    
	[button setImage:[UIImage imageNamed:@"Token"] forState:UIControlStateNormal];
//	[button addTarget:self action:@selector(imageTouch:withEvent:) forControlEvents:UIControlEventTouchDown];
	[button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
	[button addTarget:self action:@selector(imageTapped:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
    
    button.center = [self.hexView pointFromOffsetX:ship.xLocation offsetY:ship.yLocation];

    // TODO: Should really encapsule the ugliness around this...
    self.buttonToShipLookup[[NSValue valueWithNonretainedObject:button]] = ship;
    [self.hexView addSubview:button];
}

- (void)loadGame
{
    // TODO: Move all this to GameEngine, or some store object, or ??
    Game* game = [Game objectWithoutDataWithObjectId:@"CcIpd41iJB"];
    [GameEngine sharedInstance].currentGame = game;
    
    [game fetchInBackgroundWithBlock:
         ^(PFObject *object, NSError *error)
         {
             // TODO: For now, we will just preload these. Really, should probably do something cleaner (synchronous?)
             [game.player1 fetchIfNeededInBackground];
             [game.player2 fetchIfNeededInBackground];

             [self addGamePieces];
        }];
}

- (IBAction) imageMoved:(UIButton*)sender withEvent:(UIEvent*)event
{
	// TODO: Add automatic scrolling when dragging to edge
	
	CGPoint point = [[[event allTouches] anyObject] locationInView:self.hexView];
	UIControl *control = sender;
	
	NSLog(@"Scroll view scale: %f", self.scrollView.zoomScale);
    
    NSIndexPath* path = [self.hexView roundToOffsetFromPixelCoordinates:point];
    
    // Get ship for the image
    Ship* ship = self.buttonToShipLookup[[NSValue valueWithNonretainedObject:sender]];
    
    // Move ship to this location
    ship.xLocation = path.section;
    ship.yLocation = path.row;
    [ship saveInBackground];
    
    // TODO: Here could call match's - saveCurrentTurnWithMatchData:completionHandler: to send updates to other player
	
	CGPoint quantizedPoint = [self.hexView pointFromOffsetX:path.section offsetY:path.row];
	
	// Convert point to coordinates of this view
	
	control.center = quantizedPoint;
}

- (IBAction) imageTapped:(id)sender withEvent:(UIEvent*)event
{
	UIControl *control = sender;
	
	// http://nshipster.com/uimenucontroller/
	// TODO: Management of this menu should perhaps be by the hex view, not the controller?
	
	[self.hexView becomeFirstResponder];
	
	UIMenuController* menu = [UIMenuController sharedMenuController];
	UIMenuItem* item = [[UIMenuItem alloc] initWithTitle:@"Edit" action:@selector(editChit)];
	menu.menuItems = @[item];
	[menu setTargetRect:control.frame inView:self.hexView];
	[menu setMenuVisible:YES animated:YES];
	
	// TODO: Hide menu when user taps outside the menu
}

- (void) editChit
{
	[self performSegueWithIdentifier:@"editChit" sender:nil];
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
	// By default iOS 7 lets individual controllers set the status bar style.
	return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)didPressMatchmaking:(id)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Title"
            message:@"Message"
            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"New Game"
            style:UIAlertActionStyleDefault
            handler:
                ^(UIAlertAction *action)
                {
                    [self showMatchingControllerForNewGame:YES];
                }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"View/Select Games"
            style:UIAlertActionStyleDefault
            handler:
                ^(UIAlertAction *action)
                {
                    [self showMatchingControllerForNewGame:NO];
                }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"End Turn"
            style:UIAlertActionStyleDefault
            handler:
                ^(UIAlertAction *action)
                {
                    [self endTurn];
                }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
            style:UIAlertActionStyleCancel
            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showMatchingControllerForNewGame:(BOOL)newGame
{
	GKMatchRequest *request = [[GKMatchRequest alloc] init];
	request.minPlayers = 2;
	request.maxPlayers = 2;
    request.inviteMessage = @"Please join me in a rousing game of Warp War!";
    
    // TODO: Can we turn on automatch?
    
    // BTW, default behavior is that if the user already in an active match, when this comes up it puts them in a UI to let them pick an active match.
 
    // TODO: Encapsulate within the GameEngine???
	GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.showExistingMatches = !newGame;
	mmvc.turnBasedMatchmakerDelegate = self;
 
	[self presentViewController:mmvc animated:YES completion:nil];
}

- (void)endTurn
{
    GKTurnBasedMatch* match = [GameEngine sharedInstance].currentMatch;
    
    [match endTurnWithNextParticipants:@[match.participants[1], match.participants[0]]
            turnTimeout:GKTurnTimeoutNone
            matchData:[@"matchData" dataUsingEncoding:NSUTF8StringEncoding]
            completionHandler:nil];
}

- (IBAction)didPressSaveGame:(id)sender
{
    [[GameEngine sharedInstance].currentGame save]; // TODO: Handle return value if needed
}

#pragma mark - UIScrollViewDelegate delegate methods

- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.hexView;
}

#pragma mark - GKTurnBasedMatchmakerViewControllerDelegate

// TODO: Move these delegate methods to own class, or GameEngine?

- (void)turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController *)viewController
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)match
{
	[self dismissViewControllerAnimated:YES completion:nil];
    
    // Also called when user selects on of the matches they are in (even if it's the current one).

    // TODO: Should really handle errors in completion block
    [GKNotificationBanner showBannerWithTitle:@"Selected/New Match!"
            message:[NSString stringWithFormat:@"Between %@ and %@", match.participants[0], match.participants[1]]
            completionHandler:nil];
    
    [GameEngine sharedInstance].currentMatch = match;
}

- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
	[self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"Error in %@: %@", NSStringFromSelector(_cmd), error);
}

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController playerQuitForMatch:(GKTurnBasedMatch *)match
{
    // Called when the user forfeits a match
    
	[self dismissViewControllerAnimated:YES completion:nil];
    
    // TODO: Need to call the quit-out-of-turn method here?
    
    [match participantQuitInTurnWithOutcome:GKTurnBasedMatchOutcomeQuit
            nextParticipants:@[match.participants[0]] // Is this safe? Is there some simpler way to do this?
            turnTimeout:GKTurnTimeoutNone
            matchData:[@"matchData" dataUsingEncoding:NSUTF8StringEncoding]
            completionHandler:nil];
}

@end