//
//  LocationCore.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/6/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationCore : NSObject

+ (LocationCore *)sharedMenager;
- (CLLocation*)getCurrentLocation;
- (CGFloat)calculateDistanceLat:(CLLocationDegrees)lat lon:(CLLocationDegrees)lon;

@end
