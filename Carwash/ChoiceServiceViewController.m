//
//  ChoiceServiceViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/9/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "ChoiceServiceViewController.h"
#import "ChoiceServiceCell.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"


#define kChoiceServiceCell 0
#define kChoiceServiceCellID @"choiceServiceCellID"

#define minCellHeight 30

@interface ChoiceServiceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) NSMutableArray *infoArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *chiceButton;

@end

@implementation ChoiceServiceViewController
- (IBAction)onChoiceButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrayServices = [[self.arrayServices filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"car_category_id LIKE %@",[NSString stringWithFormat:@"%ld",(long)self.typeOfCar]]] mutableCopy];
    
    self.infoArray = [@[] mutableCopy];
    self.title = @"Выбор услуг";
    [self setupInfo];
    [self.tableView setTableFooterView:[UIView new]];
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
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.currentServisesChoice removeAllObjects];
    for(NSDictionary *dict in self.infoArray)
    {
        if([dict[@"isOn"] integerValue] == 1)
        {
            [self.currentServisesChoice addObject:dict];
        }
    }
}

-(void)setupInfo
{
    NSMutableArray *dataMutableArray = [@[] mutableCopy];
    for(NSDictionary *dict in self.arrayServices)
    {
        NSNumber *numbOn = @0;
        for(NSDictionary *dictComing in self.currentServisesChoice)
        {
            if([dictComing[@"seviceId"] integerValue] == [dict[@"id"] integerValue])
            {
                numbOn = @1;
                break;
            }
        }
        [dataMutableArray addObject:@{
                                      @"isOn":numbOn,
                                      @"serviceName":dict[@"service"],
                                      @"seviceId":dict[@"id"],
                                      @"time":dict[@"time"],
                                      @"cost":dict[@"cost"]
                                      }];
    }
    self.infoArray = [dataMutableArray mutableCopy];
    
    [self updateViewFooter];
}

#pragma mark - UITableViewDelegate -

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = self.infoArray[indexPath.row][@"serviceName"];
    NSStringDrawingContext *ctx = [NSStringDrawingContext new];
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-49, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15.0]} context:ctx];
    
    return textRect.size.height + minCellHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChoiceServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:kChoiceServiceCellID];
    [self configurationChoiceServiceCell:cell index:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self switchCheckBox:indexPath.row];
}

-(void)switchCheckBox:(NSInteger)index
{
    NSMutableDictionary *dict = [self.infoArray[index] mutableCopy];
    NSNumber *isOn            = dict[@"isOn"];
    
    if([isOn integerValue])
    {
        [dict setObject:@0 forKey:@"isOn"];
    }
    else
    {
        [dict setObject:@1 forKey:@"isOn"];
    }
    
    [self.infoArray replaceObjectAtIndex:index withObject:dict];
    [self.tableView reloadData];
    [self updateViewFooter];
    
    [self.currentServisesChoice removeAllObjects];
    for(NSDictionary *dict in self.infoArray)
    {
        if([dict[@"isOn"] integerValue] == 1)
        {
            [self.currentServisesChoice addObject:dict];
        }
    }
    
}

-(void)updateViewFooter
{    
    CGFloat priceStart = 0;
    for(NSDictionary *dict in self.infoArray)
    {
        if([dict[@"isOn"] integerValue] == 1)
        {
            priceStart = priceStart + [dict[@"cost"] floatValue];
        }
    }
    
    NSString *price = [NSString stringWithFormat:@"Выбрать: %.2f p.",priceStart];
    [self.chiceButton setTitle:price forState:UIControlStateNormal];
}

- (void)configurationChoiceServiceCell:(ChoiceServiceCell*)cell index:(NSInteger)index
{
    
    NSString *servicePrice = self.infoArray[index][@"cost"];
    NSString *serviceName = self.infoArray[index][@"serviceName"];
    NSNumber *isOn        = self.infoArray[index][@"isOn"];

    cell.serviceLabel.text = serviceName;
    [cell.priceLabel setAdjustsFontSizeToFitWidth:YES];
    cell.priceLabel.text = servicePrice;
    if([isOn integerValue])
    {
        cell.checkImageView.image = [UIImage imageNamed:@"switch_on_galochka"];
    }
    else
    {
        cell.checkImageView.image = [UIImage imageNamed:@"switch_off_galochka"];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
