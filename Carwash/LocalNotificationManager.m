//
//  LocalNotificationManager.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/28/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "LocalNotificationManager.h"


#define kOneDay   60*60*24*1
#define kTwoDays  60*60*24*2

#define kMinusRemember 60*30

@implementation LocalNotificationManager

-(void)getAccessToSendLocalNotificatons
{
    if([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge];
    }
}

- (void)reSheduletAllNotyficationEngine
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}

-(void)createNotificationFromDayType:(NSInteger)typeOfDay hours:(NSInteger)hours minuts:(NSInteger)minuts
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday |
                                    NSCalendarUnitDay |
                                    NSCalendarUnitMonth |
                                    NSCalendarUnitYear |
                                    NSCalendarUnitHour |
                                    NSCalendarUnitMinute
                                                                   fromDate:[NSDate date]];
    
    [components setHour:hours];
    [components setMinute:minuts];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *datePrepare = [gregorian dateFromComponents:components];
    NSTimeInterval offset = 0;
    
    if(typeOfDay == 1)
        offset = 0;
    if(typeOfDay == 2)
        offset = kOneDay;
    if(typeOfDay == 3)
        offset = kTwoDays;
    
    NSTimeInterval interval = ([datePrepare timeIntervalSince1970] + offset) - kMinusRemember;
    NSDate *finalDate = [NSDate dateWithTimeIntervalSince1970:interval];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    
    localNotif.fireDate = finalDate;
    localNotif.timeZone = [NSTimeZone systemTimeZone];
    localNotif.alertBody = @"Вам через пол часа на мойку";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.userInfo = nil;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

@end
