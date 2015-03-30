//
//  HexView.m
//  iOS WarpWar
//
//  Created by Erik Jordan on 10/5/13.
//  Copyright (c) 2013 Erik Jordan. All rights reserved.
//

#import "HexView.h"

/*
Drawing options:
 Quartz 2D, part of Core Graphics (CG)
 OpenGL
 UIKit has some drawing objects that wrap the CG/Quartz stuff
*/

// Help with hexes
// MAIN ARTICLE WE'RE USING: http://www.redblobgames.com/grids/hexagons/
// http://blog.ruslans.com/2011/02/hexagonal-grid-math.html
// http://devmag.org.za/2013/08/31/geometry-with-hex-coordinates/
// http://www.gamedev.net/page/resources/_/technical/game-programming/coordinates-in-hexagon-based-tile-maps-r1800

// TODO: Optimize out all the constant sqrts
// NOTE: We assume a zero-based count for rows/columns coordinates
// NOTE: We are doing an "even-q" vertical layout

float size = 25.0;
int columns = 15;
int rows = 22;

@implementation HexView

- (id) initWithFrame:(CGRect)rect
{
	self = [super initWithFrame:rect];
	
	if (self)
	{
		CATiledLayer* tempTiledLayer = (CATiledLayer*)self.layer;
		tempTiledLayer.levelsOfDetail = 3;				// How many levels total
		tempTiledLayer.levelsOfDetailBias = 1;		// How many of the levels are magnification
		
		self.opaque = YES;
		
		CGFloat width = (columns + 0.34) * size * 2.0 * 3.0 / 4.0; // TODO: why the fudge from 0.25 -> 0.34?
		CGFloat height = (rows + 0.5) * size * sqrt(3.0);
		self.frame = CGRectMake(0, 0, width, height);
	}
	
	return self;
}

- (CGPathRef) makeHexAt:(CGPoint)center size:(float)size context:(CGContextRef)context
{
	CGContextBeginPath(context);
	
	for (int vertex = 0; vertex < 6; vertex++)
	{
    float angle = 2 * M_PI / 6 * vertex;
    float x_i = center.x + size * cos(angle);
    float y_i = center.y + size * sin(angle);
		if (0 == vertex)
		{
			CGContextMoveToPoint(context, x_i, y_i);
		}
		else
		{
			CGContextAddLineToPoint(context, x_i, y_i);
		}
	}
	CGContextClosePath(context);
	
	CGPathRef path = CGContextCopyPath(context);
	return path;
}

- (void) drawLayer:(CALayer*)layer inContext:(CGContextRef)context
{
	CGContextSetRGBFillColor(context, 0.7, 0.7, 1.0 ,1.0);
	CGContextFillRect(context,self.bounds);
	
	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
	
	CGPathRef hexPath = [self makeHexAt:CGPointMake(0,0) size:size context:context];
	
	float width = size * 2.0;
	float height = sqrt(3.0) / 2.0 * width;
	
	float horizontalSpacing = 3.0 / 4.0 * width;
	float verticalSpacing = height;
	
	//	CGContextScaleCTM(context, 0.55, 0.55);
	
	CGContextTranslateCTM(context, -1.0 / 4.0 * width, 0);
	
	for (int column = 0; column < columns; column++)
	{
		CGContextTranslateCTM(context, horizontalSpacing, 0);
		for (int row = 0; row < rows; row++)
		{
			CGContextTranslateCTM(context, 0, verticalSpacing);
			
			CGContextBeginPath(context);
			CGContextAddPath(context, hexPath);
			CGContextStrokePath(context);
		}
		
		float verticalOffset = 0;
		if (column % 2 == 0)
		{
			verticalOffset = verticalSpacing * rows + (0.5 * height);
		}
		else
		{
			verticalOffset = verticalSpacing * rows - (0.5 * height);
		}
		CGContextTranslateCTM(context, 0, -verticalOffset);
	}
}

- (CGPoint) roundToHexCenter:(CGPoint)point
{
    NSIndexPath* path = [self roundToOffsetFromPixelCoordinates:point];

    // Convert back into pixel location (TODO To do this don't really need to convert to offset location, above. Could probably just work in axial coordinates, as article recommends. But, we would need to figure out how to do the pinning to map dimensions with axial coordinates).
    return [self pointFromOffsetX:path.section offsetY:path.row];
}

// TODO: This conversion maybe shouldn't be in map, because requires use of model objects
// Maybe we need a "map" object on top of the view.
- (NSIndexPath*)roundToOffsetFromPixelCoordinates:(CGPoint)point
{
	// TODO These should be global constants, methods, or inlines or macros or somesuch
	float width = size * 2.0;
	float height = sqrt(3.0) / 2.0 * width;
	
	// Adjust point to get rounding to work right
	CGPoint sourcePoint = CGPointMake(point.x - size, point.y - height);

	// Convert pixel to hex position
	float q = 2.0 / 3.0 * sourcePoint.x / size;
	float r = ((-1.0 / 3.0 * sourcePoint.x) + (1.0 / 3.0 * sqrt(3.0) * sourcePoint.y)) / size;
	
	// Round, adjust the hex position (in axial coordinates)
	long qlong = lroundf(q);
	long rlong = lroundf(r);
	
	NSLog(@"Axial(q, r): %ld, %ld", qlong, rlong);

	// Convert axial to cube coordinates
	long cubex = qlong;
	long cubez = rlong;
	// long cubey = -cubex-cubez; Not needed for subsequent calculations.
	
	// Convert cube to even-q offset coordinates and pin to map dimensions
	long offsetx = MIN(MAX(cubex, 0), columns - 1);
	long offsety = MIN(MAX(cubez + (cubex + (cubex & 1)) / 2, 0), rows - 1);
	
	NSLog(@"Offset(x, y): %ld, %ld", offsetx, offsety);

    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:offsety inSection:offsetx];
    
    return indexPath;
}

- (CGPoint)pointFromOffsetX:(NSUInteger)offsetX offsetY:(NSUInteger)offsetY
{
    // TODO These should be global constants, methods, or inlines or macros or somesuch
    float width = size * 2.0;
    float height = sqrt(3.0) / 2.0 * width;

    float x = (size * 3.0 / 2.0 * offsetX) + size;
	float y = (size * sqrt(3.0) * (offsetY - 0.5 * (offsetX & 1))) + height;
	
	NSLog(@"Pixel(x, y): %f, %f", x, y);

	return CGPointMake(x, y);
}

+ (Class) layerClass
{
	return [CATiledLayer class];
}

- (BOOL)canBecomeFirstResponder
{
	return YES;
}

@end