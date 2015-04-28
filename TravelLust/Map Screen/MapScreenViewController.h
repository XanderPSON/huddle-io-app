//
//  MapScreenViewController.h
//  TravelLust
//
//  Created by Ashwin Kumar on 4/25/15.
//  Copyright (c) 2015 Ashwin Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

@interface MapScreenViewController : UIViewController
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIScrollView *itineraryScrollView;
@property (weak, nonatomic) IBOutlet UILabel *itineraryLabel;

@end
