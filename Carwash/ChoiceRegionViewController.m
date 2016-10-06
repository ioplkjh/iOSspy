//
//  ChoiceRegionViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/15/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "ChoiceRegionViewController.h"

#define kRegionCellID @"regionCellID"

@interface ChoiceRegionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *regions;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChoiceRegionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadRegions];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillDisappear:animated];
}

#pragma mark - UITableViewDelegate -

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.regions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRegionCellID];
    NSDictionary *infoDict = self.regions[indexPath.row];
    cell.textLabel.text = infoDict[@"region"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    NSDictionary *infoDict = self.regions[index];
    self.regionDict[@"region"] = infoDict[@"region"];
    self.regionDict[@"id"]     = infoDict[@"id"];

    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadRegions
{
    AppDelegate *appDel = SharedAppDelegate;
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile:appDel.pathRegions];
    NSArray *regions = [savedStock objectForKey:@"Regions"];
    self.regions = regions;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
