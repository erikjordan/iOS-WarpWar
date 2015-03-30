//
//  HexView.h
//  iOS WarpWar
//
//  Created by Erik Jordan on 10/5/13.
//  Copyright (c) 2013 Erik Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HexView : UIView

// TODO: May not be needed any more.
- (CGPoint) roundToHexCenter:(CGPoint)point;

- (NSIndexPath*)roundToOffsetFromPixelCoordinates:(CGPoint)point;

- (CGPoint)pointFromOffsetX:(NSUInteger)offsetX offsetY:(NSUInteger)offsetY;

@end
