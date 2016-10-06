//
//  SearchOnMapViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/30/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "SearchOnMapViewController.h"

#import "SearchCustomAnnotation.h"
#import "SearchCustomAnnotationView.h"
#import "WashPageViewController.h"

@interface SearchOnMapViewController ()<SearchCustomAnnotationViewDelegate,MKMapViewDelegate>
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@end

@implementation SearchOnMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setDelegate:self];

    [self addAnnotations];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitle:@"Результаты поиска"];
}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, span) animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[SearchCustomAnnotation class]])
    {
        SearchCustomAnnotation *customAnnotation = (SearchCustomAnnotation*)annotation;
        SearchCustomAnnotationView *annotationView = (SearchCustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"searchAnnotationNewID"];
        annotationView.delegate = self;
        if(annotationView == nil)
        {
            annotationView = (SearchCustomAnnotationView*)customAnnotation.annotationView;
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
        SearchCustomAnnotationView *annotationView = (SearchCustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"searchAnnotationUserNewID"];
        
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

-(void)annotationView:(SearchCustomAnnotationView*)annotationView didClickPopupViewButton:(UIButton*)popupViewButton
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
    [self setTitle:@" "];
    [self.navigationController pushViewController:washPageViewController animated:YES];
}

-(void)addAnnotation:(NSDictionary*)dict index:(NSInteger)index
{
    CLLocationCoordinate2D coordinate = (CLLocationCoordinate2D){
        .latitude  = [dict[@"latitude" ] floatValue],
        .longitude = [dict[@"longitude"] floatValue]
    };

    SearchCustomAnnotation *customAnnotation  = [[SearchCustomAnnotation alloc] initWithTitle:[NSString stringWithFormat:@"%ld",index] location:coordinate foundTours:dict];
    [self.mapView addAnnotation:customAnnotation];
    if(index == self.index)
    {
        CLLocationCoordinate2D coordinateView = CLLocationCoordinate2DMake(customAnnotation.coordinate.latitude, customAnnotation.coordinate.longitude);
        MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
        [self.mapView setRegion:MKCoordinateRegionMake(coordinateView, span) animated:YES];
    }
}

-(void)addAnnotations
{
    for(NSDictionary *dict in self.arrayInfo)
    {
        NSInteger index = [self.arrayInfo indexOfObject:dict];
        [self addAnnotation:dict index:index];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
