//
//  Ship.h
//  iOS WarpWar
//
//  Created by Erik Jordan on 3/29/15.
//  Copyright (c) 2015 Erik Jordan. All rights reserved.
//

#import <Parse/Parse.h>

@interface Ship : PFObject

@property NSString* name;

@property NSUInteger xLocation;

@property NSUInteger yLocation;

@end
