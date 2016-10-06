//
//  GetallTimesRequest.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/30/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetallTimesRequest : NetworkRequests

- (void)getAllTimesRequest:(CompletionHandler)completionHandler
              errorHandler:(CompletionHandler)errorHandler;

@end
