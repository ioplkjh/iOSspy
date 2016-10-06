//
//  HotelAnnotationView.h
//  iTEZ
//
//  Created by Andrei Sabinin on 8/21/15.
//  Copyright (c) 2015 CookieDev. All rights reserved.
//

#import <MapKit/MapKit.h>

@class CustomAnnotationView;

@protocol CustomAnnotationViewDelegate <NSObject>

@optional

-(void)annotationView:(CustomAnnotationView*)annotationView didClickPopupViewButton:(UIButton*)popupViewButton;

@end

@interface CustomAnnotationView : MKAnnotationView

@property (strong, nonatomic) UIButton *buttonCustomeCallOut;
@property (assign, nonatomic) NSObject<CustomAnnotationViewDelegate> *delegate;
@property (strong, nonatomic) id object;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
