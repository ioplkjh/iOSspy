//
//  GetUpdateUserInfo.h
//  Carwash
//
//  Created by Andrey Sabinin on 10/22/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetUpdateUserInfo : NetworkRequests

- (void)getUpdateInfoRegionID:(NSString*)region_id
                      comment:(NSString*)fio
            completionHandler:(CompletionHandler)completionHandler
                 errorHandler:(CompletionHandler)errorHandler;

@end
