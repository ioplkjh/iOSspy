//
//  GetClientOrderAdd.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/20/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "GetClientOrderAdd.h"

@implementation GetClientOrderAdd

- (void)getClientOrderAdd:(NSString*)car_wash_id
                   day_id:(NSString*)day_id
                  time_id:(NSString*)time_id
                   car_id:(NSString*)car_id
                 model_id:(NSString*)model_id
               car_number:(NSString*)car_number
                 services:(NSString* )services
             completionHandler:(CompletionHandler)completionHandler
                  errorHandler:(CompletionHandler)errorHandler
{
    
    
    /*
    {
        car_wash_id, // ИД мойки
        day_id, // день записи (1/2/3 - сегодня/завтра/послезавтра)
        time_id, // время записи (айдишник который приходит со временем)
        car_id, // ИД марки авто (не обязательное)
        model_id, // ИД модели авто
        car_number, // гос. номер авто
        services // массив ИДшников услуг
    }
    
    */
    
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
                                 @"access_token" :access_token,
                                 @"car_wash_id"  :car_wash_id,
                                 @"day_id"       :day_id,
                                 @"time_id"      :time_id,
                                 @"car_id"       :car_id,
                                 @"model_id"     :model_id,
                                 @"car_number"   :car_number,
                                 @"services"     :services,
                                 @"order_source_id":@"2"
                                 };
    
    [SVProgressHUD showWithStatus:@"Загрузка"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self preparationRequestForPOSTMethodRequest:kGetCustomAdd
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
