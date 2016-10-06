//
//  LocationCore.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/6/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "LocationCore.h"

@interface LocationCore()<CLLocationManagerDelegate>

@property (nonatomic ,strong) CLLocation *currentCoordinates;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation LocationCore

static LocationCore *sharedInstance;

+ (LocationCore *)sharedMenager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [LocationCore new];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setLocation];
    }
    
    return self;
}

- (void)setLocation
{
    if(!self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate -

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *lastLoc = (CLLocation*)locations.lastObject;
    
    if(lastLoc.coordinate.latitude == 0 || lastLoc.coordinate.longitude == 0)
        return;
    else
    {
        self.currentCoordinates = lastLoc;
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationManagerUpdateLocationNotification object:self.currentCoordinates];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
}

- (CGFloat)calculateDistanceLat:(CLLocationDegrees)lat lon:(CLLocationDegrees)lon
{
    CLLocation *location      = [[CLLocation alloc] initWithLatitude:self.currentCoordinates.coordinate.latitude longitude:self.currentCoordinates.coordinate.longitude];
    CLLocation *fromLocation  = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    CLLocationDistance meters = [location distanceFromLocation:fromLocation];
    
//    CLLocation *locationGet = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
//    CGFloat distance = [self.currentCoordinates distanceFromLocation:locationGet];
    CGFloat returnedDist = meters/1000.0;
    return returnedDist;
}

- (CLLocation*)getCurrentLocation
{
    return self.currentCoordinates;
}

@end
