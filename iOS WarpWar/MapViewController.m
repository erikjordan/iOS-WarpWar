//
//  MapViewController.m
//  iOS WarpWar
//
//  Created by Erik Jordan on 10/4/13.
//  Copyright (c) 2013 Erik Jordan. All rights reserved.
//

#import "GameEngine.h"
#import <GameKit/GameKit.h>
#import "HexView.h"
#import "MapViewController.h"

@interface MapViewController ()

@property (nonatomic) HexView *hexView;
@property (nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
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
	
	UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(25, 25, 35, 35)];
	[button setImage:[UIImage imageNamed:@"Token"] forState:UIControlStateNormal];
//	[button addTarget:self action:@selector(imageTouch:withEvent:) forControlEvents:UIControlEventTouchDown];
	[button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
	[button addTarget:self action:@selector(imageTapped:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
	
	[self.hexView addSubview:button];
	
	UIButton* button2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 35, 35)];
	[button2 setImage:[UIImage imageNamed:@"Token2"] forState:UIControlStateNormal];
	[button2 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
	[button2 addTarget:self action:@selector(imageTapped:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
	
	[self.hexView addSubview:button2];
	
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

- (IBAction) imageMoved:(id)sender withEvent:(UIEvent*)event
{
	// TODO: Add automatic scrolling when dragging to edge
	
	CGPoint point = [[[event allTouches] anyObject] locationInView:self.hexView];
	UIControl *control = sender;
	
	NSLog(@"Scroll view scale: %f", self.scrollView.zoomScale);
	
	CGPoint quantizedPoint = [self.hexView roundToHexCenter:point];
	
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
	GKMatchRequest *request = [[GKMatchRequest alloc] init];
	request.minPlayers = 2;
	request.maxPlayers = 2;
 
	GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
	mmvc.turnBasedMatchmakerDelegate = self;
 
	[self presentViewController:mmvc animated:YES completion:nil];
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
}

- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController playerQuitForMatch:(GKTurnBasedMatch *)match
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end