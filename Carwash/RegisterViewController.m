//
//  RegisterViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/1/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterPassViewController.h"
#import "GetSignInClientRequest.h"
#import "GetAllRegionRequest.h"
#import "ChoiceRegionViewController.h"
#import "GetLoginRequest.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"


#define kOffsetRegistrationDifferens        is_4_inch() ? 60.f : 50.f

CG_INLINE BOOL is_4_inch()
{
    if( 568.f <= [ UIScreen mainScreen ].bounds.size.height )
        return YES;
    return NO;
}

@interface RegisterViewController ()

//Defaut Rect
@property (assign, nonatomic) CGPoint defaultViewCenter;
@property (weak, nonatomic) IBOutlet UIView *underView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *smsTF;

@property (nonatomic, strong) NSString *phoneNumber;

@property (nonatomic, strong) NSArray *regions;
@property (nonatomic, strong) NSNumber *regionID;
@property (weak, nonatomic) IBOutlet UIButton *regionButton;

@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (nonatomic, strong) NSMutableDictionary *regionDict;
@end

@implementation RegisterViewController

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
    self.regionDict = [@{} mutableCopy];
    self.regions = [@[] copy];
    [self setDefaultViewCenter:self.view.center];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

    self.textField.text = self.phoneF;
#if DEBUG
    self.nameTF.text    = @"Андрей";
#endif
    
#warning убрать
    self.smsTF.text = self.codeF;
    
    self.getCodeButton.enabled = NO;
    [self performSelector:@selector(unlockButton) withObject:nil afterDelay:40];
}

-(void)unlockButton
{
    self.getCodeButton.enabled = YES;
}
- (IBAction)onBackTo:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *name = [NSString stringWithFormat:@"Pattern~%@", self.title];
    
    // The UA-XXXXX-Y tracker ID is loaded automatically from the
    // GoogleService-Info.plist by the `GGLContext` in the AppDelegate.
    // If you're copying this to an app just using Analytics, you'll
    // need to configure your tracking ID here.
    // [START screen_view_hit_objc]
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    // [END screen_view_hit_objc]

    if(self.regionDict[@"id"])
    {
        NSString *region = [NSString stringWithFormat:@"%@",self.regionDict[@"region"]];
        [self.regionButton setTitle:region forState:UIControlStateNormal];
        [self.regionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        self.regionID = @([self.regionDict[@"id"] integerValue]);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Keyboard Notyfications Actions -

-(void)keyboardWillHide:(NSNotification*)notyfication
{
    [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:
     ^{
         self.view.center = self.defaultViewCenter;
         self.logoImageView.alpha = 1.0;
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
    CGFloat offset = kOffsetRegistrationDifferens;
    CGFloat  keyboardSlideOffset = rectKeyboard.size.height - offset;
    [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:
     ^{
         self.view.center = CGPointMake(self.defaultViewCenter.x, self.defaultViewCenter.y - keyboardSlideOffset);
         self.logoImageView.alpha = 0.0;
//         if(!is_4_inch())
//             self.stepImageView.alpha = 0.0;
         
     } completion:^(BOOL finished)
     {
         //empty
     }];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)onAcceptButton:(id)sender
{
    if(self.textField.text.length > 14 || self.textField.text.length <= 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Укажите номер телефона" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    if(self.regionID == nil)
    {
        [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Выберите регион" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    if(self.nameTF.text.length <= 3)
    {
        [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Введите имя" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    if(self.smsTF.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Введите код с СМС" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.textField.text forKey:@"PhoneNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:self.nameTF.text  forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] setObject:self.regionID forKey:@"RegionID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[GetSignInClientRequest alloc] getSignInClientByID:self.regionID name:self.nameTF.text phone:self.textField.text smsCode:self.smsTF.text completionHandler:^(NSDictionary*json)
     {
//         NSDictionary *response = json[@"data"];
         NSString *region = [NSString stringWithFormat:@"%@",self.regionDict[@"region"]];
         NSString *codeFromSMS   = json[@"data"][@"sms_code" ];
         NSString *userID        = [NSString stringWithFormat:@"%@",json[@"data"][@"id"]];
         NSString *codeLogin     = json[@"data"][@"login"    ];
         NSString *codePassword  = json[@"data"][@"password" ];
         NSString *codeAccessToken  = json[@"data"][@"access_token"];
         
         [[NSUserDefaults standardUserDefaults] setObject:codeFromSMS forKey:@"CodeFromSMS"];
         [[NSUserDefaults standardUserDefaults] setObject:codeLogin forKey:@"CodeLogin"];
         [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"userID"];
         [[NSUserDefaults standardUserDefaults] setObject:region forKey:@"userLocation"];

         [[NSUserDefaults standardUserDefaults] setObject:codePassword forKey:@"CodePassword"];
         [[NSUserDefaults standardUserDefaults] setObject:codeAccessToken forKey:@"AccessToken"];
         
         [[NSUserDefaults standardUserDefaults] synchronize];
         if(codeAccessToken.length > 0)
         {
             [SVProgressHUD showWithStatus:@"Загрузка"];
             NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
             [settings setObject:codeAccessToken forKey:@"AccessToken"];
             [settings setBool:YES         forKey:@"isEnableAuroRegister"          ];
             [settings synchronize];
             [self.navigationController dismissViewControllerAnimated:NO completion:^{
             }];
         }
         else
         {
             [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"На сервере" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
         }
     } errorHandler:^(NSDictionary *json){
         if(json)
         {
             if([json[@"statusCode"] integerValue] == 403)
             {
                 [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Неправильный код с СМС" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
             }
         }
     }];
}

- (IBAction)onGetCodeButton:(id)sender
{
   
    [[GetLoginRequest alloc] getLoginClientByPhone:self.phoneF completionHandler:^(NSDictionary* json)
     {
         
#warning убрать
             self.smsTF.text = json[@"data"][@"sms_code"];
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

- (IBAction)onRegionButton:(id)sender
{
    [self.nameTF resignFirstResponder];
    [self.textField resignFirstResponder];
    [self.smsTF resignFirstResponder];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ChoiceRegion" bundle:nil];
    ChoiceRegionViewController *choiceRegionViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChoiceRegionViewController"];
    choiceRegionViewController.regionDict = self.regionDict;
    [self.navigationController pushViewController:choiceRegionViewController animated:YES];
}

- (IBAction)onTapBackground:(id)sender
{
    [self.textField resignFirstResponder];
    [self.nameTF resignFirstResponder];
    [self.smsTF resignFirstResponder];
}

@end
