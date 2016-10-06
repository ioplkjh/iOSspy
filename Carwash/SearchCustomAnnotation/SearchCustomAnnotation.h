//
//  HotelAnnotation.h
//  iTEZ
//
//  Created by Andrei Sabinin on 8/21/15.
//  Copyright (c) 2015 CookieDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface SearchCustomAnnotation : NSObject < MKAnnotation >

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) id object;

- (id)initWithTitle:(NSString*)newTitle location:(CLLocationCoordinate2D)location foundTours:(id)object;
- (MKAnnotationView *)annotationView;

@end
