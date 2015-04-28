//
//  MapScreenViewController.m
//  TravelLust
//
//  Created by Ashwin Kumar on 4/25/15.
//  Copyright (c) 2015 Ashwin Kumar. All rights reserved.
//

#import "MapScreenViewController.h"

#import "ContextMenuCell.h"
#import "YALContextMenuTableView.h"
#import "AKAnnotation.h"
#import <SpinKit/RTSpinKitView.h>
#import <POP/POP.h>
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "FinishedBookingModalViewController.h"

//#import "YALNavigationBar.h"
#define METERS_PER_MILE 1609.344
static NSString *const menuCellIdentifier = @"rotationCell";

@interface MapScreenViewController()
<
UITableViewDelegate,
UITableViewDataSource,
YALContextMenuTableViewDelegate,
MKMapViewDelegate,
UIViewControllerTransitioningDelegate
>

@property (nonatomic, strong) YALContextMenuTableView* contextMenuTableView;

@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuIcons;
@property (nonatomic, strong) NSMutableArray *myPlaces1;
@property (nonatomic, strong) NSMutableArray *myPlaces2;
@property (nonatomic, strong) NSMutableArray *myPlaces1Points;
@property (nonatomic, strong) NSMutableArray *myPlaces2Points;

//Spinner
@property (nonatomic, strong) RTSpinKitView *mainSpinner;
@property (strong, nonatomic) UIView *overlayView;

@property (strong, nonatomic) UIImageView *itineraryImageView;

@end

@implementation MapScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self constructOverlayView];
    self.itineraryLabel.text = @"";
    
    self.myPlaces1 = [[NSMutableArray alloc] init];
    self.myPlaces1Points = [[NSMutableArray alloc] init];
    
    self.myPlaces2 = [[NSMutableArray alloc] init];
    self.myPlaces2Points = [[NSMutableArray alloc] init];
    
    
    [self.itineraryScrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    self.itineraryScrollView.contentSize = CGSizeMake(540, 136);
    
    [self populatePlaces1];
    [self populatePoints1];
    
    [self initiateMenuOptions];
    [self setupMapView];


    
}

- (void)constructOverlayView
{
    // Construct the overlay view, to dim background when a mini-tableView pops up
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat overlayHeight = screenRect.size.height;
    
    UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, overlayHeight)];
    overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    self.overlayView = overlayView;
}

- (void)addLoadingScreen
{
    [self.view addSubview:self.overlayView];
    
    self.mainSpinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleCircleFlip color:[UIColor colorWithRed:.203 green:.77 blue:.646 alpha:1]];
    self.mainSpinner.center = self.view.center;
    [self.view addSubview:self.mainSpinner];
}

- (void)viewWillAppear:(BOOL)animated {
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 49.304338;
    zoomLocation.longitude= -123.127343;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 6.5*METERS_PER_MILE, 6.5*METERS_PER_MILE);
    
    // 3
    [_mapView setRegion:viewRegion animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self addLoadingScreen];
    [self performSelector:@selector(removeLoadingScreen) withObject:self afterDelay:3.0];
    
    [NSTimer scheduledTimerWithTimeInterval:4.0
                                     target:self
                                   selector:@selector(plotItinerary1)
                                   userInfo:nil repeats:NO];
}

- (void)removeLoadingScreen
{
    CGRect newFrame = CGRectMake(0, 0, 375, 0);
    self.overlayView.frame = newFrame;
    [self.mainSpinner removeFromSuperview];
}


- (void)setupMapView {
    self.mapView.delegate = self;
    
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
}

- (void)addItinerary1
{
    self.itineraryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 540, 136)];
    self.itineraryImageView.image = [UIImage imageNamed:@"timeline1"];
    [self.itineraryScrollView addSubview:self.itineraryImageView];
}

