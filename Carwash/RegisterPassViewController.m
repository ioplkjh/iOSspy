//
//  RegisterPassViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/1/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "RegisterPassViewController.h"
#import "GetCheckSMSCodeRequest.h"
#import "GetLoginRequest.h"

#define kOffsetRegistrationDifferens        is_4_inch() ? 40.f : 20.f

CG_INLINE BOOL is_4_inch()
{
    if( 568.f <= [ UIScreen mainScreen ].bounds.size.height )
        return YES;
    return NO;
}

@interface RegisterPassViewController ()
//Defaut Rect
@property (assign, nonatomic) CGPoint defaultViewCenter;
@property (weak, nonatomic) IBOutlet UIView *underView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

@implementation RegisterPassViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDefaultViewCenter:self.view.center];
    [self.textField setText:self.pass];
}

#pragma mark - Keyboard Notyfications Actions -

-(void)keyboardWillHide:(NSNotification*)notyfication
{
    [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:
     ^{
         self.view.center = self.defaultViewCenter;
                  self.logoImageView.alpha = 1.0;
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
    CGFloat offset = kOffsetRegistrationDifferens;
    CGFloat  keyboardSlideOffset = rectKeyboard.size.height - offset;
    [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:
     ^{
         self.view.center = CGPointMake(self.defaultViewCenter.x, self.defaultViewCenter.y - keyboardSlideOffset);
                  self.logoImageView.alpha = 0.0;
         
     } completion:^(BOOL finished)
     {
         //empty
     }];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)onGetCodeButton:(id)sender
{

        [[GetLoginRequest alloc] getLoginClientByPhone:self.phoneNumber completionHandler:^(NSDictionary* json)
         {
#warning убрать
             self.textField.text = json[@"data"][@"sms_code"];
             [[[UIAlertView alloc] initWithTitle:@"Сообщение" message:@"Повторно был отправлен код в СМС" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
             
         } errorHandler:^(NSDictionary *json)
         {
             NSInteger code = [json[@"statusCode"] integerValue];
             if(code == 403)
             {
                 [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"На сервере" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
             }
         }];
}

- (IBAction)onAcceptButton:(id)sender
{
    if(self.textField.text.length <= 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Введите код с СМС" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    [[GetCheckSMSCodeRequest alloc] getCheckSMSCodeRequest:self.textField.text completionHandler:^(NSDictionary *json)
    {
        NSString *accessToken = json[@"data"];
        if(accessToken.length > 0)
        {
            [SVProgressHUD showWithStatus:@"Загрузка"];
            NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
            [settings setObject:accessToken forKey:@"AccessToken"];
            [settings setBool:YES         forKey:@"isEnableAuroRegister"          ];
            
            [settings synchronize];
            [self.navigationController dismissViewControllerAnimated:NO completion:^{
                
            }];
        }
    } errorHandler:^{
         [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Не правильный код" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }];
}

- (IBAction)onTapBackground:(id)sender
{
    [self.textField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
