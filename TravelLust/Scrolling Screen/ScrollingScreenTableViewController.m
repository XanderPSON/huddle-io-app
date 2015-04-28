//
//  ScrollingScreenTableViewController.m
//  TravelLust
//
//  Created by Ashwin Kumar on 4/25/15.
//  Copyright (c) 2015 Ashwin Kumar. All rights reserved.
//

#import "ScrollingScreenTableViewController.h"
#import "ANKScrollingViewCell.h"
#import "finishedTinderModalViewController.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"

#import "YALTabBarItem.h"

//controller
#import "YALFoldingTabBarController.h"

//helpers
#import "YALAnimatingTabBarConstants.h"

static NSUInteger const kMCNumItems = 4;

@interface ScrollingScreenTableViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, assign) NSUInteger nbItems;
@property (strong, nonatomic) NSMutableArray *myPlaces;
@end

@implementation ScrollingScreenTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myPlaces = [[NSMutableArray alloc] init];
    self.nbItems = kMCNumItems;
//    [self setupYALTabBarController];    
    
    [self populatePlaces];
}

- (void)populatePlaces
{
    NSDictionary *place1 = @{@"placeName": @"Capilano Suspension Bridge Park",
                             @"placeDescription": @"A cliff walk in the West Coast's rain forest",
                             @"priceLabel": @"$0-15",
                             @"pic0": [UIImage imageNamed:@"travelpic1a"]};
    
    NSDictionary *place2 = @{@"placeName": @"Japadog",
                             @"placeDescription": @"Spicy cheese and avocado dogs...mmm",
                             @"priceLabel": @"$10-20",
                             @"pic0": [UIImage imageNamed:@"travelpic2a"]};
    
    NSDictionary *place3 = @{@"placeName": @"Stanley Beach Drum Circle",
                             @"placeDescription": @"Salute the sun with Vancouver hippies at dusk",
                             @"priceLabel": @"$10-20",
                             @"pic0": [UIImage imageNamed:@"travelpic3a"]};
    
    NSDictionary *place4 = @{@"placeName": @"Club Shine",
                             @"placeDescription": @"A hip happen’ club for the young folk!",
                             @"priceLabel": @"$0-40",
                             @"pic0": [UIImage imageNamed:@"travelpic4a"]};
    
    NSDictionary *place5 = @{@"placeName": @"Vancouver Seawall",
                             @"placeDescription": @"View Vancouver’s beautiful seaside scenery",
                             @"priceLabel": @"$0-40",
                             @"pic0": [UIImage imageNamed:@"travelpic5a"]};
    
    NSDictionary *place6 = @{@"placeName": @"Vij’s Restaurant",
                             @"placeDescription": @"A top-notch restaurant famous for its Indian herbs and spices",
                             @"priceLabel": @"$0-40",
                             @"pic0": [UIImage imageNamed:@"travelpic6a"]};
    
    NSDictionary *place7 = @{@"placeName": @"Narrow Lounge",
                             @"placeDescription": @"Vancouver’s premiere yuppie lounge",
                             @"priceLabel": @"$0-40",
                             @"pic0": [UIImage imageNamed:@"travelpic7a"]};

    [self.myPlaces addObject:place1];
    [self.myPlaces addObject:place2];
    [self.myPlaces addObject:place3];
    [self.myPlaces addObject:place4];
    [self.myPlaces addObject:place5];
    [self.myPlaces addObject:place6];
    [self.myPlaces addObject:place7];
}

#pragma mark - Tableview Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.myPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ANKScrollingViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[ANKScrollingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    [self configureCell:cell indexPath:indexPath];
    return cell;

}

- (void)configureCell:(ANKScrollingViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    NSDictionary *placeDic = [self.myPlaces objectAtIndex:indexPath.row];
    
    UIView *checkView    = [self viewWithImageName:@"check"];
    UIColor *greenColor  = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
    UIView *crossView    = [self viewWithImageName:@"cross"];
    UIColor *redColor    = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];

    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    cell.myImageView.image = [placeDic objectForKey:@"pic0"];
    cell.mainLabel.text = [placeDic objectForKey:@"placeName"];
    cell.detailedLabel.text = [placeDic objectForKey:@"placeDescription"];
    cell.delegate = self;

    [cell setSwipeGestureWithView:checkView color:greenColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        
        [self.myPlaces removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];                
        [self.tableView reloadData];
        [self checkForFinished];
    }];
    
    [cell setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        
        [self.myPlaces removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
        [self checkForFinished];
    }];
}

#pragma mark - Tableview Delegate

- (void)checkForFinished
{
    if (self.myPlaces.count == 0) {
        [self presentFinishedTinderingView];
    }
}

#pragma mark - Other

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [PresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}

- (void)presentFinishedTinderingView
{
    finishedTinderModalViewController *modalViewController = [finishedTinderModalViewController new];
    modalViewController.transitioningDelegate = self;
    modalViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:modalViewController
                       animated:YES
                     completion:^{

                     }];
}


//- (void)setupYALTabBarController {
//    YALFoldingTabBarController *tabBarController = (YALFoldingTabBarController *)[[UIApplication sharedApplication] mainWindow];
//    
//    self.window.rootViewController;
//    
//    //prepare leftBarItems
//    YALTabBarItem *item1 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"nearby_icon"]
//                                                      leftItemImage:nil
//                                                     rightItemImage:nil];
//    
//    
//    YALTabBarItem *item2 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"profile_icon"]
//                                                      leftItemImage:[UIImage imageNamed:@"edit_icon"]
//                                                     rightItemImage:nil];
//    
//    tabBarController.leftBarItems = @[item1, item2];
//    
//    //prepare rightBarItems
//    YALTabBarItem *item3 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"chats_icon"]
//                                                      leftItemImage:[UIImage imageNamed:@"search_icon"]
//                                                     rightItemImage:[UIImage imageNamed:@"new_chat_icon"]];
//    
//    
//    YALTabBarItem *item4 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"settings_icon"]
//                                                      leftItemImage:nil
//                                                     rightItemImage:nil];
//    
//    tabBarController.rightBarItems = @[item3, item4];
//    
//    tabBarController.centerButtonImage = [UIImage imageNamed:@"plus_icon"];
//    
//    tabBarController.selectedIndex = 0;
//    
//    
//    //customize tabBarView
//    tabBarController.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight;
//    tabBarController.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset;
//    //    tabBarController.tabBarView.backgroundColor = [UIColor colorWithRed:94.0/255.0 green:91.0/255.0 blue:149.0/255.0 alpha:1];
//    tabBarController.tabBarView.backgroundColor = [UIColor clearColor];
//    //    tabBarController.tabBarView.tabBarColor = [UIColor colorWithRed:72.0/255.0 green:211.0/255.0 blue:178.0/255.0 alpha:1];
//    //    tabBarController.tabBarView.tabBarColor = [UIColor colorWithRed:226.0/255.0 green:122.0/255.0 blue:30.0/255.0 alpha:1];
//    tabBarController.tabBarView.tabBarColor = [UIColor colorWithRed:61.0/255.0 green:175.0/255.0 blue:164.0/255.0 alpha:1];
//    //    tabBarController.tabBarViewHeight = YALTabBarViewDefaultHeight;
//    tabBarController.tabBarViewHeight = 70.0;
//    tabBarController.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets;
//    tabBarController.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets;
//}



@end
