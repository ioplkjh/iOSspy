//
//  NetworkRequests.h
//  Carwash
//
//  Created by Andrey Sabinin on 8/7/15.
//  Copyright (c) 2015 Andrey Sabinin. All rights reserved.
//

#import "NetworkRequests.h"

@implementation NetworkRequests{
    CompletionHandler _completionHandler;
    CompletionHandler _errorHandler;
}


#pragma mark - Externals Methods -

- (void)preparationRequestForGETMethodRequest:(NSString *)methodRequest
                            completionHandler:(CompletionHandler)completionHandler
                                 errorHandler:(CompletionHandler)errorHandler
{
    _completionHandler = completionHandler;
    _errorHandler = errorHandler;
    
    NSURL *URL = kBaseUrl(methodRequest);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [self createSessionWithRequest:request];
}

- (void)preparationRequestForPOSTMethodRequest:(NSString *)methodRequest
                                 withParameter:(NSDictionary *)parametrs
                             completionHandler:(CompletionHandler)completionHandler
                                  errorHandler:(CompletionHandler)errorHandler
{
    _completionHandler = completionHandler;
    _errorHandler = errorHandler;

    NSURL *URL = kBaseUrl(methodRequest);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSData *body = [self _encodeFormPostParameters:parametrs];
    [request setHTTPBody:body];


    [self createSessionWithRequest:request];
}

- (void)createSessionWithRequest:(NSURLRequest *)request
{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {

          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
          if(httpResponse.statusCode == 403)
          {
              _errorHandler(@{@"statusCode":@403});
              return;
          }
          
          if (error) {
              _errorHandler(@{@"statusCode":@403});
              return;
          }
          
          NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
          NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

          if (json[@"data"] != nil) {
              
              dispatch_async(dispatch_get_main_queue(), ^{

              _completionHandler(json);
              });
          } else {
              dispatch_async(dispatch_get_main_queue(), ^{

                [self _processErrorWith:json];
                _errorHandler();
              });
          }
          
          if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
              
              
          }
          
//          NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//          NSLogCookie(@"Response Body:\n%@\n", body);
          
      }] resume];
}

#pragma mark - Internals Methods -

- (void)_processErrorWith:(NSDictionary *)jSON
{
    NSString *errorString = jSON[@"message"];
    
    [[[UIAlertView alloc] initWithTitle:@"" message:errorString ? errorString : @"Ошибка на сервере" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (NSData *)_encodeFormPostParameters:(NSDictionary *)parameters
{
    NSMutableString *formPostParams = [[NSMutableString alloc] init];
    
    NSEnumerator *keys = [parameters keyEnumerator];
    
    NSString *name = [keys nextObject];
    while (nil != name) {
        id encodedValue = [parameters objectForKey: name];
        
        if([encodedValue isKindOfClass:[NSNumber class]])
        {
            encodedValue = [NSString stringWithFormat:@"%@",encodedValue];
        }
        else if ([encodedValue isKindOfClass:[NSString class]])
        {
            encodedValue = [NSString stringWithFormat:@"%@",encodedValue];
        }
        else if ([encodedValue isKindOfClass:[UIImage class]])
        {
            encodedValue = @"";
        }
        
        [formPostParams appendString: name];
        [formPostParams appendString: @"="];
        [formPostParams appendString: encodedValue];
        
        name = [keys nextObject];
        
        if (nil != name) {
            [formPostParams appendString: @"&"];
        }
    }
    
    return [formPostParams dataUsingEncoding:NSUTF8StringEncoding];

//    NSData *encodeFormPostParams = [NSData new];
//    
//    if( parameters )
//    {
//        NSError *error = nil;
//        NSData *reqData = [NSJSONSerialization dataWithJSONObject:parameters
//                                                          options:0
//                                                            error:&error];
//        if (error != nil) {
//            NSLogCookie(@"Error NSJSONSerialization");
//            return nil;
//        }
//        encodeFormPostParams = reqData;
//    }
//    
//    return encodeFormPostParams;
}

@end
