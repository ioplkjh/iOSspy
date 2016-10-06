//
//  SearchViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/3/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//
#import "SearchResultViewController.h"
#import "OunCarsViewController.h"
#import "SelectServiceOnSearch.h"

//Data
#import "StatusServicesSearch.h"
#import "SearchViewController.h"

//Cells
#import "SelectServicesCell.h"
#import "SelectRatingsCell.h"
#import "SelectTimeCell.h"
#import "SelectPriceCell.h"
#import "NMRangeSlider.h"
#import "Carwash-Swift.h"

#import "GetAllTimesRequest.h"

#import "HCSStarRatingView.h"

#define kSearchCell 0
#define kPlaceCell  1
#define kTimeCell   2
#define kPriceCell  3
//#define kSearchCell 0

#define kSearchCellID   @"selectServicesCellID"
#define kRatingsCellID  @"selectRatingsCellID"
#define kTimeCellID     @"selectTimeCellID"
#define kPriceCellID    @"selectPriceCellID"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) StatusServicesSearch *statusServicesSearch;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) CGFloat rating;
@property (nonatomic, assign) TypeTimeButton typeCurrentTimeButtonTag;
@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) NSString *timeValues;

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic, assign) BOOL isDefautSettings;
@property (nonatomic, strong) NSMutableDictionary *currentCar;
@property (nonatomic, strong) NSMutableDictionary *infoDict;
@property (nonatomic, strong) NSMutableDictionary *serviceDict;


@property (nonatomic, strong) NSArray *timeArray;
@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.serviceDict = [@{} mutableCopy];
    self.rating = 0;
    self.currentCar = [@{} mutableCopy];
    self.infoDict = [@{} mutableCopy];
    self.isDefautSettings = YES;
    [self setupData];
    self.title = @"ПОИСК";
    self.tableView.userInteractionEnabled = NO;
    [[GetallTimesRequest alloc] getAllTimesRequest:^(NSDictionary *json)
    {
        self.timeArray = [json[@"data"] copy];
        self.tableView.userInteractionEnabled = YES;
    } errorHandler:^{
        self.tableView.userInteractionEnabled = YES;
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setNavigationBarItem];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"ПОИСК";
    [self.tableView reloadData];
}
-(void)setupData
{
    self.timeValues = @"0:00 - 0:00";

    self.statusServicesSearch = [StatusServicesSearch new];
    
    self.statusServicesSearch.isEnableWiFi      = NO;
    self.statusServicesSearch.isEnableCoffe     = NO;
    self.statusServicesSearch.isEnablePayment   = NO;
    self.statusServicesSearch.isEnableComfort   = NO;
    self.statusServicesSearch.isEnableWC        = NO;
    
    self.typeCurrentTimeButtonTag = kTommorowTag;
    
    self.buttonArray = [@[
                         @{@"title":@"9:00",  @"selected":@(1)},
                         @{@"title":@"9:30",  @"selected":@(0)},
                         @{@"title":@"10:00", @"selected":@(0)},
                         @{@"title":@"10:30", @"selected":@(1)},
                         @{@"title":@"11:00", @"selected":@(0)},
                         @{@"title":@"11:30", @"selected":@(1)},
                         @{@"title":@"12:00", @"selected":@(0)},
                         @{@"title":@"12:30", @"selected":@(1)},
                         @{@"title":@"13:00", @"selected":@(0)},
                         @{@"title":@"13:30", @"selected":@(1)},
                         @{@"title":@"14:00", @"selected":@(0)},
                         @{@"title":@"14:30", @"selected":@(1)},
                         @{@"title":@"15:00", @"selected":@(0)}
                         ] mutableCopy];
}

