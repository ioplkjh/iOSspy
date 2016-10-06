//
//  GetCodeRequest.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/1/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetCodeRequest : NetworkRequests

- (void)getCodeByNumber:(NSString *)number
                   name:(NSString *)name
                 region:(NSString *)region
      completionHandler:(CompletionHandler)completionHandler
           errorHandler:(CompletionHandler)errorHandler;

@end
