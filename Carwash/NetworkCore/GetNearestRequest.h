//
//  GetNearestRequest.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/7/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetNearestRequest : NetworkRequests

- (void)getNearestByDistance:(NSNumber* )max_distance
                         lat:(NSNumber *)latitude
                         lon:(NSNumber *)longitude
           completionHandler:(CompletionHandler)completionHandler
                errorHandler:(CompletionHandler)errorHandler;

@end
