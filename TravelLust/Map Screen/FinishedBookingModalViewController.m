//
//  FinishedBookingModalViewController.m
//  TravelLust
//
//  Created by Ashwin Kumar on 4/26/15.
//  Copyright (c) 2015 Ashwin Kumar. All rights reserved.
//

#import "FinishedBookingModalViewController.h"

@implementation FinishedBookingModalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.cornerRadius = 8.f;
//    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgg2"]];
    
    self.bookedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 255, 130)];
    self.bookedLabel.numberOfLines = 3;
    self.bookedLabel.textAlignment = NSTextAlignmentCenter;
    self.bookedLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:24];
    self.bookedLabel.textColor = [UIColor whiteColor];
    self.bookedLabel.text = @"Your itinerary has been booked!";
    [self.view addSubview:self.bookedLabel];

}

@end
