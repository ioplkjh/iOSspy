//
//  GetCheckSMSCodeRequest.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/15/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetCheckSMSCodeRequest : NetworkRequests

- (void)getCheckSMSCodeRequest:(NSString*)code
             completionHandler:(CompletionHandler)completionHandler
                  errorHandler:(CompletionHandler)errorHandler;

@end
