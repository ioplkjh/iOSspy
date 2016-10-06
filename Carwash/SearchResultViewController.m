//
//  SearchResultViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/11/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchResultCell.h"
#import "GetSearchRequest.h"
#import "HCSStarRatingView.h"

#import "SearchOnMapViewController.h"

#import "LocationCore.h"
#import "GetallTimesRequest.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"


#define kSearchResultCellID @"searchResultCellID"

@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayInfo;
@property (nonatomic, strong) NSArray *arrayTime;

@end

@implementation SearchResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrayInfo = [@[] copy];
    [self timeRequest];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitle:@"Результаты поиска"];
    [self.tableView reloadData];
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

#pragma mark - UITableViewDelegate -

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *text = self.carsArray[indexPath.row][@"brand"];
//    NSStringDrawingContext *ctx = [NSStringDrawingContext new];
//    CGRect textRect = [text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15.0]} context:ctx];
//    
    return /*textRect.size.height + */110;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayInfo.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchResultCellID];
    [self configurationSearchResultCell:cell index:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayInfo[indexPath.row];
//    double dist = [[LocationCore sharedMenager] calculateDistanceLat:[dict[@"latitude"] doubleValue] lon:[dict[@"latitude"] doubleValue]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Search" bundle:nil];
    SearchOnMapViewController *searchOnMap = [storyboard instantiateViewControllerWithIdentifier:@"SearchOnMapViewController"];
    searchOnMap.arrayInfo      = [self.arrayInfo copy];
    searchOnMap.index = indexPath.row;
//    searchOnMap.dist           = dist;
    [self setTitle:@" "];
    
    [self.navigationController pushViewController:searchOnMap animated:YES];
}

- (void)configurationSearchResultCell:(SearchResultCell*)cell index:(NSInteger)index
{
    NSDictionary *dict = self.arrayInfo[index];
    
    NSInteger car_wash_type_id = [dict[@"car_wash_type_id"] integerValue];
    
    NSString *endTime   = dict[@"end_time"][@"wash_time"];
    NSString *startTime = dict[@"start_time"][@"wash_time"];

    cell.titleWashLabel.text = dict[@"title"];
    
    {
        NSDictionary *wasTimeWork = dict[@"work_time"];
        
        NSDictionary *timeCommonStart = [self.arrayTime filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id LIKE %@",[NSString stringWithFormat:@"%@",wasTimeWork[@"start_wash_time_id"]]]].lastObject;
        
        NSDictionary *timeCommonEnd = [self.arrayTime filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id LIKE %@",[NSString stringWithFormat:@"%@",wasTimeWork[@"end_wash_time_id"]]]].lastObject;
        
        NSString *timeStart = timeCommonStart[@"wash_time"];
        NSString *timeEnd   = timeCommonEnd[@"wash_time"];
        NSString *time    = [NSString stringWithFormat:@"%@ - %@",timeStart,timeEnd];
        
        cell.timeLabel.text = time;
    }
    cell.addressLabel.text = dict[@"address"];
    cell.streenLabel.text = dict[@""];
    cell.badgeNumber.text = [NSString stringWithFormat:@"%d",index];
    if(car_wash_type_id == 1)
    {
        cell.ImageBableView.image = [UIImage imageNamed:@"sign_active_but_not_time_clear"];
    }
    if(car_wash_type_id == 2)
    {
        cell.ImageBableView.image = [UIImage imageNamed:@"sign_no_active_clear"];
    }
    if(car_wash_type_id == 3)
    {
        cell.ImageBableView.image = [UIImage imageNamed:@"sign_active_clear"];
    }
    double dist = [[LocationCore sharedMenager] calculateDistanceLat:[dict[@"latitude"] doubleValue] lon:[dict[@"longitude"] doubleValue]];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.2f",dist];
    cell.rating.value = [dict[@"rating"] integerValue];
}

-(void)request
{
    NSDictionary *dict = self.infoDict;
    
    [[GetSearchRequest alloc] getSearchRequestDayId:dict[@"dayId"]
                                additional_services:dict[@"services"]
                                       time_id_from:dict[@"idTimeFrom"]
                                         time_id_to:dict[@"idTimeTo"]
                                         min_rating:[NSString stringWithFormat:@"%ld",[dict[@"rating"] integerValue]]
                                       car_model_id:dict[@"car_category_id"]
                                    wash_service_id:dict[@"serviceID"]
                                  completionHandler:^(NSDictionary *json)
    {
        NSArray *filtered = [json[@"data"] copy];
        NSMutableArray *finishedArray = [@[] mutableCopy];
        for(NSDictionary *dict in filtered)
        {
            double dist = [[LocationCore sharedMenager] calculateDistanceLat:[dict[@"latitude"] doubleValue] lon:[dict[@"longitude"] doubleValue]];
            if(dist < 21.0)
            {
                [finishedArray addObject:dict];
            }
        }
        self.arrayInfo = [finishedArray copy];
        [self.tableView reloadData];
     } errorHandler:^{
        
    }];
}

-(void)timeRequest
{
    self.tableView.userInteractionEnabled = NO;
    [[GetallTimesRequest alloc] getAllTimesRequest:^(NSDictionary *json)
     {
         self.arrayTime = [json[@"data"] copy];
         self.tableView.userInteractionEnabled = YES;
         [self.tableView reloadData];
         [self request];
     } errorHandler:^{
         self.tableView.userInteractionEnabled = YES;
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
