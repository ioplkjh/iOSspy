//
//  GetallTimesRequest.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/30/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "GetallTimesRequest.h"

@implementation GetallTimesRequest

- (void)getAllTimesRequest:(CompletionHandler)completionHandler
              errorHandler:(CompletionHandler)errorHandler
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [settings objectForKey:@"AccessToken"];
    if(access_token.length == 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Ошибка при авторизации. Повторно авторизируйтесь" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil] show];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"closeMain" object:nil];
        });
        return;
    }
    NSDictionary *parameters = @{
                                 @"access_token":access_token
                                 };
    
    [SVProgressHUD showWithStatus:@"Загрузка"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self preparationRequestForPOSTMethodRequest:kGetTimes
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
