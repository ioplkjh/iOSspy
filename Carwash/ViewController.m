//
//  ViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/1/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "ViewController.h"
#import "RegisterViewController.h"
#import "RootPageViewController.h"
#import "RightMenuViewController.h"
#import "RootNavigationController.h"

#import "Carwash-Swift.h"

#import "GetAllRegionRequest.h"
#import "GetServicesRequest.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface ViewController ()<RootNavigationControllerDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) SlideMenuController *slideMenuController;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) RootNavigationController *registerNavigationController;
@property (nonatomic, assign) BOOL afterLogin;
@property (nonatomic, assign) BOOL isEnableAuroRegister;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [LocationCore sharedMenager];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeMainController) name:@"closeMainController" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *name = [NSString stringWithFormat:@"Pattern~%@", self.title];
    
    // The UA-XXXXX-Y tracker ID is loaded automatically from the
    // GoogleService-Info.plist by the `GGLContext` in the AppDelegate.
    // If you're copying this to an app just using Analytics, you'll
    // need to configure your tracking ID here.
    // [START screen_view_hit_objc]
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    // [END screen_view_hit_objc]
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.isEnableAuroRegister = [[NSUserDefaults standardUserDefaults] boolForKey:@"isEnableAuroRegister"        ];
    self.afterLogin = self.isEnableAuroRegister;
    __block BOOL afterLoginBlock = self.afterLogin;
    [[GetAllRegionRequest alloc] getAllRegionRequestWithCompletionHandler:^(NSDictionary *json)
     {
         NSArray *regionsResporce = json[@"data"];
         
         //save data
         AppDelegate *appDel = SharedAppDelegate;
//         NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile:appDel.pathRegions];
         NSMutableArray *regionsArray = [@[] mutableCopy];
         
         for(NSDictionary *dict in regionsResporce)
         {
             [regionsArray addObject:@{
                                       @"id":dict[@"id"],
                                       @"region":dict[@"region"]
                                       }];
         }
         
         NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: appDel.pathRegions];
         
         [data setObject:[regionsArray copy] forKey:@"Regions"];
         [data writeToFile: appDel.pathRegions atomically:YES];
         
         if(afterLoginBlock)
         {
             [self openMainScreen];
         }
         else
         {
             [self registerScreen:YES];
         }
     } errorHandler:^{
         [self registerScreen:NO];
     }];
}

-(void)registerScreen:(BOOL)isSuccess
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
    self.registerNavigationController  = [storyboard instantiateViewControllerWithIdentifier:@"RegisterNavigationController"];
    self.registerNavigationController.delegatePlus = self;
    [self presentViewController:self.registerNavigationController animated:NO completion:^{
        
    }];
}

-(void)openMainScreen
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    UIStoryboard *rootPageStoryboard = [UIStoryboard storyboardWithName:@"RootPage" bundle: nil];
    UINavigationController *navigationController = [rootPageStoryboard instantiateViewControllerWithIdentifier:@"RootNavigationController"];
    ///////
    
    //Menu
    UIStoryboard *storyboardSideMenu = [UIStoryboard storyboardWithName:@"RightMenu" bundle:nil];
    LeftViewController *leftViewController = [storyboardSideMenu instantiateViewControllerWithIdentifier:@"LeftViewController"];
    leftViewController.mainViewController = navigationController;
    
    self.slideMenuController = [[SlideMenuController alloc] initWithMainViewController:navigationController rightMenuViewController:leftViewController];
    
    [self presentViewController:self.slideMenuController animated:NO completion:^{
    }];
}

-(void)closeMainController
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    [settings setBool:NO         forKey:@"isEnableAuroRegister"];
    [settings setBool:NO forKey:@"isEnableSaveCarFromPastOrder"];
    [settings setBool:NO   forKey:@"isEnableSaveListOfServices"];
    
    [settings setValue:@""     forKey:@"UserName"];
    [settings setValue:@"" forKey:@"userLocation"];
    [settings setObject:@"" forKey:@"AccessToken"];
    [settings setBool:NO         forKey:@"isEnableAuroRegister"];
    [settings synchronize];
    
    if(self.slideMenuController != nil)
    {
        [self.slideMenuController dismissViewControllerAnimated:NO completion:^{
            
        }];
    }
}

-(void)successDismissedNavigationController
{
    self.afterLogin = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
