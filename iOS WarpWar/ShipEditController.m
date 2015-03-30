//
//  ShipEditController.m
//  iOS WarpWar
//
//  Created by Erik Jordan on 11/30/14.
//  Copyright (c) 2014 Erik Jordan. All rights reserved.
//

#import "ShipEditController.h"

@interface ShipEditController ()

// UI Elements
@property (weak, nonatomic) IBOutlet UILabel *powerDriveLabel;
@property (weak, nonatomic) IBOutlet UILabel *beamsLabel;
@property (weak, nonatomic) IBOutlet UILabel *screensLabel;
@property (weak, nonatomic) IBOutlet UILabel *tubesLabel;
@property (weak, nonatomic) IBOutlet UILabel *missilesLabel;
@property (weak, nonatomic) IBOutlet UILabel *systemshipRacksLabel;

@property (weak, nonatomic) IBOutlet UIStepper *powerDriveStepper;
@property (weak, nonatomic) IBOutlet UIStepper *beamsStepper;
@property (weak, nonatomic) IBOutlet UIStepper *screensStepper;
@property (weak, nonatomic) IBOutlet UIStepper *tubesStepper;
@property (weak, nonatomic) IBOutlet UIStepper *missilesStepper;
@property (weak, nonatomic) IBOutlet UIStepper *systemshipRacksStepper;

@property (weak, nonatomic) IBOutlet UISwitch *warpGeneratorSwitch;
@property (nonatomic) UILabel* pointsLeftLabel;

// Data elements
@property NSUInteger remainingPoints;
@property NSUInteger availableBuildPoints;
@property NSMapTable* stepperLabel;

@end

@implementation ShipEditController

-(void)viewDidLoad
{
	[super viewDidLoad];
	
	self.availableBuildPoints = 10;
	self.remainingPoints = 10;
	
	// Set up map of steppers to related text labels
	self.stepperLabel = [NSMapTable weakToWeakObjectsMapTable];
	[self.stepperLabel setObject:self.powerDriveLabel forKey:self.powerDriveStepper];
	[self.stepperLabel setObject:self.beamsLabel forKey:self.beamsStepper];
	[self.stepperLabel setObject:self.screensLabel forKey:self.screensStepper];
	[self.stepperLabel setObject:self.tubesLabel forKey:self.tubesStepper];
	[self.stepperLabel setObject:self.missilesLabel forKey:self.missilesStepper];
	[self.stepperLabel setObject:self.systemshipRacksLabel forKey:self.systemshipRacksStepper];
	
	self.pointsLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
	self.pointsLeftLabel.font = [UIFont systemFontOfSize:12];
	self.pointsLeftLabel.text = [NSString stringWithFormat:@"Remaining Build Points: %lu", (unsigned long)self.availableBuildPoints];
	
	UIView* infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
	[infoView addSubview:self.pointsLeftLabel];
	
	UIBarButtonItem* barItem = [[UIBarButtonItem alloc] initWithCustomView:infoView];
	
	self.toolbarItems = @[barItem];
}

- (IBAction)didPressPowerDriveStepper:(UIStepper *)sender
{
	// Adjust the attribute user tapped
	int value = sender.value;
	UILabel* label = [self.stepperLabel objectForKey:sender];
	label.text = [NSString stringWithFormat:@"%d", value];
	
	[self adjustUI];
}

- (void) adjustUI
{
	// Adjust the remaining build points count
	self.remainingPoints = self.availableBuildPoints - [self totalPointsSpent];
	self.pointsLeftLabel.text = [NSString stringWithFormat:@"Remaining Build Points: %lu", (unsigned long)self.remainingPoints];
	
	// Reset the max values for all steppers
	NSEnumerator *enumerator = [self.stepperLabel keyEnumerator];
	UIStepper* stepper;
	while ((stepper = [enumerator nextObject]))
	{
		stepper.maximumValue =  stepper.value +
				(stepper == self.missilesStepper
						? self.remainingPoints * 3.0
						: self.remainingPoints);
	}
	NSLog(@"Missiles - value: %f, max: %f", self.missilesStepper.value, self.missilesStepper.maximumValue);
	
	// Enable, disable warp generator based on remaining points
	self.warpGeneratorSwitch.enabled = (self.warpGeneratorSwitch.isOn ||
		self.remainingPoints >= 5);
}

- (IBAction)didChangeWarpGeneratorSwitch:(id)sender
{
	[self adjustUI];
}

-(NSUInteger) totalPointsSpent
{
	return self.powerDriveStepper.value +
			self.beamsStepper.value +
			self.screensStepper.value +
			self.tubesStepper.value +
			(self.missilesStepper.value / 3.0) +
			self.systemshipRacksStepper.value +
			(self.warpGeneratorSwitch.isOn
					? 5
					: 0);
}

@end
