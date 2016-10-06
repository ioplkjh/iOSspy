//
//  GetAllCarModelRequet.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/11/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "NetworkRequests.h"

@interface GetAllCarModelRequet : NetworkRequests

- (void)getAllCarsModelByIDBrand:(NSNumber*)idBrand
               completionHandler:(CompletionHandler)completionHandler
                    errorHandler:(CompletionHandler)errorHandler;

@end
