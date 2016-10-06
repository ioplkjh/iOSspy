//
//  GetAllCommentsRequest.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/13/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetAllCommentsRequest : NetworkRequests

- (void)getAllCommentsByIDWash:(NSNumber*)idWash
             completionHandler:(CompletionHandler)completionHandler
                  errorHandler:(CompletionHandler)errorHandler;
@end
