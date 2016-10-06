//
//  LoginViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/23/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "LoginViewController.h"
#import "GetLoginRequest.h"
#import "RegisterViewController.h"
#import "RegisterPassViewController.h"

@interface LoginViewController ()
@property (nonatomic, weak) IBOutlet UITextField *numberTF;

@property (assign, nonatomic) CGPoint defaultViewCenter;
@end

@implementation LoginViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultViewCenter:self.view.center];
}

-(IBAction)onLoginButton:(id)sender
{
   __block NSString *number = self.numberTF.text;
    
    if(number.length == 0)
    {
        return;
    }
    
    [[GetLoginRequest alloc] getLoginClientByPhone:number completionHandler:^(NSDictionary* json)
    {
        NSString *codeAccessToken  = json[@"data"][@"access_token"];
        if(![codeAccessToken isKindOfClass:[NSNull class]])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
            RegisterPassViewController *rgViewController = [storyboard instantiateViewControllerWithIdentifier:@"RegisterPassViewController"];
            rgViewController.pass = json[@"data"][@"sms_code"];
            rgViewController.phoneNumber = number;
            
            NSString *codeFromSMS   = json[@"data"][@"sms_code" ];
            NSString *userID        = [NSString stringWithFormat:@"%@",json[@"data"][@"id"]];
            NSString *codeLogin     = json[@"data"][@"login"    ];
            NSString *codePassword  = json[@"data"][@"password" ];
            NSString *codeAccessToken  = json[@"data"][@"access_token"];
            
            [[NSUserDefaults standardUserDefaults] setObject:codeFromSMS forKey:@"CodeFromSMS"];
            [[NSUserDefaults standardUserDefaults] setObject:codeLogin forKey:@"CodeLogin"];
            [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"userID"];
            
            [[NSUserDefaults standardUserDefaults] setObject:codePassword forKey:@"CodePassword"];
            [[NSUserDefaults standardUserDefaults] setObject:codeAccessToken forKey:@"AccessToken"];
            
//            [[NSUserDefaults standardUserDefaults] setObject:self.nameTF.text  forKey:@"UserName"];
//            [[NSUserDefaults standardUserDefaults] setObject:region forKey:@"userLocation"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            if(codeAccessToken.length > 0)
            {
                [self.navigationController pushViewController:rgViewController animated:YES];
            }
        }
        else
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
            RegisterViewController *rgViewController = [storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
            rgViewController.codeF = json[@"data"][@"sms_code"];
            rgViewController.phoneF = number;
            [self.navigationController pushViewController:rgViewController animated:YES];
        }
    } errorHandler:^(NSDictionary *json)
    {
        NSInteger code = [json[@"statusCode"] integerValue];
        if(code == 403)
        {
            [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"На сервере" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
    }];
}

#pragma mark - Keyboard Notyfications Actions -

-(void)keyboardWillHide:(NSNotification*)notyfication
{
    [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:
     ^{
         self.view.center = self.defaultViewCenter;
//         self.logoImageView.alpha = 1.0;
         //         if(!is_4_inch())
         //             self.stepImageView.alpha = 1.0;
     } completion:^(BOOL finished)
     {
         //empty
     }];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)keyboardWillShow:(NSNotification*)notyfication
{
    //reset all rect
    //    self.view.center = self.defaultViewCenter;
    
    NSDictionary *options = notyfication.userInfo;
    NSValue *keyBoardValue = options[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect   rectKeyboard  = keyBoardValue.CGRectValue;
//    CGFloat offset = kOffsetRegistrationDifferens;
    CGFloat  keyboardSlideOffset = rectKeyboard.size.height ;//- offset;
    [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:
     ^{
         self.view.center = CGPointMake(self.defaultViewCenter.x, self.defaultViewCenter.y - keyboardSlideOffset);
//         self.logoImageView.alpha = 0.0;
         //         if(!is_4_inch())
         //             self.stepImageView.alpha = 0.0;
         
     } completion:^(BOOL finished)
     {
         //empty
     }];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(IBAction)onTapBackground:(id)sener
{
    [self.numberTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
