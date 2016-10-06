//
//  AppDelegate.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/1/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "GAI.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[[Crashlytics class]]];
    [[LocationCore sharedMenager] getCurrentLocation];
    
       
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-71325242-1"];
    
    [self registerForRemoteNotification];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    self.path = [documentsDirectory stringByAppendingPathComponent:@"myCars.plist"]; //3
    self.pathRegions = [documentsDirectory stringByAppendingPathComponent:@"regions.plist"];
    self.pathServices = [documentsDirectory stringByAppendingPathComponent:@"services.plist"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: self.path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"myCars" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: self.path error:&error]; //6
    }
    if (![fileManager fileExistsAtPath: self.pathRegions]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"regions" ofType:@"plist"]; //5
        [fileManager copyItemAtPath:bundle toPath: self.pathRegions error:&error]; //6
    }
    if (![fileManager fileExistsAtPath: self.pathServices]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"services" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: self.pathServices error:&error]; //6
    }
    
    return YES;
}


- (void)registerForRemoteNotification {
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}
#endif

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *tokenSTR = [NSString stringWithFormat:@"%@",deviceToken];
    [[NSUserDefaults standardUserDefaults] setObject:tokenSTR forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
