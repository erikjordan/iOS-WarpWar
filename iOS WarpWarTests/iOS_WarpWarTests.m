//
//  iOS_WarpWarTests.m
//  iOS WarpWarTests
//
//  Created by Erik Jordan on 10/4/13.
//  Copyright (c) 2013 Erik Jordan. All rights reserved.
//

#import <Parse/Parse.h>
#import "Player.h"
#import <XCTest/XCTest.h>

@interface iOS_WarpWarTests : XCTestCase

@end

@implementation iOS_WarpWarTests

- (void)setupParse
{
    // Initialize Parse.
    [Parse setApplicationId:@"x3iSx1sQyIVwi6r4CKRPwo68M747RGUoDK7UgWNy"
                  clientKey:@"hjRYeWpu9nNE83yf3snbDXYUj5fHvzHBCn9Sn5hQ"];
 
    // [Optional] Track statistics around application opens.
    // [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

- (void)testParse
{
    [self setupParse];
    
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"erik";
    [testObject saveInBackgroundWithBlock:
        ^(BOOL succeeded, NSError *error)
        {
            [expectation fulfill];
        }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    NSLog(@"Done!");
}

- (void)testAddPlayer
{
    [self setupParse];
    
    Player* player = [Player object];
    player.name = @"Eddie";
    
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [player saveInBackgroundWithBlock:
        ^(BOOL succeeded, NSError *error)
        {
            [expectation fulfill];
        }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testGetPlayer
{
    [self setupParse];
    
    Player* player = [Player objectWithoutDataWithObjectId:@"2vsv6VwCox"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [player fetchInBackgroundWithBlock:
        ^(PFObject *object, NSError *error)
        {
            [expectation fulfill];
        }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    
    NSLog(@"Player: %@", player);
}

- (void)testUpdatePlayer
{
    [self setupParse];
    
    Player* player = [Player objectWithoutDataWithObjectId:@"2vsv6VwCox"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [player fetchInBackgroundWithBlock:
     ^(PFObject *object, NSError *error)
     {
         [expectation fulfill];
     }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];

    player.name = @"James H.";
    player.pointsAvailable = @(10);
    player.nickname = @"Pinky";
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [player saveInBackgroundWithBlock:
        ^(BOOL succeeded, NSError *error)
        {
            [expectation2 fulfill];
        }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}



@end
