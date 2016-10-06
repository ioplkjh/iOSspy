//
//  GetLoginRequest.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/23/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetLoginRequest : NetworkRequests

- (void)getLoginClientByPhone:(NSString*)phone
             completionHandler:(CompletionHandler)completionHandler
                  errorHandler:(CompletionHandler)errorHandler;

@end
