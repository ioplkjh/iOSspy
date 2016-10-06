//
//  GetWashInfoRequest.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/9/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "GetWashInfoRequest.h"

@implementation GetWashInfoRequest

- (void)getWashInfoByID:(NSNumber* )idWash
           completionHandler:(CompletionHandler)completionHandler
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
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *dateString = [format stringFromDate:now];
    NSDictionary *parameters = @{
                                 @"local_time":dateString,
                                 @"access_token":access_token,
                                 @"id":idWash,
                                 };
    
    [SVProgressHUD showWithStatus:@"Загрузка" maskType:SVProgressHUDMaskTypeGradient];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self preparationRequestForPOSTMethodRequest:kGetWashInfo
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