- (void)populatePlaces1
{
    NSDictionary *place4 = @{@"name": @"Club Shine",
                             @"stringLat": @49.284368,
                             @"stringLong": @-123.109769,
                             @"orderNum": @4};
    
    NSDictionary *place3 = @{@"name": @"Japadog",
                             @"stringLat": @49.282168,
                             @"stringLong": @-123.123725,
                             @"orderNum": @3};
    
    NSDictionary *place2 = @{@"name": @"Stanley Beach",
                             @"stringLat": @49.308635,
                             @"stringLong": @-123.139372,
                             @"orderNum": @2};

    NSDictionary *place1 = @{@"name": @"Capilano Bridge Park",
                             @"stringLat": @49.342983,
                             @"stringLong": @-123.114957,
                             @"orderNum": @1};
    
    [self.myPlaces1 addObject:place1];
    [self.myPlaces1 addObject:place2];
    [self.myPlaces1 addObject:place3];
    [self.myPlaces1 addObject:place4];
    
    
    // Myplaces2
    NSDictionary *place5 = @{@"name": @"Capilano Bridge Park",
                             @"stringLat": @49.342983,
                             @"stringLong": @-123.114957,
                             @"orderNum": @1};
    
    NSDictionary *place6 = @{@"name": @"Vancouver Sea Wall",
                             @"stringLat": @49.296042,
                             @"stringLong": @-123.128197,
                             @"orderNum": @2};
    
    NSDictionary *place7 = @{@"name": @"Vij’s Restaurant",
                             @"stringLat": @49.261613,
                             @"stringLong": @-123.138059,
                             @"orderNum": @3};
    
    NSDictionary *place8 = @{@"name": @"Narrow Lounge",
                             @"stringLat": @49.268383,
                             @"stringLong": @-123.100385,
                             @"orderNum": @4};
    
    [self.myPlaces2 addObject:place5];
    [self.myPlaces2 addObject:place6];
    [self.myPlaces2 addObject:place7];
    [self.myPlaces2 addObject:place8];
    
}

- (void)populatePoints1
{
    for (NSDictionary *businessDic in self.myPlaces1) {
        NSString *placeName = businessDic[@"name"];
        int orderNum = [businessDic[@"orderNum"] intValue];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [businessDic[@"stringLat"] doubleValue];
        coordinate.longitude = [businessDic[@"stringLong"] doubleValue];
        
        AKAnnotation *point = [[AKAnnotation alloc]
                               initWithName:placeName
                               orderNum:orderNum
                               coordinate:coordinate];
        
        [self.myPlaces1Points addObject:point];
    }
    
    for (NSDictionary *businessDic in self.myPlaces2) {
        NSString *placeName = businessDic[@"name"];
        int orderNum = [businessDic[@"orderNum"] intValue];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [businessDic[@"stringLat"] doubleValue];
        coordinate.longitude = [businessDic[@"stringLong"] doubleValue];
        
        AKAnnotation *point = [[AKAnnotation alloc]
                               initWithName:placeName
                               orderNum:orderNum
                               coordinate:coordinate];
        
        [self.myPlaces2Points addObject:point];
    }
}

- (void)plotItinerary2
{
    
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    
    [self.mapView removeOverlays:[self.mapView overlays]];

    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(startPlot2)
                                   userInfo:nil repeats:NO];
    
}

- (void)startPlot2
{
    for (AKAnnotation *annotation in self.myPlaces2Points) {
        NSLog(@"Addingannotation for %@", annotation);
        [self.mapView addAnnotation:annotation];
    }

    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(plotRoute2)
                                   userInfo:nil repeats:NO];
}

- (void)plotRoute2
{
    NSInteger pointsCount = self.myPlaces2Points.count;
    CLLocationCoordinate2D pointsToUse[pointsCount];
    
    for (int i = 0; i < pointsCount; i++) {
        AKAnnotation *annotation = self.myPlaces2Points[i];
        CLLocationCoordinate2D coord = [annotation coordinate];
        pointsToUse[i] = coord;
    }
    
    MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];
    [self.mapView addOverlay:myPolyline];
    self.itineraryImageView.image = [UIImage imageNamed:@"timeline2"];
    self.itineraryImageView.hidden = NO;
    self.overlayView.hidden = YES;
    self.mainSpinner.hidden = YES;
    self.itineraryLabel.text = @"Itinerary 2";
}



