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

- (id) initWithFrame:(CGRect)rect
{
	self = [super initWithFrame:rect];
	
	if (self)
	{
		CATiledLayer* tempTiledLayer = (CATiledLayer*)self.layer;
		tempTiledLayer.levelsOfDetail = 4;
		tempTiledLayer.levelsOfDetailBias = 4;
		self.opaque=YES;
	}
	
	return self;
}

- (void) drawRect:(CGRect)rect
{
	[self drawViewInContext:UIGraphicsGetCurrentContext() bounds:self.bounds];
}

- (void) drawViewInContext:(CGContextRef)context bounds:(CGRect)bounds
{
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0 ,1.0);
	CGContextFillRect(context,self.bounds);
	
	float size = 25;
	
	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
	
	CGPathRef hexPath = [self makeHexAt:CGPointMake(0,0) size:size context:context];
	
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

/*
- (void) drawLayer:(CALayer*)layer inContext:(CGContextRef)context
{
}
*/

+ (Class) layerClass
{
	return [CATiledLayer class];
}

@end