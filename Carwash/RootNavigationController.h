//
//  RootNavigationController.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/2/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RootNavigationControllerDelegate <NSObject>

@optional

-(void)successDismissedNavigationController;

@end

@interface RootNavigationController : UINavigationController

@property (weak, nonatomic) NSObject<RootNavigationControllerDelegate> *delegatePlus;

@end
