//
//  GetCheckSMSCodeRequest.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/15/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "GetCheckSMSCodeRequest.h"

@implementation GetCheckSMSCodeRequest

- (void)getCheckSMSCodeRequest:(NSString*)code
             completionHandler:(CompletionHandler)completionHandler
                  errorHandler:(CompletionHandler)errorHandler
{
    
    NSDictionary *parameters = @{
                                 @"sms_code":code
                                 };
    
    [SVProgressHUD showWithStatus:@"Загрузка"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self preparationRequestForPOSTMethodRequest:kGetLoginSteapTwo
                                   withParameter:parameters
                               completionHandler:^(NSDictionary *json)
     {
         
         if([json[@"data"] isKindOfClass:[NSString class]])
         {
             NSLog(@"%@",json[@"data"]);
             dispatch_async(dispatch_get_main_queue(), ^{
                 completionHandler(json);
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
     } errorHandler:^{
         dispatch_async(dispatch_get_main_queue(), ^{
             [SVProgressHUD dismiss];
         });
         dispatch_async(dispatch_get_main_queue(), ^{
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             errorHandler();
         });
     }];
}


@end
