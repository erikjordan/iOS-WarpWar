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

@implementation HexView

- (void) drawRect:(CGRect)rect
{
	// TODO: Should restrict redrawing to rect passed in
	// TODO: Should redraw opaque if the view set that way
	
	float size = 25;

	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[[UIColor blackColor] setStroke];
	
	UIBezierPath* hexPath = [self makeHexAt:CGPointMake(0,0) size:size];
	
	float width = size * 2.0;
	float height = sqrt(3.0) / 2.0 * width;
	
	float horizontalSpacing = 3.0 / 4.0 * width;
	float verticalSpacing = height;
	
	CGContextScaleCTM(context, 0.55, 0.55);
	
	CGContextTranslateCTM(context, -1.0 / 4.0 * width, 0.5 * height);
	
	int columns = 20;
	int rows = 22;
	
	for (int column = 0; column < columns; column++)
	{
		CGContextTranslateCTM(context, horizontalSpacing, 0);
		for (int row = 0; row < rows; row++)
		{
			CGContextTranslateCTM(context, 0, verticalSpacing);
			[hexPath stroke];
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

- (UIBezierPath*) makeHexAt:(CGPoint)center size:(float)size
{
	UIBezierPath* hexPath = [UIBezierPath bezierPath];
	
	for (int vertex = 0; vertex < 6; vertex++)
	{
    float angle = 2 * M_PI / 6 * vertex;
    float x_i = center.x + size * cos(angle);
    float y_i = center.y + size * sin(angle);
		if (0 == vertex)
		{
			[hexPath moveToPoint:CGPointMake(x_i, y_i)];
		}
		else
		{
			[hexPath addLineToPoint:CGPointMake(x_i, y_i)];
		}
	}
	[hexPath closePath];

	hexPath.lineWidth = 0.5;
	
	return hexPath;
}

@end