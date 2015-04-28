//
//  AKAnnotation.h
//  CapOneApp
//
//  Created by Ashwin Kumar on 3/7/15.
//  Copyright (c) 2015 Ashwin Kumar. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface AKAnnotation : MKPointAnnotation

@property int orderNum;

- (id)initWithName:(NSString *)name
          orderNum:(int)orderNum
        coordinate:(CLLocationCoordinate2D)myCoordinate;

@end
