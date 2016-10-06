//
//  GetSearchRequest.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/30/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "GetSearchRequest.h"

@implementation GetSearchRequest

- (void)getSearchRequestDayId:(NSString*)day_id
          additional_services:(NSString*)additional_services
                 time_id_from:(NSString*)time_id_from
                   time_id_to:(NSString*)time_id_to
                   min_rating:(NSString*)min_rating
                 car_model_id:(NSString*)car_model_id
              wash_service_id:(NSString*)wash_service_id
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
    
    /*
     - car_model_id (ИД модели авто, отсюда будет браться категория авто)
     - wash_service_id (ИД услуги)
     - day_id (1 - сегодня, 2 - завтра, 3 - послезавтра)
     - time_id_from (ИД начального желаемого свободного времени)
     - time_id_to (ИД конечного желаемого свободного времени)
     */
    
//    NSDictionary *parameters = @{
//                                 @"time_id_to":time_id_to,
//                                 @"time_id_from":time_id_from,
//                                 @"day_id":day_id,
//                                 @"wash_service_id":wash_service_id,
//                                 @"car_model_id":car_model_id,
//                                 @"min_rating":min_rating,
//                                 @"access_token":access_token
//                                 };
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *dateString = [format stringFromDate:now];

    NSDictionary *parameters = @{
                                 @"additional_services":additional_services,
                                 @"local_time":dateString,
                                 @"time_id_to":time_id_to,
                                 @"time_id_from":time_id_from,
                                 @"day_id":day_id,
                                 @"wash_service_id":wash_service_id,
                                 @"car_model_id":car_model_id,
                                 @"min_rating":min_rating,
                                 @"access_token":access_token
                                 };
    
    [SVProgressHUD showWithStatus:@"Поиск"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self preparationRequestForPOSTMethodRequest:kGetSearch
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
         
         if (valid) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
                 completionHandler(json);
             });
         } else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD showInfoWithStatus:@"Ничего не найдено"];
                 errorHandler();
             });
             
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
