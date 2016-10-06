//
//  HotelAnnotationView.h
//  iTEZ
//
//  Created by Andrei Sabinin on 8/21/15.
//  Copyright (c) 2015 CookieDev. All rights reserved.
//

#import <MapKit/MapKit.h>

@class SearchCustomAnnotationView;

@protocol SearchCustomAnnotationViewDelegate <NSObject>

@optional

-(void)annotationView:(SearchCustomAnnotationView*)annotationView didClickPopupViewButton:(UIButton*)popupViewButton;

@end

@interface SearchCustomAnnotationView : MKAnnotationView

@property (strong, nonatomic) UIButton *buttonCustomeCallOut;
@property (assign, nonatomic) NSObject<SearchCustomAnnotationViewDelegate> *delegate;
@property (strong, nonatomic) id object;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
