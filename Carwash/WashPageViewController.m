//
//  WashPageViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/8/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "WashPageViewController.h"
#import "HCSStarRatingView.h"
#import "GetallTimesRequest.h"
#import "GetWashInfoRequest.h"
#import "GetClientOrderAdd.h"

#import "ChoiceServiceViewController.h"
#import "OunCarsViewController.h"
#import "CommentsViewController.h"
#import "DetailInfoMapViewController.h"

#import "LocalNotificationManager.h"

//Cells
#import "TopButtonCell.h"
#import "InfoWashCell.h"
#import "WashSelectTimeCell.h"
#import "CarInfoCell.h"
#import "ConfirmBotCell.h"
#import "OfflineCell.h"

//Indexs
#define kInfoWashCell           0
#define kTopButtonCell          1
#define kWashSelectTimeCell     2

#define kOfflineCell            2 // offline

#define kCarInfoCell            3
#define kConfirmBotCell         4

//IDs
#define kTopButtonCellID        @"topButtonCellID"
#define kInfoWashCellID         @"infoWashCellID"
#define kWashSelectTimeCellID   @"washSelectTimeCellID"

#define kOfflineCellID          @"offlineCellID"

#define kCarInfoCellID          @"carInfoCellID"
#define kConfirmBotCellID       @"confirmBotCellID"

@interface WashPageViewController ()<UITableViewDataSource,UITableViewDelegate,WashSelectTimeCellDelegate,UIActionSheetDelegate>

@property (nonatomic ,strong) NSMutableArray *buttonArray;

@property (nonatomic ,assign) TypeTimeButton typeCurrentTimeButtonTag;
@property (nonatomic ,weak)   IBOutlet UITableView *tableView;

//Times
@property (nonatomic ,strong) NSMutableArray *todayArray;
@property (nonatomic ,strong) NSMutableArray *tomorrowArray;
@property (nonatomic ,strong) NSMutableArray *yesterdayArray;
@property (nonatomic, assign) NSInteger currentTimeIndex;
//DT
@property (nonatomic, strong) NSMutableArray *servicesArray;
@property (nonatomic, strong) NSMutableArray *commentsArray;

@property (nonatomic, strong) NSMutableArray *additionalServices;

//P
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSMutableDictionary *currentCar;
@property (nonatomic, strong) NSMutableArray *currentServisesChoice;
@property (nonatomic, assign) BOOL isRemember;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *washID;
@property (nonatomic,assign) double rating;
@property (nonatomic,assign) double latWash;
@property (nonatomic,assign) double lonWash;


@property (nonatomic, strong) NSArray *arrayTime;
@property (nonatomic ,strong) NSArray *washTimesArray;
@end

