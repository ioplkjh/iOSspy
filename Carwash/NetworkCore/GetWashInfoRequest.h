//
//  GetWashInfoRequest.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/9/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetWashInfoRequest : NetworkRequests

- (void)getWashInfoByID:(NSNumber* )idWash
      completionHandler:(CompletionHandler)completionHandler
           errorHandler:(CompletionHandler)errorHandler;

@end
