//
//  GetSignInClientRequest.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/10/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "GetSignInClientRequest.h"

@implementation GetSignInClientRequest

- (void)getSignInClientByID:(NSNumber*)region_id
                       name:(NSString*)name
                      phone:(NSString*)phone
                    smsCode:(NSString*)smsCode
          completionHandler:(CompletionHandler)completionHandler
               errorHandler:(CompletionHandler)errorHandler
{
    
    NSDictionary *parameters = @{
                                 @"phone":phone,
                                 @"region_id":region_id,
                                 @"fio":name,
                                 @"sms_code":smsCode
                                 };

    [SVProgressHUD showWithStatus:@"Загрузка"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self preparationRequestForPOSTMethodRequest:kGetLoginSteapOne
                                   withParameter:parameters
                               completionHandler:^(NSDictionary *json)
     {
         
         if([json[@"data"] isKindOfClass:[NSString class]])
         {
             NSLog(@"%@",json[@"data"]);
             dispatch_async(dispatch_get_main_queue(), ^{
                 errorHandler(json);
                 [SVProgressHUD dismiss];
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

             });
             return ;
         }

         
         BOOL valid = [json[@"data"] isKindOfClass:[NSNull class]] ? NO : [json[@"data"] count];
         
         if (!valid) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD showInfoWithStatus:@"Ничего не найдено"];
             });
         } else {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
             });
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             completionHandler(json);
         });
     } errorHandler:^(NSDictionary *json){
         dispatch_async(dispatch_get_main_queue(), ^{
             [SVProgressHUD dismiss];
         });
         dispatch_async(dispatch_get_main_queue(), ^{
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             errorHandler(json);
         });
     }];
}


@end
