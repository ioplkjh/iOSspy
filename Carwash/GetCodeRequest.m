//
//  GetCodeRequest.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/1/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "GetCodeRequest.h"

@implementation GetCodeRequest

- (void)getCodeByNumber:(NSString *)number
                   name:(NSString *)name
                 region:(NSString *)region
      completionHandler:(CompletionHandler)completionHandler
           errorHandler:(CompletionHandler)errorHandler
{
    NSDictionary *parameters = @{
                                 @"":number,
                                 @"":name,
                                 @"":region
                                 };
    
    [SVProgressHUD showWithStatus:@"Загрузка"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self preparationRequestForPOSTMethodRequest:kGetNearest
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
             
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 // time-consuming task
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [SVProgressHUD showInfoWithStatus:@"Ничего не найдено"];
                 });
             });
         } else {
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 // time-consuming task
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [SVProgressHUD dismiss];
                 });
             });
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             completionHandler(json);
         });
     } errorHandler:^{
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             // time-consuming task
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
             });
         });
         dispatch_async(dispatch_get_main_queue(), ^{
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             errorHandler();
         });
     }];
}

@end
