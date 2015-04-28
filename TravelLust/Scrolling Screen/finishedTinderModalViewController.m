//
//  finishedTinderModalViewController.m
//  TravelLust
//
//  Created by Ashwin Kumar on 4/26/15.
//  Copyright (c) 2015 Ashwin Kumar. All rights reserved.
//

#import "finishedTinderModalViewController.h"
#import "YALFoldingTabBarController.h"

@implementation finishedTinderModalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.cornerRadius = 8.f;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.finishedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 255, 130)];
    self.finishedLabel.numberOfLines = 5;
    self.finishedLabel.textAlignment = NSTextAlignmentCenter;
    self.finishedLabel.font = [UIFont fontWithName:@"Avenir-Light" size:24];
    self.finishedLabel.textColor = [UIColor darkGrayColor];
    self.finishedLabel.text = @"You're done selecting your preferred places!";
    [self.view addSubview:self.finishedLabel];
    
    [self addDismissButton];
}

- (void)addDismissButton
{
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 190, 200, 50)];
    
    dismissButton.backgroundColor = [UIColor colorWithRed:72/255.0 green:176/255.0 blue:164/255.0 alpha:1];
    dismissButton.titleLabel.textColor = [UIColor whiteColor];
    dismissButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:20];
    dismissButton.layer.cornerRadius = 10;
    dismissButton.clipsToBounds = YES;
    [dismissButton setTitle:@"View Group Results" forState:UIControlStateNormal];


    [dismissButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.  view addSubview:dismissButton];
}

- (void)dismiss:(id)sender
{
    YALFoldingTabBarController *tabBarController = (YALFoldingTabBarController *)self.presentingViewController;
    [self dismissViewControllerAnimated:YES
                             completion:^{

                                 tabBarController.selectedIndex = 1;
                             }];
    

}

@end
