//
//  Defines.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/1/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#ifdef __OBJC__

#import <Availability.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

//Development Features
#define __IN_DEVELOPMENT__ [[[UIAlertView alloc] initWithTitle:@"Message" message:@"This featured in development :)" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil] show];

//CORE DATA
#define kApplicationDocumentsDirectory [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]

typedef void(^CompletionHandler)();

#endif