@implementation WashPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentCar = [@{} mutableCopy];
    self.currentServisesChoice = [@[] mutableCopy];
    self.typeCurrentTimeButtonTag = kTommorowTag;
    [self setupButtonDataDefault:[self getcurrentArrayTime]];
    [self timeRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitle:@"Ближайшая автомойка"];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate -

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isOfflineWash)
    {
        switch (indexPath.row)
        {
            case kTopButtonCell:
            {
                return 56;
                break;
            }
            case kInfoWashCell:
            {
                return 95;
                break;
            }
            case kOfflineCell:
            {
                return 350;
                break;
            }
            default:
            {
                return 0;
                break;
            }
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case kTopButtonCell:
            {
                return 56;
                break;
            }
            case kInfoWashCell:
            {
                return 95;
                break;
            }
            case kWashSelectTimeCell:
            {
                return 140;
                break;
            }
            case kCarInfoCell:
            {
                return 67;
                break;
            }
            case kConfirmBotCell:
            {
                return 195;
                break;
            }
            default:
            {
                return 0;
                break;
            }
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isOfflineWash)
    {
        return 3;
    }
    else
    {
        return 5;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isOfflineWash)
    {
        switch (indexPath.row)
        {
            case kTopButtonCell:
            {
                TopButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kTopButtonCellID];
                [self configurationTopButtonCell:cell];
                return cell;
                break;
            }
            case kInfoWashCell:
            {
                InfoWashCell *cell = [tableView dequeueReusableCellWithIdentifier:kInfoWashCellID];
                [self configurationInfoWashCell:cell index:indexPath.row];
                return cell;
                break;
            }
            case kOfflineCell:
            {
                OfflineCell *cell = [tableView dequeueReusableCellWithIdentifier:kOfflineCellID];
                [cell.sendButton addTarget:self action:@selector(onSendButton:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.midLabel.text = @"Эта мойка\nещё не доступна\nдля онлайн записи";
                cell.midLabel.numberOfLines = 3;
                cell.botLabel.text = @"Сообщите нам, если Вы хотите использовать\n запись онлайн для этой автомойки";
                cell.botLabel.numberOfLines = 2;
                return cell;
                break;
            }
            default:
            {
                return nil;
                break;
            }
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case kTopButtonCell:
            {
                TopButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kTopButtonCellID];
                [self configurationTopButtonCell:cell];
                return cell;
                break;
            }
            case kInfoWashCell:
            {
                InfoWashCell *cell = [tableView dequeueReusableCellWithIdentifier:kInfoWashCellID];
                [self configurationInfoWashCell:cell index:indexPath.row];
                return cell;
                break;
            }
            case kWashSelectTimeCell:
            {
                WashSelectTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:kWashSelectTimeCellID];
                [self configurationWashSelectTimeCell:cell];
                return cell;
                break;
            }
            case kCarInfoCell:
            {
                CarInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCarInfoCellID];
                [self configurationCarInfoCell:cell];
                return cell;
                break;
            }
            case kConfirmBotCell:
            {
                ConfirmBotCell *cell = [tableView dequeueReusableCellWithIdentifier:kConfirmBotCellID];
                [self configurationConfirmBotCell:cell];
                return cell;
                break;
            }
            default:
            {
                return nil;
                break;
            }
        }
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == kCarInfoCell)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MarkModelNumber" bundle:nil];
        OunCarsViewController *ounCarsViewController = [storyboard instantiateViewControllerWithIdentifier:@"OunCarsViewController"];
        [self setTitle:@" "];
        ounCarsViewController.currentCar = self.currentCar;
        [self.navigationController pushViewController:ounCarsViewController animated:YES];
    }
}

