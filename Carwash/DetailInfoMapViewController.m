//
//  DetailInfoMapViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/25/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "DetailInfoMapViewController.h"

#import "CustomAnnotation.h"
#import "CustomAnnotationView.h"


@interface DetailInfoMapViewController ()<CustomAnnotationViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation DetailInfoMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self render];
    [self.infoLabel setText:@"Информация на карте"];
    [self addAnnotations];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitle:@"Ближайшая автомойка"];
}

-(void)render
{
    self.infoView.layer.cornerRadius = 5;
    self.infoView.clipsToBounds = YES;
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
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationNewID"];
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
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationUserNewID"];
        
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

-(void)annotationView:(CustomAnnotationView*)annotationView didClickPopupViewButton:(UIButton*)popupViewButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addAnnotation:(NSDictionary*)dict
{
    CLLocationCoordinate2D coordinate = (CLLocationCoordinate2D){
        .latitude  = [dict[@"latitude" ] floatValue],
        .longitude = [dict[@"longitude"] floatValue]
    };
    
    CustomAnnotation *customAnnotation  = [[CustomAnnotation alloc] initWithTitle:dict[@"title"] location:coordinate foundTours:dict];
    [self.mapView addAnnotation:customAnnotation];
    
    CLLocationCoordinate2D coordinateView = CLLocationCoordinate2DMake(customAnnotation.coordinate.latitude, customAnnotation.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    [self.mapView setRegion:MKCoordinateRegionMake(coordinateView, span) animated:YES];
}

-(void)addAnnotations
{
    [self addAnnotation:self.dictionaryInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