- (void)plotItinerary1
{
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    
    for (AKAnnotation *annotation in self.myPlaces1Points) {
        [self.mapView addAnnotation:annotation];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(startPlot1)
                                   userInfo:nil repeats:NO];
    
}

- (void)startPlot1
{
    NSInteger pointsCount = self.myPlaces1Points.count;
    CLLocationCoordinate2D pointsToUse[pointsCount];
    
    for (int i = 0; i < pointsCount; i++) {
        AKAnnotation *annotation = self.myPlaces1Points[i];
        CLLocationCoordinate2D coord = [annotation coordinate];
        pointsToUse[i] = coord;
    }
    
    MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];
    [self.mapView addOverlay:myPolyline];
    self.itineraryLabel.text = @"Itinerary 1";

    [self addItinerary1];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        
        renderer.strokeColor = [[UIColor orangeColor] colorWithAlphaComponent:0.7];
        renderer.lineWidth   = 5;
        
        return renderer;
    }
    
    return nil;
}

- (IBAction)presentMenuButtonTapped:(UIButton *)sender {
    // init YALContextMenuTableView tableView
    if (!self.contextMenuTableView) {
        self.contextMenuTableView = [[YALContextMenuTableView alloc]initWithTableViewDelegateDataSource:self];
        self.contextMenuTableView.animationDuration = 0.05;
        //optional - implement custom YALContextMenuTableView custom protocol
        self.contextMenuTableView.yalDelegate = self;
        
        //register nib
        UINib *cellNib = [UINib nibWithNibName:@"ContextMenuCell" bundle:nil];
        [self.contextMenuTableView registerNib:cellNib forCellReuseIdentifier:menuCellIdentifier];
    }
    
    // it is better to use this method only for proper animation
//    [self.contextMenuTableView showInView:self.navigationController.view withEdgeInsets:UIEdgeInsetsZero animated:YES];
    [self.contextMenuTableView showInView:self.view withEdgeInsets:UIEdgeInsetsZero animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[AKAnnotation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        AKAnnotation *annotationAK = (AKAnnotation *)annotation;
        NSString *orderNumStr = [NSString stringWithFormat:@"%d", annotationAK.orderNum];
        
        NSString *imageName = [NSString stringWithFormat:@"%@%@", @"pin", orderNumStr];
        annotationView.image = [UIImage imageNamed:imageName];
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - Local methods

- (void)initiateMenuOptions {
    self.menuTitles = @[@"",
                        @"",
                        @"",
                        @""];
    
    self.menuIcons = @[[UIImage imageNamed:@"xbutton2"],
                       [UIImage imageNamed:@"num1"],
                       [UIImage imageNamed:@"num2"],
                       [UIImage imageNamed:@"num3"]];
}


#pragma mark - YALContextMenuTableViewDelegate

- (void)contextMenuTableView:(YALContextMenuTableView *)contextMenuTableView
     didDismissWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        self.itineraryImageView.hidden = YES;
        [self constructOverlayView];
        [self addLoadingScreen];
        [self plotItinerary2];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(YALContextMenuTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView dismisWithIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(YALContextMenuTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];
    
    if (cell) {
        cell.backgroundColor = [UIColor clearColor];
        cell.menuTitleLabel.text = [self.menuTitles objectAtIndex:indexPath.row];
        cell.menuImageView.image = [self.menuIcons objectAtIndex:indexPath.row];
    }
    
    return cell;
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
    FinishedBookingModalViewController *modalViewController = [FinishedBookingModalViewController new];
    modalViewController.transitioningDelegate = self;
    modalViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:modalViewController
                       animated:YES
                     completion:^{
                         
                     }];
}
- (IBAction)bookPressed:(id)sender {
    [self presentFinishedTinderingView];
}

@end
