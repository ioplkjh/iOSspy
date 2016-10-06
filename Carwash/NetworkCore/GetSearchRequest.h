//
//  GetSearchRequest.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/30/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetSearchRequest : NetworkRequests

- (void)getSearchRequestDayId:(NSString*)day_id
          additional_services:(NSString*)additional_services
                 time_id_from:(NSString*)time_id_from
                   time_id_to:(NSString*)time_id_to
                   min_rating:(NSString*)min_rating
                 car_model_id:(NSString*)car_model_id
              wash_service_id:(NSString*)wash_service_id
            completionHandler:(CompletionHandler)completionHandler
                 errorHandler:(CompletionHandler)errorHandler;

@end
