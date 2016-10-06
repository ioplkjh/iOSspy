//
//  GetAllRegionRequest.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/14/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetAllRegionRequest : NetworkRequests

- (void)getAllRegionRequestWithCompletionHandler:(CompletionHandler)completionHandler
                                    errorHandler:(CompletionHandler)errorHandler;

@end
