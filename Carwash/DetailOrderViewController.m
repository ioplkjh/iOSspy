//
//  DetailOrderViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/28/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "DetailOrderViewController.h"
#import "WashPageViewController.h"

#import "GetCancelOrderRequest.h"
#import "GetLeaveCommentRequest.h"
#import "HCSStarRatingView.h"
//Cells
#import "DetailOrderTopCell.h"
#import "DetailOrderMiddleCell.h"
#import "DetailOrderBotCell.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"


#define kNumberOfCells 3

#define kIndexTop    0
#define kIndexMiddle 1
#define kIndexBot    2

#define kHeightTop    100
#define kHeightMiddle 117
#define kHeightBot    125

#define kIndexTopID    @"detailOrderTopCellID"
#define kIndexMiddleID @"detailOrderMiddleCellID"
#define kIndexBotID    @"detailOrderBotCellID"

@interface DetailOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *rootView;

@property (weak, nonatomic) IBOutlet UIView *bgCommentView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIView *ordetCornerView;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@end

@implementation DetailOrderViewController

- (void)dealloc
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
    [self render];
    [self setTitle:@"Заказ"];
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
    
}

-(void)render
{
    [self.ordetCornerView.layer setBorderWidth:1];
    [self.ordetCornerView.layer setBorderColor:[UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0].CGColor];
    [self.ordetCornerView.layer setCornerRadius:4];
    [self.ordetCornerView setClipsToBounds:YES];
    
    [self.rootView.layer setCornerRadius:4];
    [self.rootView setClipsToBounds:YES];
}
#pragma mark - UITableViewDelegate & Datasource -

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case kIndexTop:
        {
            return kHeightTop;
            break;
        }
        case kIndexMiddle:
        {
            return kHeightMiddle;
            break;
        }
        case kIndexBot:
        {
            return kHeightBot;
            break;
        }
        default:
            break;
    }
    
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kNumberOfCells;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case kIndexTop:
        {
            DetailOrderTopCell *cell = [tableView dequeueReusableCellWithIdentifier:kIndexTopID];
            NSInteger status = [self.dictInfo[@"order_status_id"] integerValue];
            
            cell.statusLabel.adjustsFontSizeToFitWidth = YES;
            
            if (status == -1)
                cell.statusLabel.text = @"Не подтвержденный:";
            else if(status == 1)
                cell.statusLabel.text = @"Подтвержденный заказ:";
            else if(status == 2)
                cell.statusLabel.text = @"Выполненый заказ:";
            else if(status == 3)
                cell.statusLabel.text = @"Отмененный заказ:";
            else if(status == 4)
                cell.statusLabel.text = @"Отказ мойки:";
            
            
            cell.titleLabel.text = self.dictInfo[@"car_wash"][@"title"];
            
            cell.timeLabel.text = self.dictInfo[@"wash_time"][@"wash_time"];
            cell.dateLabel.text = [NSString stringWithFormat:@"(%@)",self.dictInfo[@"wash_date"]];
            cell.addressLabel.text = self.dictInfo[@"car_wash"][@"address"];
            
            return cell;
            break;
        }
        case kIndexMiddle:
        {
            DetailOrderMiddleCell *cell = [tableView dequeueReusableCellWithIdentifier:kIndexMiddleID];
            
            NSArray *arrayServices = [self.dictInfo[@"wash_services"] copy];
            NSMutableString *servString = [@"" mutableCopy];
            for(NSDictionary *dict in arrayServices)
            {
                [servString  appendString:@"- "];
                [servString  appendString:dict[@"service"]];
                [servString  appendString:@"\n"];
            }
            
            cell.servicesLabel.text = [servString copy];
            cell.sumLabel.text = [NSString stringWithFormat:@"Сумма: %@ р.",self.dictInfo[@"cost"]];
            
            return cell;
            break;
        }
        case kIndexBot:
        {
            DetailOrderBotCell *cell = [tableView dequeueReusableCellWithIdentifier:kIndexBotID];
            
            
            
            NSInteger status = [self.dictInfo[@"order_status_id"] integerValue];
            
            if (status == -1)
            {
                cell.commentButton.hidden = YES;
                cell.canselOrderButton.hidden = NO;
            }
            else if(status == 1)
            {
                cell.commentButton.hidden = YES;
                cell.canselOrderButton.hidden = NO;
            }
            else if(status == 2)
            {
                if(self.isCommented == NO)
                {
                    cell.commentButton.hidden = NO;
                }
                cell.canselOrderButton.hidden = YES;
            }
            else if(status == 3)
            {
                cell.commentButton.hidden = NO;
                cell.canselOrderButton.hidden = YES;
            }
            else if(status == 4)
            {
                cell.commentButton.hidden = NO;
                cell.canselOrderButton.hidden = YES;
            }
            
            
            [cell.commentButton addTarget:self action:@selector(onCommentButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.canselOrderButton addTarget:self action:@selector(onCancelButton:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            break;
        }
        default:
            break;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == kIndexTop)
    {
        NSDictionary *dict = self.dictInfo[@"car_wash"];
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"WashPage" bundle:nil];
        WashPageViewController *washPageViewController = [storyborad instantiateViewControllerWithIdentifier:@"WashPageViewController"];
        NSInteger typeCarWash = [dict[@"car_wash_type_id"] integerValue];
        if(typeCarWash == 1)
        {
            washPageViewController.isOfflineWash = YES;
        }
        washPageViewController.dictInfo = dict;
        [self.navigationController pushViewController:washPageViewController animated:YES];    }
}

