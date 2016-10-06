//
//  GetServicesRequest.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/27/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetServicesRequest : NetworkRequests

- (void)getServicesRequestCompletionHandler:(CompletionHandler)completionHandler
                               errorHandler:(CompletionHandler)errorHandler;

@end