- (void)configurationTopButtonCell:(TopButtonCell*)cell
{
    [cell.onMapButton addTarget:self action:@selector(onMapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.onNaviButton addTarget:self action:@selector(onNaviButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.onCallButton addTarget:self action:@selector(onCallButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.onCommentsButton addTarget:self action:@selector(onCommentsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
 
}

- (void)configurationInfoWashCell:(InfoWashCell*)cell index:(NSInteger)index
{
    //Данные с сервера
    //пора заполнить уже

    [cell.wifiImageView         setImage:[UIImage imageNamed:@"uslugi_icon_wifi"]];
    [cell.coffeImageView        setImage:[UIImage imageNamed:@"uslugi_icon_coffee"]];
    [cell.payImageView          setImage:[UIImage imageNamed:@"uslugi_icon_payment"]];
    [cell.comfortImageView      setImage:[UIImage imageNamed:@"uslugi_icon_comfort"]];
    [cell.wcImageView           setImage:[UIImage imageNamed:@"uslugi_icon_wc"]];
    
    BOOL isHaveWiFi     = [self isHaveByID:2];
    BOOL isHaveCoffe    = [self isHaveByID:3];
    BOOL isHavePayment  = [self isHaveByID:4];
    BOOL isHaveComfort  = [self isHaveByID:5];
    BOOL isHaveWC       = [self isHaveByID:1];

    if(isHaveWiFi)
        [cell.wifiImageView setImage:[UIImage imageNamed:@"uslugi_icon_wifi_active"]];
    if(isHaveCoffe)
        [cell.coffeImageView setImage:[UIImage imageNamed:@"uslugi_icon_coffee_active"]];
    if(isHavePayment)
        [cell.payImageView setImage:[UIImage imageNamed:@"uslugi_icon_payment_active"]];
    if(isHaveComfort)
        [cell.comfortImageView setImage:[UIImage imageNamed:@"uslugi_icon_comfort_active"]];
    if(isHaveWC)
        [cell.wcImageView setImage:[UIImage imageNamed:@"uslugi_icon_wc_active"]];
    
    cell.addressLabel.text  = self.address;
    cell.timeLabel.text     = self.time;
    cell.ratingView.value   = (int)self.rating/2;
}

- (void)configurationWashSelectTimeCell:(WashSelectTimeCell*)cell
{
    [cell.todayButton addTarget:self action:@selector(onTimeButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.todayButton setTag:kTodayTag];
    
    if(self.typeCurrentTimeButtonTag == kTodayTag)
    {
        [cell.todayButton setBackgroundImage:[UIImage imageNamed:@"button_dark"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.todayButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
    }
    
    [cell.tommorowDayButton addTarget:self action:@selector(onTimeButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.tommorowDayButton setTag:kTommorowTag];
    if(self.typeCurrentTimeButtonTag == kTommorowTag)
    {
        [cell.tommorowDayButton setBackgroundImage:[UIImage imageNamed:@"button_dark"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.tommorowDayButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
    }
    [cell.dayAfterTommorowButton addTarget:self action:@selector(onTimeButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.dayAfterTommorowButton setTag:kDayAfterTommorowag];
    if(self.typeCurrentTimeButtonTag == kDayAfterTommorowag)
    {
        [cell.dayAfterTommorowButton setBackgroundImage:[UIImage imageNamed:@"button_dark"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.dayAfterTommorowButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
    }
    [cell setDelegate:self];
    [cell setupCarButtonFromArayContent:self.buttonArray];
}

-(void)configurationCarInfoCell:(CarInfoCell*)cell
{
    
    NSString *model = self.currentCar[@"model"];
    NSString *brand = self.currentCar[@"brand"];
    NSString *number = self.currentCar[@"number"];
    if(model.length && brand.length && number.length)
    {
        cell.modelLabel.text  = [NSString stringWithFormat:@"%@, %@",brand,model];
        cell.numberLabel.text = [NSString stringWithFormat:@"%@",number];
    }
    else
    {
        cell.modelLabel.text = @"МАРКА, МОДЕЛЬ";
    }
    
}

-(void)configurationConfirmBotCell:(ConfirmBotCell*)cell
{
    [cell.choiceServiceButton addTarget:self action:@selector(onChoiceServiceButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.priceLabel.text     = [self getPriceValue];
    cell.timeSpendLabel.text = [self getTimeValue];
    [cell.orderConformButton addTarget:self action:@selector(onOrderConformButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.switchHalfControll addTarget:self action:@selector(onToggleOnOff:) forControlEvents:UIControlEventValueChanged];
}

-(void)onToggleOnOff:(UISwitch*)switchButton
{
    self.isRemember = switchButton.on;
}


-(NSString*)getPriceValue
{
    CGFloat priceStart = 0;
    for(NSDictionary *dict in self.currentServisesChoice)
    {
        priceStart = priceStart + [dict[@"cost"] floatValue];
    }
    if(priceStart == 0)
    {
        return  @"Стоимость: n/a";
    }
    NSString *price = [NSString stringWithFormat:@"Стоимость: %.2f p.",priceStart];
    return price;
}
-(NSString*)getTimeValue
{
    CGFloat timeStart = 0;
    for(NSDictionary *dict in self.currentServisesChoice)
    {
        timeStart = timeStart + [dict[@"time"] floatValue];
    }
    if(timeStart == 0)
    {
        return  @"Длительность: n/a";
    }
    NSString *time = [NSString stringWithFormat:@"Длительность: %d мин.",(int)timeStart];
    return time;
}
//ChekedTimeDay
-(void)onTimeButton:(UIButton*)button
{
    switch (button.tag) {
        case kTodayTag:
        {
            self.typeCurrentTimeButtonTag = kTodayTag;
            [self setupButtonDataDefault:self.todayArray];
            break;
        }
        case kTommorowTag:
        {
            self.typeCurrentTimeButtonTag = kTommorowTag;
            [self setupButtonDataDefault:self.tomorrowArray];
            break;
        }
        case kDayAfterTommorowag:
        {
            self.typeCurrentTimeButtonTag = kDayAfterTommorowag;
            [self setupButtonDataDefault:self.yesterdayArray];
            break;
        }
        default:
            break;
    }
    
    [self.tableView reloadData];
}

-(void)didSelectCarButton:(UIButton*)button
{
    [self setupButtonDataDefault:[self getcurrentArrayTime]];
    
    if(self.buttonArray.count == 0)
        return;
    
    NSInteger index = button.tag;
    self.currentTimeIndex = index;
    NSMutableDictionary *dict = [[self.buttonArray objectAtIndex:index] mutableCopy];
    NSInteger status = [dict[@"selected"] integerValue];
    if(status == 1)
        [dict setObject:@0 forKey:@"selected"];
    else
        [dict setObject:@1 forKey:@"selected"];
    
    [self.buttonArray replaceObjectAtIndex:index withObject:[dict copy]];
    [self.tableView reloadData];
}

-(void)onCommentsButtonPressed:(UIButton*)button
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Comments" bundle:nil];
    CommentsViewController *choiceServiceViewController = [storyboard instantiateViewControllerWithIdentifier:@"CommentsViewController"];
    choiceServiceViewController.washID = self.washID;
    [self setTitle:@" "];
    [self.navigationController pushViewController:choiceServiceViewController animated:YES];
}

-(void)onCallButtonPressed:(UIButton*)button
{
    if(self.phoneNumber.length <= 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Номер телефона отсутствует" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:self.phoneNumber];
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneNumber]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[UIColor blackColor]];
}

-(void)onNaviButtonPressed:(UIButton*)button
{
    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[UIColor blackColor]];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"YANDEX NAVIGATOR",@"СТАНДАРТНАЯ КАРТА",@"ОТМЕНА", nil];

    [actionSheet setTag:0xCC];
    [actionSheet showInView:self.view];
}
- (void)openYandexNavi
{
    CLLocation *location = [[LocationCore sharedMenager] getCurrentLocation];
    
    double myLat = location.coordinate.latitude;
    double myLon = location.coordinate.longitude;
    
    NSString *LatFrom = [NSString stringWithFormat:@"%f",myLat];
    NSString *LonFrom = [NSString stringWithFormat:@"%f",myLon];
    
    NSString *LatTo   = [NSString stringWithFormat:@"%f",self.latWash];
    NSString *LonTo   = [NSString stringWithFormat:@"%f",self.lonWash];
    
    NSURL *callUrl = [NSURL URLWithString:[NSString stringWithFormat:@"yandexmaps://build_route_on_map/?lat_from=%@&lon_from=%@&lat_to=%@&lon_to=%@",LatFrom,LonFrom,LatTo,LonTo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:callUrl])
    {
        [[UIApplication sharedApplication] openURL:callUrl];
    }
    else
    {
        NSURL *callUrlNAV = [NSURL URLWithString:[NSString stringWithFormat:@"yandexnavi://build_route_on_map?lat_from=%@&lon_from=%@&lat_to=%@&lon_to=%@",LatFrom,LonFrom,LatTo,LonTo]];
        if ([[UIApplication sharedApplication] canOpenURL:callUrlNAV])
        {
            [[UIApplication sharedApplication] openURL:callUrlNAV];
        }
        else
        {
            NSURL* appStoreURL = [NSURL URLWithString:@"https://itunes.apple.com/ru/app/yandeks.navigator/id474500851?mt=8"];
            [[UIApplication sharedApplication] openURL:appStoreURL];
        }
    }
}

- (void)openAppleMap{
    //маршрут
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.latWash, self.lonWash);
    
    //create MKMapItem out of coordinates
    MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem* destination =  [[MKMapItem alloc] initWithPlacemark:placeMark];
    
    if([destination respondsToSelector:@selector(openInMapsWithLaunchOptions:)])
    {
        [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
    }
}

-(void)onSendButton:(UIButton*)button
{
    __IN_DEVELOPMENT__
}

-(void)setupButtonDataDefault:(NSArray*)arrayForDay
{
    if(arrayForDay.count == 0)
        return;
    
    self.buttonArray = [@[] mutableCopy];
    for(NSDictionary *dic in arrayForDay)
    {
        
        [self.buttonArray addObject:@{
                                      
                                     @"id":dic[@"id"],
                                     @"title":dic[@"time"],
                                     @"selected":@(0),
                                     @"available":@([dic[@"open"] integerValue])
                                     
                                      }];
    }
}

-(void)onMapButtonPressed:(UIButton*)button
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DetailInfoMap" bundle:nil];
    DetailInfoMapViewController *detailInfoMapViewController = [storyboard instantiateViewControllerWithIdentifier:@"DetailInfoMapViewController"];
    detailInfoMapViewController.dictionaryInfo = self.dictInfo;
    
    [self setTitle:@" "];
    [self.navigationController pushViewController:detailInfoMapViewController animated:YES];
}

-(NSMutableArray*)getcurrentArrayTime
{
    if(self.typeCurrentTimeButtonTag == kTodayTag)
    {
        return self.todayArray;
    }
    if(self.typeCurrentTimeButtonTag == kTommorowTag)
    {
        return self.tomorrowArray;
    }
    if(self.typeCurrentTimeButtonTag == kDayAfterTommorowag)
    {
        return self.yesterdayArray;
    }
    
    return nil;
}

-(void)onChoiceServiceButton:(UIButton*)button
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ChoiceService" bundle:nil];
    ChoiceServiceViewController *choiceServiceViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChoiceServiceViewController"];
    choiceServiceViewController.arrayServices = self.servicesArray;
    choiceServiceViewController.currentServisesChoice = self.currentServisesChoice;
    [self setTitle:@" "];
    [self.navigationController pushViewController:choiceServiceViewController animated:YES];
}

-(void)request
{
    NSNumber *idWash = @([self.dictInfo[@"id"] integerValue]);
    
    [[GetWashInfoRequest alloc] getWashInfoByID:idWash completionHandler:^(NSDictionary *json)
    {
        self.rating         = [json[@"data"][@"rating"] doubleValue];
        if(!self.isOfflineWash)
        {
            self.todayArray     = [json[@"data"][@"wash_times"][@"today"] mutableCopy];
            self.tomorrowArray  = [json[@"data"][@"wash_times"][@"tomorrow"] mutableCopy];
            self.yesterdayArray = [json[@"data"][@"wash_times"][@"yesterday"] mutableCopy];
        
            self.servicesArray  = [json[@"data"][@"wash_services"] mutableCopy];
            self.phoneNumber    = [NSString stringWithFormat:@"%@",json[@"data"][@"phone"]];
        }
        self.latWash            = [[NSString stringWithFormat:@"%@",json[@"data"][@"latitude"]] doubleValue];
        self.lonWash            = [[NSString stringWithFormat:@"%@",json[@"data"][@"longitude"]] doubleValue];
        
        self.address = [NSString stringWithFormat:@"%@",json[@"data"][@"address"]];
        self.washID = [NSString stringWithFormat:@"%@",json[@"data"][@"id"]];
        NSDictionary *wasTimeWork = json[@"data"][@"work_time"];
        
        NSDictionary *timeCommonStart = [self.arrayTime filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id LIKE %@",[NSString stringWithFormat:@"%@",wasTimeWork[@"start_wash_time_id"]]]].lastObject;
        
        NSDictionary *timeCommonEnd = [self.arrayTime filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id LIKE %@",[NSString stringWithFormat:@"%@",wasTimeWork[@"end_wash_time_id"]]]].lastObject;
        
        NSString *timeStart = timeCommonStart[@"wash_time"];
        NSString *timeEnd   = timeCommonEnd[@"wash_time"];

        self.time    = [NSString stringWithFormat:@"%@ - %@",timeStart,timeEnd];
        if(!self.isOfflineWash)
        {
            self.additionalServices = [json[@"data"][@"additional_services"] mutableCopy];
            self.typeCurrentTimeButtonTag = kTodayTag;
            [self setupButtonDataDefault:self.todayArray];
        }
        
        [self.tableView reloadData];
    } errorHandler:^{
        
    }];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [self openYandexNavi];
            break;
        }
        case 1:
        {
            [self openAppleMap];
            break;
        }
        case 2:
        {
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)isHaveByID:(int)idService
{
    
    for(NSDictionary *dict in self.additionalServices)
    {
        if([dict[@"id"] integerValue] == idService)
        {
            return (BOOL)[dict[@"exists"] integerValue];
        }
    }
    
    return NO;
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

-(void)onOrderConformButton:(UIButton*)button
{
    //Проверки!!
    
    /*
     {
     car_wash_id, // ИД мойки
     day_id, // день записи (1/2/3 - сегодня/завтра/послезавтра)
     time_id, // время записи (айдишник который приходит со временем)
     car_id, // ИД марки авто (не обязательное)
     model_id, // ИД модели авто
     car_number, // гос. номер авто
     services // массив ИДшников услуг
     }
     
     */
    
    
    NSString *car_wash_id = self.washID;
    
    NSInteger typeDay = 0;
    if(self.typeCurrentTimeButtonTag == kTodayTag)
        typeDay = 1;
    if(self.typeCurrentTimeButtonTag == kTommorowTag)
        typeDay = 2;
    if(self.typeCurrentTimeButtonTag == kDayAfterTommorowag)
        typeDay = 3;
    
    NSString *day_id      = [NSString stringWithFormat:@"%d",typeDay];
    
    NSMutableDictionary *dict = [[self.buttonArray objectAtIndex:self.currentTimeIndex] mutableCopy];
    NSInteger status = [dict[@"selected"] integerValue];
    NSInteger idTime = 0;
    if(status == 1)
    {
        idTime = [dict[@"id"] integerValue];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Не указано время!" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil] show];
        return;
    }
    
    NSString *time_id = [NSString stringWithFormat:@"%d",idTime];

    NSString *car_id = self.currentCar[@"carBrandID"];
    NSString *model_id = self.currentCar[@"carModelID"];
    NSString *car_number = self.currentCar[@"number"];
    
    if(car_number.length == 0 || model_id.length == 0 || car_number.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Не указана машина!" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil] show];
        return;
    }
    
    NSMutableString *arrayIdServices = [NSMutableString new];
    [arrayIdServices appendString:@"["];
    
    if(self.currentServisesChoice.count == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Выберите услугу!" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil] show];
        return;
    }
    
    for(NSDictionary *dict in self.currentServisesChoice)
    {
        [arrayIdServices appendString:[NSString stringWithFormat:@"%@,",dict[@"seviceId"]]];
    }
    [arrayIdServices appendString:@"]"];
    
    NSString *services = [[arrayIdServices copy] stringByReplacingOccurrencesOfString:@",]" withString:@"]"];
    
    [[GetClientOrderAdd alloc] getClientOrderAdd:car_wash_id day_id:day_id time_id:time_id car_id:car_id model_id:model_id car_number:car_number services:services completionHandler:^(NSDictionary *json)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"Сообщение" message:@"Вы успешно совешили заказ" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil] show];
            
            if(self.isRemember == YES)
            {
                NSString *buttonTitle = [NSString stringWithFormat:@"%@",json[@"data"][@"wash_time"][@"wash_time"]];
                NSArray *arrayTime = [buttonTitle componentsSeparatedByString:@":"];
                if(arrayTime.count == 2)
                {
                    NSInteger h = [arrayTime[0] integerValue];
                    NSInteger m = [arrayTime[1] integerValue];
                    NSInteger value = 0;
                    if(self.typeCurrentTimeButtonTag == kTodayTag)
                        value = 1;
                    if(self.typeCurrentTimeButtonTag == kTommorowTag)
                        value = 2;
                    if(self.typeCurrentTimeButtonTag == kDayAfterTommorowag)
                        value = 3;
                    [[LocalNotificationManager alloc] createNotificationFromDayType:value hours:h minuts:m];
                }
            }
            [self request];
        });
    } errorHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Ошибка сервера" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil] show];
            [self request];
        });
    }];
}

@end
