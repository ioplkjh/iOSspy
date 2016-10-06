//
//  LocalNotificationManager.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/28/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotificationManager : NSObject

- (void)getAccessToSendLocalNotificatons;
- (void)reSheduletAllNotyficationEngine;
- (void)createNotificationFromDayType:(NSInteger)typeOfDay hours:(NSInteger)hours minuts:(NSInteger)minuts;

@end
