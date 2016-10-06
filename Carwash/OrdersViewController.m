//
//  OrdersViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/18/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "OrdersViewController.h"
#import "Carwash-Swift.h"
#import "DetailOrderViewController.h"

//Request
#import "GetAllOrderInfoRequest.h"

//Cell
#import "OrderCommentCell.h"
#import "OrderStableCell.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"


#define kOrderCommentCellID @"orderCommentCellID"
#define kOrderStableCellID  @"orderStableCellID"

@interface OrdersViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *infoArray;
@end

@implementation OrdersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.infoArray = [@[] copy];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationBarItem];
    [self request];
    [self setTitle:@"МОИ ЗАКАЗЫ"];
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

#pragma mark - UITableViewDelegate & Datasource -

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictInfo = self.infoArray[indexPath.row];
    
    BOOL isComment = NO;
    if(![dictInfo[@"review"] isKindOfClass:[NSNull class]])
    {
        isComment = YES;
    }
    
    if(isComment)
    {
        return 140;
    }
    else
    {
        return 100;
    }
    
    
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictInfo = self.infoArray[indexPath.row];
   // order_status_id = 1 // new
    NSInteger status = [dictInfo[@"order_status_id"] integerValue];
    NSString *statusText = dictInfo[@"order_status"] ? [NSString stringWithFormat:@"%@:",dictInfo[@"order_status"][@"status"]]:@"Заказ:";
    BOOL isComment = NO;
    if(![dictInfo[@"review"] isKindOfClass:[NSNull class]])
    {
        isComment = YES;
    }

    if(isComment)
    {
        OrderCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderCommentCellID];
        cell.orderStatusLabel.adjustsFontSizeToFitWidth = YES;
        
        if (status == -1)
            cell.orderStatusLabel.text = @"Не подтвержденный:";
        else if(status == 1)
            cell.orderStatusLabel.text = @"Подтвержденный заказ:";
        else if(status == 2)
            cell.orderStatusLabel.text = @"Выполненый заказ:";
        else if(status == 3)
            cell.orderStatusLabel.text = @"Отмененный заказ:";
        else if(status == 4)
            cell.orderStatusLabel.text = @"Отказ мойки:";
        
        if(![dictInfo[@"wash_time"] isKindOfClass:[NSNull class]] && dictInfo[@"wash_time"] != nil)
        {
            NSDictionary *dict = dictInfo[@"wash_time"];
            if(![dict[@"wash_time"] isKindOfClass:[NSNull class]] && dict[@"wash_time"] != nil)
            {
                cell.timeLabel.text      = dictInfo[@"wash_time"][@"wash_time"];
            }
            else
            {
                cell.timeLabel.text      = @"-:-";
            }
        }
        else
        {
            cell.timeLabel.text      = @"-:-";
        }
        
        cell.dateLabel.text      = [NSString stringWithFormat:@"(%@)",dictInfo[@"wash_date"]];
        cell.titleWashLabel.text = dictInfo[@"car_wash"][@"title"];
        cell.addressLabel.text   = dictInfo[@"car_wash"][@"address"];
        cell.priceLabel.text     = [NSString stringWithFormat:@"%@ руб.",dictInfo[@"cost"]];
        
        NSString *comment = dictInfo[@"review"][@"text"];
        NSString *answer  = dictInfo[@"review"][@"answer"];
        
        BOOL containAnswer = NO;
        BOOL containComment = NO;

        if(![answer isKindOfClass:[NSNull class]] && answer != nil )
        {
            if(answer.length)
            {
                containAnswer = YES;
            }
        }
        if(![comment isKindOfClass:[NSNull class]] && comment != nil )
        {
            if(comment.length)
            {
                containComment = YES;
            }
        }
        
        cell.commentLabel.text = containComment ? [NSString stringWithFormat:@"Отзыв:%@",comment]:@"";
        cell.answerCell.text = containAnswer ? [NSString stringWithFormat:@"Ответ:%@",answer]:@"";
        return cell;
    }
    else
    {
        OrderStableCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderStableCellID];
        cell.orderStatusLabel.adjustsFontSizeToFitWidth = YES;
        
        if (status == -1)
            cell.orderStatusLabel.text = @"Не подтвержденный:";
        else if(status == 1)
            cell.orderStatusLabel.text = @"Подтвержденный заказ:";
        else if(status == 2)
            cell.orderStatusLabel.text = @"Выполненый заказ:";
        else if(status == 3)
            cell.orderStatusLabel.text = @"Отмененный заказ:";
        else if(status == 4)
            cell.orderStatusLabel.text = @"Отказ мойки:";

        if(![dictInfo[@"wash_time"] isKindOfClass:[NSNull class]] && dictInfo[@"wash_time"] != nil)
        {
            NSDictionary *dict = dictInfo[@"wash_time"];
            if(![dict[@"wash_time"] isKindOfClass:[NSNull class]] && dict[@"wash_time"] != nil)
            {
                cell.timeLabel.text      = dictInfo[@"wash_time"][@"wash_time"];
            }
            else
            {
                cell.timeLabel.text      = @"-:-";
            }
        }
        else
        {
            cell.timeLabel.text      = @"-:-";
        }
        
        cell.dateLabel.text      = [NSString stringWithFormat:@"(%@)",dictInfo[@"wash_date"]];
        cell.titleWashLabel.text = dictInfo[@"car_wash"][@"title"];
        cell.addressLabel.text   = dictInfo[@"car_wash"][@"address"];
        cell.priceLabel.text     = [NSString stringWithFormat:@"%@ руб.",dictInfo[@"cost"]];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictInfo = self.infoArray[indexPath.row];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderBoard" bundle:nil];
    DetailOrderViewController *dtVC = [storyboard instantiateViewControllerWithIdentifier:@"DetailOrderViewController"];
    
    BOOL isComment = NO;
    if(![dictInfo[@"review"] isKindOfClass:[NSNull class]])
    {
        isComment = YES;
    }
    
    if(isComment)
    {
        NSString *comment = dictInfo[@"review"][@"text"];
        
        BOOL containComment = NO;
        
        if(![comment isKindOfClass:[NSNull class]] && comment != nil )
        {
            if(comment.length)
            {
                containComment = YES;
            }
        }
        
        dtVC.isCommented = containComment;
        dtVC.dictInfo = dictInfo;
    }
    else
    {
        dtVC.isCommented = NO;
        dtVC.dictInfo = dictInfo;
    }

    [self setTitle:@" "];
    [self.navigationController pushViewController:dtVC animated:YES];
}

-(void)request
{
    NSString *userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"userID"];
    
    if(userID.length == 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Ошибка при авторизации. Повторно авторизируйтесь" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil] show];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"closeMain" object:nil];
        });
        return;
    }
    [[GetAllOrderInfoRequest alloc] getAllOrderInfoRequest:@([userID integerValue]) completionHandler:^(NSDictionary *json)
    {
        self.infoArray = json[@"data"];
        [self.tableView reloadData];
    } errorHandler:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
