//
//  HotelAnnotation.m
//  iTEZ
//
//  Created by Andrei Sabinin on 8/21/15.
//  Copyright (c) 2015 CookieDev. All rights reserved.
//

#import "CustomAnnotation.h"
#import "CustomAnnotationView.h"

@interface CustomAnnotation()

@end

@implementation CustomAnnotation

- (id)initWithTitle:(NSString*)newTitle location:(CLLocationCoordinate2D)location foundTours:(id)object
{
    self = [super init];
    if(self)
    {
        _title = newTitle;
        _coordinate = location;
        _object = object;
    }
    
    return self;
}

- (MKAnnotationView *)annotationView
{
    static NSString *annotatinIdentify = @"HotelAnnotationID";
    CustomAnnotationView *annotationView = [[CustomAnnotationView alloc] initWithAnnotation:self reuseIdentifier:annotatinIdentify];
    annotationView.object = _object;
    NSInteger typeCarWash = [_object[@"car_wash_type_id"] integerValue];
    switch (typeCarWash)
    {
        case 1:
        {
            annotationView.image = [UIImage imageNamed:@"sign_active_but_not_time"];
            break;
        }
        case 2:
        {
            annotationView.image = [UIImage imageNamed:@"sign_no_active"];
            break;
        }
        case 3:
        {
            annotationView.image = [UIImage imageNamed:@"sign_active"];
            break;
        }
        default:
            break;
    }
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = NO;
    
//    if(self.infoLabel == nil)
//    {
//        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(40., 0., annotationView.image.size.width - 40, annotationView.image.size.height)];
//    }
//    self.infoLabel.font = [UIFont systemFontOfSize:12];
//    self.infoLabel.text = _title;
//    
//    [annotationView addSubview:self.infoLabel];
    return annotationView;
}

@end
