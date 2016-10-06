//
//  GetLeaveCommentrequest.h
//  Carwash
//
//  Created by Andrei Sabinin on 10/2/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetLeaveCommentRequest : NetworkRequests

- (void)getLeaveCommentRequestByID:(NSString*)client_order_id
                           comment:(NSString*)comment
                       car_wash_id:(NSString*)car_wash_id
                              mark:(NSString*)mark
                 completionHandler:(CompletionHandler)completionHandler
                      errorHandler:(CompletionHandler)errorHandler;

@end
