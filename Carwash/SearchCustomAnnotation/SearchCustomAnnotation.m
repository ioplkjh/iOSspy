//
//  HotelAnnotation.m
//  iTEZ
//
//  Created by Andrei Sabinin on 8/21/15.
//  Copyright (c) 2015 CookieDev. All rights reserved.
//

#import "SearchCustomAnnotation.h"
#import "SearchCustomAnnotationView.h"


@interface SearchCustomAnnotation()

@end

@implementation SearchCustomAnnotation

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
    static NSString *annotatinIdentify = @"SearchAnnotationID";
    SearchCustomAnnotationView *annotationView = [[SearchCustomAnnotationView alloc] initWithAnnotation:self reuseIdentifier:annotatinIdentify];
    annotationView.object = _object;
    NSInteger typeCarWash = [_object[@"car_wash_type_id"] integerValue];
    switch (typeCarWash)
    {
        case 1:
        {
            annotationView.image = [UIImage imageNamed:@"sign_active_but_not_time_clear"];
            break;
        }
        case 2:
        {
            annotationView.image = [UIImage imageNamed:@"sign_no_active_clear"];
            break;
        }
        case 3:
        {
            annotationView.image = [UIImage imageNamed:@"sign_active_clear"];
            break;
        }
        default:
            break;
    }
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = NO;
    
    if(self.infoLabel == nil)
    {
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., annotationView.image.size.width, annotationView.image.size.height-5)];
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        self.infoLabel.backgroundColor = [UIColor clearColor];
        self.infoLabel.textColor = [UIColor whiteColor];

    }
    self.infoLabel.font = [UIFont systemFontOfSize:18];
    self.infoLabel.text = _title;
    
    [annotationView addSubview:self.infoLabel];
    return annotationView;
}

@end
