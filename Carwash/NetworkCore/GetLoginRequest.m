//
//  GetLoginRequest.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/23/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "GetLoginRequest.h"

@implementation GetLoginRequest

- (void)getLoginClientByPhone:(NSString*)phone
            completionHandler:(CompletionHandler)completionHandler
                errorHandler:(CompletionHandler)errorHandler
{
    
    NSString *tokenSTR = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];

    
    tokenSTR = [tokenSTR stringByReplacingOccurrencesOfString:@" " withString:@""];
    tokenSTR = [tokenSTR stringByReplacingOccurrencesOfString:@"<" withString:@""];
    tokenSTR = [tokenSTR stringByReplacingOccurrencesOfString:@">" withString:@""];

    if(tokenSTR == nil)
        tokenSTR = @"";
    
    NSDictionary *parameters = @{
                                 @"device_type":@"2",
                                 @"device_token":tokenSTR,
                                 @"login":phone,
                                 };
    
    [SVProgressHUD showWithStatus:@"Загрузка"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self preparationRequestForPOSTMethodRequest:kGetLoginSignIn
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