#pragma mark - UITableViewDelegate -

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case kSearchCell:
        {
            return 90;
            break;
        }
        case kPlaceCell:
        {
            return 70;
            break;
        }
        case kTimeCell:
        {
            return 140;
            break;
        }
        case kPriceCell:
        {
            return  180;
            break;
        }
        default:
        {
            return 0;
            break;
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case kSearchCell:
        {
            SelectServicesCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchCellID];
            [self configurationSearchCell:cell status:self.statusServicesSearch];
            return cell;
            break;
        }
        case kPlaceCell:
        {
            SelectRatingsCell *cell = [tableView dequeueReusableCellWithIdentifier:kRatingsCellID];
            [self configurationPlaceCell:cell];
            return cell;
            break;
        }
        case kTimeCell:
        {
            SelectTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeCellID];
            [cell.rangeSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
            
            [cell.rangeSlider setStepValue:0.5];
            [cell.rangeSlider setStepValueContinuously:YES];
            [cell.rangeSlider setMaximumValue:23.59];
            [cell.rangeSlider setMinimumValue:0];
            if(self.isDefautSettings)
            {
                [cell.rangeSlider setUpperValue:23.59 animated:NO];
                [cell.rangeSlider setLowerValue:0 animated:NO];
                
                float minV = cell.rangeSlider.lowerValue;
                float maxV = cell.rangeSlider.upperValue;
                
                int minVI =(int)minV;
                int maxVI =(int)maxV;
                
                float minVF = (float)minVI;
                float maxVF = (float)maxVI;

                NSString *strMinV = [NSString stringWithFormat:@"%i:00",minVI];
                NSString *strMaxV = [NSString stringWithFormat:@"%i:00",maxVI];
                
                if(minVF < minV)
                    strMinV = [NSString stringWithFormat:@"%i:30",minVI];
                if(minVF < 10)
                    strMinV = [NSString stringWithFormat:@"0%i:30",minVI];
                if(minVF == 0)
                    strMinV = [NSString stringWithFormat:@"0%i:00",minVI];
                
                if (maxVF < maxV)
                    strMaxV = [NSString stringWithFormat:@"%i:30",maxVI];
                if (maxVF < 10)
                    strMaxV = [NSString stringWithFormat:@"0%i:30",maxVI];
                if (maxVF == 0)
                    strMaxV = [NSString stringWithFormat:@"0%i:00",maxVI];
                
                [self.infoDict setObject:strMinV forKey:@"minT"];
                [self.infoDict setObject:strMaxV forKey:@"maxT"];
                
                self.timeValues = [NSString stringWithFormat:@"%@ - %@",strMinV,strMaxV];
            }
            [self configurationTimeCell:cell];
            return  cell;
            break;
        }
        case kPriceCell:
        {
            SelectPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:kPriceCellID];
            [self configurationPriceCell:cell];
            return  cell;
            break;
        }
        default:
        {
            return nil;
            break;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.textField resignFirstResponder];
    [self.tableView endEditing:YES];
}

-(void)valueChanged:(NMRangeSlider*)slider
{
    self.isDefautSettings = NO;
    
    float minV = slider.lowerValue;
    float maxV = slider.upperValue;
    
    int minVI =(int)minV;
    int maxVI =(int)maxV;
    
    float minVF = (float)minVI;
    float maxVF = (float)maxVI;
    
    NSString *strMinV = [NSString stringWithFormat:@"%i:00",minVI];
    NSString *strMaxV = [NSString stringWithFormat:@"%i:00",maxVI];

    if(minVF < minV)
    {
        strMinV = [NSString stringWithFormat:@"%i:30",minVI];
        if(minVF < 10)
            strMinV = [NSString stringWithFormat:@"0%i:30",minVI];
    }
    else
    {
        strMinV = [NSString stringWithFormat:@"%i:00",minVI];
        
        if(minVF < 10)
            strMinV = [NSString stringWithFormat:@"0%i:00",minVI];
    }
   
    if(minV == 0)
        strMinV = [NSString stringWithFormat:@"0%i:00",minVI];
    
    if (maxVF < maxV)
    {
        strMaxV = [NSString stringWithFormat:@"%i:30",maxVI];
        
        if (maxVF < 10)
            strMaxV = [NSString stringWithFormat:@"0%i:30",maxVI];
    }
    else
    {
        strMaxV = [NSString stringWithFormat:@"%i:00",maxVI];
        
        if (maxVI < 10)
            strMaxV = [NSString stringWithFormat:@"0%i:00",maxVI];
    }
    
    if (maxV == 0)
        strMaxV = [NSString stringWithFormat:@"0%i:00",maxVI];
    
    self.timeValues = [NSString stringWithFormat:@"%@ - %@",strMinV,strMaxV];
    //Wrire
    [self.infoDict setObject:strMinV forKey:@"minT"];
    [self.infoDict setObject:strMaxV forKey:@"maxT"];

    [self.tableView reloadData];
}

