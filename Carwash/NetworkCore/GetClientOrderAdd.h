//
//  GetClientOrderAdd.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/20/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetClientOrderAdd : NetworkRequests

- (void)getClientOrderAdd:(NSString*)car_wash_id
                   day_id:(NSString*)day_id
                  time_id:(NSString*)time_id
                   car_id:(NSString*)car_id
                 model_id:(NSString*)model_id
               car_number:(NSString*)car_number
                 services:(NSString* )services
        completionHandler:(CompletionHandler)completionHandler
             errorHandler:(CompletionHandler)errorHandler;

@end
