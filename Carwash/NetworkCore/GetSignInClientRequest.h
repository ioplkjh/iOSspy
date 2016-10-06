//
//  GetSignInClientRequest.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/10/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetSignInClientRequest : NetworkRequests

- (void)getSignInClientByID:(NSNumber*)region_id
                       name:(NSString*)name
                      phone:(NSString*)phone
                    smsCode:(NSString*)smsCode
          completionHandler:(CompletionHandler)completionHandler
               errorHandler:(CompletionHandler)errorHandler;

@end
