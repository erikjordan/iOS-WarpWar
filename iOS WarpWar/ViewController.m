//
//  ViewController.m
//  iOS WarpWar
//
//  Created by Erik Jordan on 10/4/13.
//  Copyright (c) 2013 Erik Jordan. All rights reserved.
//

#import "HexView.h"
#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet HexView *hexView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Using autolayout with the scroller seems to cause problems
	// http://stackoverflow.com/questions/13499467/uiscrollview-doesnt-use-autolayout-constraints
	
	self.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
	self.scrollView.minimumZoomScale = 0.5;
	self.scrollView.maximumZoomScale = 4.0;
	self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	// self.scrollView.contentSize = self.hexView.bounds.size; // Apparently don't need to do this anymore, but:
	// Need a constraint that binds all edges of the hex view to the scroll view parent. Then the conentSize property seems
	// to be set automatically.
}

#pragma mark - UIScrollViewDelegate delegate methods

- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.hexView;
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
	NSLog(@"New scale: %f", scale);
	
	// https://developer.apple.com/library/ios/documentation/windowsviews/conceptual/UIScrollView_pg/ZoomZoom/ZoomZoom.html
	// http://halmueller.wordpress.com/2008/10/08/a-very-simple-uiscrollview-demo/
	
	[self.hexView setNeedsDisplay];
	[self.scrollView setNeedsDisplay];
}


@end
