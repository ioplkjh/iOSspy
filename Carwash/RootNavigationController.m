//
//  RootNavigationController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/2/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "RootNavigationController.h"

@interface RootNavigationController ()

@end

@implementation RootNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:completion];
    
    if( [self.delegatePlus respondsToSelector:@selector(successDismissedNavigationController)])
    {
        [self.delegatePlus successDismissedNavigationController];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
