//
//  AKAnnotation.m
//  CapOneApp
//
//  Created by Ashwin Kumar on 3/7/15.
//  Copyright (c) 2015 Ashwin Kumar. All rights reserved.
//

#import "AKAnnotation.h"

@implementation AKAnnotation

- (id)initWithName:(NSString *)name
          orderNum:(int)orderNum
        coordinate:(CLLocationCoordinate2D)myCoordinate;
{
    if (self = [super init]) {
        self.coordinate = myCoordinate;
        self.title = name;
        self.orderNum = orderNum;
    }
    return self;

}

@end
