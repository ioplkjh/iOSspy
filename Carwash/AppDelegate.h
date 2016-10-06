//
//  AppDelegate.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/1/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *pathRegions;
@property (strong, nonatomic) NSString *pathServices;

@property (strong, nonatomic) NSString *accessToken;

@end