-(void)configurationSearchCell:(UITableViewCell*)cell status:(StatusServicesSearch*)searchService
{
    SelectServicesCell *cellInternal = (SelectServicesCell*)cell;
    if(cell == nil)
    {
        cell = [[SelectServicesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSearchCellID];
    }

    [cellInternal.buttonWiFi addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [cellInternal.buttonCoffe addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [cellInternal.buttonPay addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [cellInternal.buttonComfort addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [cellInternal.buttonWC addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];

    if(searchService.isEnableWiFi)
        [cellInternal setButtonWiFiActive];
    else
        [cellInternal setButtonWiFiUnActive];
    
    if(searchService.isEnableCoffe)
        [cellInternal setButtonCoffeActive];
    else
        [cellInternal setButtonCoffeUnActive];
    
    if(searchService.isEnablePayment)
        [cellInternal setButtonPayActive];
    else
        [cellInternal setButtonPayUnActive];
    
    if(searchService.isEnableComfort)
        [cellInternal setButtonComfortActive];
    else
        [cellInternal setButtonComfortUnActive];
    
    if(searchService.isEnableWC)
        [cellInternal setButtonWCActive];
    else
        [cellInternal setButtonWCUnActive];

}

-(void)configurationPlaceCell:(SelectRatingsCell*)cell
{
    [cell.ratingView addTarget:self action:@selector(changeRating:) forControlEvents:UIControlEventValueChanged];
}

-(void)changeRating:(HCSStarRatingView*)rView
{
    self.rating = rView.value;
    [self.infoDict setObject:[NSString stringWithFormat:@"%f",self.rating] forKey:@"rating"];
}

-(void)configurationPriceCell:(UITableViewCell*)cell
{
    SelectPriceCell *priceCell = (SelectPriceCell*)cell;
//    self.textField = priceCell.textFieldPrice;
    
    NSString *check = [NSString stringWithFormat:@"%@",self.currentCar[@"number"]];
    if( check.length > 0 && ![check isEqualToString:@"(null)"])
    {
        priceCell.carInfoLabel.text = [NSString stringWithFormat:@"%@, %@",self.currentCar[@"brand"],self.currentCar[@"model"]];
    }
    else
    {
        priceCell.carInfoLabel.text = [NSString stringWithFormat:@"Марка, модель"];
    }
    
    NSString *service = [NSString stringWithFormat:@"%@",self.serviceDict[@"serviceID"]];
    if( service.length > 0 && ![service isEqualToString:@"(null)"])
    {
        priceCell.servicesInfoLabel.text = [NSString stringWithFormat:@"%@",self.serviceDict[@"name"]];
    }
    else
    {
        priceCell.servicesInfoLabel.text = [NSString stringWithFormat:@"Выберите сервис"];
    }
    
    [priceCell.carToButton addTarget:self action:@selector(onCarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [priceCell.serviceButton addTarget:self action:@selector(onServiceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [priceCell.deleteButton addTarget:self action:@selector(onClearButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onCarButtonPressed:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MarkModelNumber" bundle:nil];
    OunCarsViewController *ounCarsViewController = [storyboard instantiateViewControllerWithIdentifier:@"OunCarsViewController"];
    [self setTitle:@" "];
    ounCarsViewController.currentCar = self.currentCar;
    [self.navigationController pushViewController:ounCarsViewController animated:YES];
}

- (void)onServiceButtonPressed:(id)sender
{
    NSString *car_category_id = self.currentCar[@"car_category_id"];
    if(!car_category_id)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Укажите машину" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ChoiceService" bundle:nil];
    SelectServiceOnSearch *ssVC = [storyboard instantiateViewControllerWithIdentifier:@"SelectServiceOnSearch"];
    ssVC.serviceDict = self.serviceDict;
    ssVC.carID = car_category_id;
    self.title = @" ";
    [self.navigationController pushViewController:ssVC animated:YES];
}

-(void)configurationTimeCell:(UITableViewCell*)cell
{
    //Deselect

    SelectTimeCell *timeCell = (SelectTimeCell*)cell;
    [timeCell.timeLabel setText:self.timeValues];
    [timeCell.todayButton addTarget:self action:@selector(onTimeButton:) forControlEvents:UIControlEventTouchUpInside];
    [timeCell.todayButton setTag:kTodayTag];
    
    if(self.typeCurrentTimeButtonTag == kTodayTag)
    {
        [timeCell.todayButton setBackgroundImage:[UIImage imageNamed:@"button_dark"] forState:UIControlStateNormal];
    }
    else
    {
        [timeCell.todayButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
    }
    
    [timeCell.tommorowDayButton addTarget:self action:@selector(onTimeButton:) forControlEvents:UIControlEventTouchUpInside];
    [timeCell.tommorowDayButton setTag:kTommorowTag];
    if(self.typeCurrentTimeButtonTag == kTommorowTag)
    {
        [timeCell.tommorowDayButton setBackgroundImage:[UIImage imageNamed:@"button_dark"] forState:UIControlStateNormal];
    }
    else
    {
        [timeCell.tommorowDayButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
    }
    [timeCell.dayAfterTommorowButton addTarget:self action:@selector(onTimeButton:) forControlEvents:UIControlEventTouchUpInside];
    [timeCell.dayAfterTommorowButton setTag:kDayAfterTommorowag];
    if(self.typeCurrentTimeButtonTag == kDayAfterTommorowag)
    {
        [timeCell.dayAfterTommorowButton setBackgroundImage:[UIImage imageNamed:@"button_dark"] forState:UIControlStateNormal];
    }
    else
    {
        [timeCell.dayAfterTommorowButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
    }
    
    [timeCell setupCarButtonFromArayContent:self.buttonArray];
}

-(void)onTimeButton:(UIButton*)button
{
    
    switch (button.tag) {
        case kTodayTag:
        {
            self.typeCurrentTimeButtonTag = kTodayTag;
            break;
        }
        case kTommorowTag:
        {
            self.typeCurrentTimeButtonTag = kTommorowTag;
            break;
        }
        case kDayAfterTommorowag:
        {
            self.typeCurrentTimeButtonTag = kDayAfterTommorowag;
            break;
        }
        default:
            break;
    }
    
    [self.tableView reloadData];
}

-(void)selectButton:(UIButton*)button
{
    NSInteger tag = button.tag;
    switch (tag)
    {
        case kWifiTag:
        {
            self.statusServicesSearch.isEnableWiFi = !self.statusServicesSearch.isEnableWiFi;
            break;
        }
        case kCoffeTag:
        {
            self.statusServicesSearch.isEnableCoffe = !self.statusServicesSearch.isEnableCoffe;
            break;
        }
        case kPayTag:
        {
            self.statusServicesSearch.isEnablePayment = !self.statusServicesSearch.isEnablePayment;
            break;
        }
        case kComfortTag:
        {
            self.statusServicesSearch.isEnableComfort = !self.statusServicesSearch.isEnableComfort;
            break;
        }
        case kWCTag:
        {
            self.statusServicesSearch.isEnableWC = !self.statusServicesSearch.isEnableWC;
            break;
        }
        default:
            break;
    }
    [self.tableView reloadData];
}

-(void)didSelectCarButton:(UIButton*)button
{
    NSInteger index = button.tag;
    NSMutableDictionary *dict = [[self.buttonArray objectAtIndex:index] mutableCopy];
    NSInteger status = [dict[@"selected"] integerValue];
    if(status == 1)
        [dict setObject:@0 forKey:@"selected"];
    else
        [dict setObject:@1 forKey:@"selected"];
    
    [self.buttonArray replaceObjectAtIndex:index withObject:[dict copy]];
    [self.tableView reloadData];
}

- (IBAction)onSearchButon:(UIButton *)sender
{
    NSString *car_category_id = self.currentCar[@"car_category_id"];
    if(!car_category_id)
    {
        [self.infoDict setObject:@"" forKey:@"car_category_id"];
    }
    else
    {
        [self.infoDict setObject:car_category_id forKey:@"car_category_id"];
    }
    
    
    
    NSString *minT = self.infoDict[@"minT"];
    NSString *maxT = self.infoDict[@"maxT"];
    
    NSArray *times = [self.timeArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"wash_time LIKE %@",minT]];
    
    NSString *idTimeFrom = times.lastObject[@"id"];
    
    times = [self.timeArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"wash_time LIKE %@",maxT]];
    NSString *idTimeTo   = times.lastObject[@"id"];

    [self.infoDict setObject:idTimeFrom forKey:@"idTimeFrom"];
    [self.infoDict setObject:idTimeTo   forKey:@"idTimeTo"];

    NSString *dayId = @"1";
    switch (self.typeCurrentTimeButtonTag) {
        case kTodayTag:
        {
            dayId = @"1";
            break;
        }
        case kTommorowTag:
        {
            dayId = @"2";
            break;
        }
        case kDayAfterTommorowag:
        {
            dayId = @"3";
            break;
        }
        default:
            break;
    }

    [self.infoDict setObject:dayId forKey:@"dayId"];
    [self.infoDict setObject:[NSString stringWithFormat:@"%f",self.rating] forKey:@"rating"];
    
    NSMutableString *services = [@"" mutableCopy];
    [services appendString:@"["];
    if(self.statusServicesSearch.isEnableWC)
    {
        [services appendString:@"1,"];
    }
    if(self.statusServicesSearch.isEnableWiFi)
    {
        [services appendString:@"2,"];
    }
    if(self.statusServicesSearch.isEnableCoffe)
    {
        [services appendString:@"3,"];
    }
    if(self.statusServicesSearch.isEnablePayment)
    {
        [services appendString:@"4,"];
    }
    if(self.statusServicesSearch.isEnableComfort)
    {
        [services appendString:@"5,"];
    }
    [services appendString:@"]"];
    NSString *servicesEnd = [services stringByReplacingOccurrencesOfString:@",]" withString:@"]"];
    servicesEnd = [servicesEnd stringByReplacingOccurrencesOfString:@"[]" withString:@""];
    [self.infoDict setObject:servicesEnd forKey:@"services"];
    NSString *serviceID =  self.serviceDict[@"serviceID"];
    
    if(!serviceID)
    {
        [self.infoDict setObject:@"" forKey:@"serviceID"];
    }
    else
    {
        [self.infoDict setObject:serviceID forKey:@"serviceID"];
    }
    
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Search" bundle:nil];
    SearchResultViewController *searchResultViewController = [storyborad instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
    searchResultViewController.infoDict = [self.infoDict copy];
    self.title = @" ";
    [self.navigationController pushViewController:searchResultViewController animated:YES];
}

-(void)onClearButton:(id)sender
{
    self.currentCar = [@{} mutableCopy];
    self.serviceDict = [@{} mutableCopy];
    [self.infoDict setObject:@"" forKey:@"serviceID"];
    [self.infoDict setObject:@"" forKey:@"car_category_id"];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
