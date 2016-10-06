//
//  GetAllMarkCarsRequest.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/11/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetAllMarkCarsRequest : NetworkRequests

- (void)getAllMarkCarsRequestWithCompletionHandler:(CompletionHandler)completionHandler
                                      errorHandler:(CompletionHandler)errorHandler;
@end
