//
//  iOS_WarpWarTests.m
//  iOS WarpWarTests
//
//  Created by Erik Jordan on 10/4/13.
//  Copyright (c) 2013 Erik Jordan. All rights reserved.
//

#import <Parse/Parse.h>
#import <XCTest/XCTest.h>

@interface iOS_WarpWarTests : XCTestCase

@end

@implementation iOS_WarpWarTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

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
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
