//
//  SelectServiceOnSearch.m
//  Carwash
//
//  Created by Andrei Sabinin on 10/1/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "SelectServiceOnSearch.h"
#import "GetServicesRequest.h"

#define kStandartCellID @"standartCellID"

@interface SelectServiceOnSearch ()

@property (nonatomic, strong) NSArray *arrayInfo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SelectServiceOnSearch

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayInfo = [@[] copy];
    [self setTitle:@"Услуги"];
    [self request];
}

#pragma mark - UITableViewDelegate & Datasource -

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayInfo[indexPath.row];
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayInfo.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStandartCellID];
    NSDictionary *dict = self.arrayInfo[indexPath.row];
    
    cell.textLabel.text = dict[@"service"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayInfo[indexPath.row];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.serviceDict setObject:dict[@"id"] forKey:@"serviceID"];
    [self.serviceDict setObject:dict[@"service" ] forKey:@"name"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)request
{
    __block NSString *carID = [NSString stringWithFormat:@"%@",self.carID];
    [[GetServicesRequest alloc] getServicesRequestCompletionHandler:^(NSDictionary *json)
    {
        NSArray *array = json[@"data"];
        self.arrayInfo = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"car_category_id LIKE %@",carID]];
        [self.tableView reloadData];
    } errorHandler:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