-(void)onCancelButton:(UIButton *)button
{
    [self cancelOrder:@"3"];
}

-(void)onCommentButton:(UIButton *)button
{
    [self showViewEnterComment];
}

-(void)cancelOrder:(NSString *)idOrder
{
    [[GetCancelOrderRequest alloc] getCancelOrderRequestByID:self.dictInfo[@"id"] completionHandler:^(NSDictionary *json)
     {
         [[[UIAlertView alloc] initWithTitle:@"Сообщение" message:@"Заказ отменен" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
         [self.navigationController popToRootViewControllerAnimated:YES];
     } errorHandler:^{
         
     }];
}

-(void)leaveComment:(NSString *)comment
{
    NSString *rating = [NSString stringWithFormat:@"%d",(int)self.ratingView.value];

    [[GetLeaveCommentRequest alloc] getLeaveCommentRequestByID:self.dictInfo[@"id"] comment:comment car_wash_id:self.dictInfo[@"car_wash_id"] mark:rating completionHandler:^(NSDictionary *json)
    {
        [[[UIAlertView alloc] initWithTitle:@"Сообщение" message:@"Спасибо!\nВы успешно оставили отзыв" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } errorHandler:^{
        
    }];
}

- (IBAction)onCommentDoneButton:(id)sender
{
    [self.commentTextView resignFirstResponder];
    [self.bgCommentView setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    NSString *comment = self.commentTextView.text;
    [self leaveComment:comment];
}

- (IBAction)onCancelOrderButton:(id)sender
{
    self.commentTextView.text = @"";
    [self.commentTextView resignFirstResponder];
    [self.bgCommentView setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

#pragma mark - Keyboard Notyfications Actions -

-(void)showViewEnterComment
{
    [self.bgCommentView setHidden:NO];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self.commentTextView becomeFirstResponder];
}

-(void)keyboardWillHide:(NSNotification*)notyfication
{
    [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:
     ^{
//         self.bottomConstraint.constant = 0;
         [self.view layoutIfNeeded];
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
    CGFloat  offset = rectKeyboard.size.height;
    [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:
     ^{
//         self.bottomConstraint.constant = offset;
         [self.view layoutIfNeeded];
     } completion:^(BOOL finished)
     {
         //empty
     }];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
