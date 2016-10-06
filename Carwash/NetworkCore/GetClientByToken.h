//
//  GetClientByToken.h
//  Carwash
//
//  Created by Andrey Sabinin on 10/23/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetClientByToken : NetworkRequests

- (void)getGetClientByTokenCompletionHandler:(CompletionHandler)completionHandler
                                errorHandler:(CompletionHandler)errorHandler;

@end
