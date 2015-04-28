//
//  ANKScrollingViewCell.h
//  TravelLust
//
//  Created by Ashwin Kumar on 4/25/15.
//  Copyright (c) 2015 Ashwin Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSwipeTableViewCell.h"

@interface ANKScrollingViewCell : MCSwipeTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailedLabel;

@end