//
//  RootPageViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/1/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "RootPageViewController.h"
#import "Carwash-Swift.h"
#import "GetNearestRequest.h"
#import "WashPageViewController.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

//MKMap Classes
#import "CustomAnnotation.h"
#import "CustomAnnotationView.h"

@interface RootPageViewController ()<MKMapViewDelegate,CustomAnnotationViewDelegate>

@property (weak  , nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSArray *arrayData;

@property(assign, nonatomic) CGFloat lat;
@property(assign, nonatomic) CGFloat lon;
@property (nonatomic,assign) BOOL firstRun;
@end

@implementation RootPageViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lat = 0.01;
    self.lon = 0.01;

    self.mapView.delegate = self;

    self.arrayData = [@[] copy];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateLocation:) name:kLocationManagerUpdateLocationNotification object:nil];
    [self setupMapView];
    [self request];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *name = [NSString stringWithFormat:@"Pattern~%@", self.title];
    
    // The UA-XXXXX-Y tracker ID is loaded automatically from the
    // GoogleService-Info.plist by the `GGLContext` in the AppDelegate.
    // If you're copying this to an app just using Analytics, you'll
    // need to configure your tracking ID here.
    // [START screen_view_hit_objc]
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    // [END screen_view_hit_objc]
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateLocation:) name:kLocationManagerUpdateLocationNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setNavigationBarItem];
    [SVProgressHUD dismiss];
}

- (IBAction)onMeLocationButton:(id)sender
{
    CLLocation *location = [[LocationCore sharedMenager] getCurrentLocation];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    if(coordinate.latitude == 0 || coordinate.longitude == 0)
        coordinate = CLLocationCoordinate2DMake(52.721234, 41.451799);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, span) animated:YES];
    [self.mapView setShowsUserLocation:YES];

}

- (void)setupMapView
{
    CLLocation *location = [[LocationCore sharedMenager] getCurrentLocation];
    CLLocationCoordinate2D coordinate = location.coordinate;

    if(coordinate.latitude == 0 || coordinate.longitude == 0)
    {
        coordinate = CLLocationCoordinate2DMake(52.721234, 41.451799);
        [self performSelector:@selector(request) withObject:nil afterDelay:5.0];

    }

    if(self.firstRun == NO)
    {
        MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
        [self.mapView setRegion:MKCoordinateRegionMake(coordinate, span) animated:YES];
        [self.mapView setShowsUserLocation:YES];
        self.firstRun = YES;
    }
}

- (void)didUpdateLocation:(NSNotification*)notification
{
    [self setupMapView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self request];
}

-(void)request
{
    CLLocation *location = [[LocationCore sharedMenager] getCurrentLocation];
    CLLocationCoordinate2D coordinate = location.coordinate;
    if(coordinate.latitude == 0 || coordinate.latitude == 0)
    {
        coordinate = CLLocationCoordinate2DMake(52.721234, 41.451799);
    }

    
    [[GetNearestRequest alloc] getNearestByDistance:@500 lat:@(coordinate.latitude) lon:@(coordinate.longitude) completionHandler:^(NSDictionary *json)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.arrayData = json[@"data"];
            [self addAnnotations];
        });
    }
    errorHandler:
    ^{
//        CLLocationCoordinate2D coordinate = (CLLocationCoordinate2D){
//            .latitude  = 47.83,
//            .longitude = 35.14
//        };
//        
//        CustomAnnotation *customAnnotation  = [[CustomAnnotation alloc] initWithTitle:@"Test" location:coordinate foundTours:@{@"car_wash_type_id":@"3"}];
//        [self.mapView addAnnotation:customAnnotation];
    }];
}

-(IBAction)onPlusButton:(id)sender
{
    
    self.lat = self.lat / 2.f;
    self.lon = self.lat / 2.f;
    
    if(self.lat < 0.01) self.lat = 0.01;
    if(self.lon < 0.01) self.lon = 0.01;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(self.lat, self.lon);
    [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.region.center, span) animated:YES];
}

-(IBAction)onMinusButton:(id)sender
{
    self.lat = self.lat * 2.f;
    self.lon = self.lat * 2.f;
    if(self.lat > 90) self.lat = 90;
    if(self.lon > 90) self.lon = 90;

    MKCoordinateSpan span = MKCoordinateSpanMake(self.lat, self.lon);
    [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.region.center, span) animated:YES];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    MKCoordinateSpan span  = mapView.region.span;
    
    self.lat = span.latitudeDelta;
    self.lon = span.longitudeDelta;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, span) animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[CustomAnnotation class]])
    {
        CustomAnnotation *customAnnotation = (CustomAnnotation*)annotation;
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationID"];
        annotationView.delegate = self;
        if(annotationView == nil)
        {
            annotationView = (CustomAnnotationView*)customAnnotation.annotationView;
            annotationView.delegate = self;
        }
        else
        {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    else if ([annotation isKindOfClass:[MKUserLocation class]])
    {
//        CustomAnnotation *customAnnotation = (CustomAnnotation*)annotation;
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationUserID"];

        if(annotationView == nil)
        {
            annotationView.annotation = annotation;
        }
        else
        {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    else
    {
        return nil;
    }
}

-(void)addAnnotation:(NSDictionary*)dict
{
    CLLocationCoordinate2D coordinate = (CLLocationCoordinate2D){
        .latitude  = [dict[@"latitude" ] floatValue],
        .longitude = [dict[@"longitude"] floatValue]
    };
    
    CustomAnnotation *customAnnotation  = [[CustomAnnotation alloc] initWithTitle:dict[@"title"] location:coordinate foundTours:dict];
    [self.mapView addAnnotation:customAnnotation];
}

-(void)addAnnotations
{
    for (NSDictionary *dict in self.arrayData)
    {
        [self addAnnotation:dict];
    }
}

-(void)annotationView:(CustomAnnotationView *)annotationView didClickPopupViewButton:(UIButton *)popupViewButton
{
    NSDictionary *dict = (NSDictionary*)annotationView.object;
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"WashPage" bundle:nil];
    WashPageViewController *washPageViewController = [storyborad instantiateViewControllerWithIdentifier:@"WashPageViewController"];
    NSInteger typeCarWash = [dict[@"car_wash_type_id"] integerValue];
    if(typeCarWash == 1)
    {
        washPageViewController.isOfflineWash = YES;
    }
    washPageViewController.dictInfo = dict;
    [self.navigationController pushViewController:washPageViewController animated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
