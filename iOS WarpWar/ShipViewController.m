//
//  ShipViewController.m
//  iOS WarpWar
//
//  Created by Erik Jordan on 11/30/14.
//  Copyright (c) 2014 Erik Jordan. All rights reserved.
//

#import "ShipViewController.h"

@interface ShipViewController ()

@property (weak, nonatomic) IBOutlet UILabel *powerDriveLabel;
@property (weak, nonatomic) IBOutlet UILabel *WarpGeneratorLabel;
@property (weak, nonatomic) IBOutlet UILabel *beamsLabel;
@property (weak, nonatomic) IBOutlet UILabel *screensLabel;
@property (weak, nonatomic) IBOutlet UILabel *tubesLabel;
@property (weak, nonatomic) IBOutlet UILabel *missilesLabel;
@property (weak, nonatomic) IBOutlet UILabel *systemshipRacksLabel;
@property (weak, nonatomic) IBOutlet UILabel *techLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildPointCostLabel;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end

@implementation ShipViewController

- (IBAction)didPressDone:(id)sender
{
	[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	self.navigationItem.title = @"Warpship W1";
	self.powerDriveLabel.text = @"10 / 20";
}

@end
