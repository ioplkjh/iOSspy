//
//  GetAllOrderInfoRequest.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/20/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetAllOrderInfoRequest : NetworkRequests

- (void)getAllOrderInfoRequest:(NSNumber*)clientID
             completionHandler:(CompletionHandler)completionHandler
                  errorHandler:(CompletionHandler)errorHandler;

@end
