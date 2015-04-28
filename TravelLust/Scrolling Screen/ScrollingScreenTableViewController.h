//
//  ScrollingScreenTableViewController.h
//  TravelLust
//
//  Created by Ashwin Kumar on 4/25/15.
//  Copyright (c) 2015 Ashwin Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSwipeTableViewCell.h"

@interface ScrollingScreenTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MCSwipeTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
