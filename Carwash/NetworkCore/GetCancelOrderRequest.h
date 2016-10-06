//
//  GetCancelOrderRequest.h
//  Carwash
//
//  Created by Andrei Sabinin on 10/2/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetCancelOrderRequest : NetworkRequests

- (void)getCancelOrderRequestByID:(NSString*)idOrder
                completionHandler:(CompletionHandler)completionHandler
                     errorHandler:(CompletionHandler)errorHandler;

@end
