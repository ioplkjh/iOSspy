//
//  NetworkRequests.h
//  Carwash
//
//  Created by Andrey Sabinin on 8/7/15.
//  Copyright (c) 2015 Andrey Sabinin. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define kBaseUrl(func) [NSURL URLWithString:[NSString stringWithFormat:@"http://test.itnavigator.org:88/car-wash/backend/%@", func]];
#define kBaseUrl(func) [NSURL URLWithString:[NSString stringWithFormat:@"http://allmoyki.ru/backend/%@", func]];


#define kGetAllRegion              @"Region/GetAll"

#define kGetNearest                @"CarWash/GetNearest"
#define kGetWashInfo               @"CarWash/GetById"
#define kGetFreeWashTimes          @"CarWash/GetFreeWashTimes"
#define kGetAllCarsBrand           @"CarBrand/GetAll"
#define kGetAllCarsModel           @"CarModel/GetAllByCarBrand"
#define kGetAllByCarWash           @"CarWashReview/GetAllByCarWash"


#define kGetLoginSignIn             @"User/SignInClient"
#define kGetLoginSteapOne           @"User/SignUpClient"
#define kGetLoginSteapTwo           @"User/CheckSMSCode"

#define kGetLastActivedByClient     @"ClientOrder/GetAllByClient"
#define kGetSearch                  @"CarWash/Search"

#define kGetServices                @"CarWash/FindByWashService"
#define kGetTimes                   @"WashTime/GetAll"

#define kGetServicesSearch          @"WashService/GetAll"
#define kGetCustomAdd               @"ClientOrder/CustomAdd"

#define kGetCancelOrder             @"ClientOrder/Cancel"
#define kGetLeaveComment            @"CarWashReview/Add"
#define kGetUpdateInfo              @"Client/UpdateInfo"
#define kGetByToken                 @"Client/GetByToken"

@interface NetworkRequests : NSObject

- (void)preparationRequestForGETMethodRequest:(NSString *)methodRequest
                            completionHandler:(CompletionHandler)completionHandler
                                 errorHandler:(CompletionHandler)errorHandler;

- (void)preparationRequestForPOSTMethodRequest:(NSString *)methodRequest
                                 withParameter:(NSDictionary *)parametrs
                             completionHandler:(CompletionHandler)completionHandler
                                  errorHandler:(CompletionHandler)errorHandler;

@end
