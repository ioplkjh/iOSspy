//
//  SelectServicesCell.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/3/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectServicesCell : UITableViewCell

typedef NS_ENUM(NSInteger, TypeButton)
{
        kWifiTag    = 10,
        kPayTag     = 11,
        kCoffeTag   = 12,
        kComfortTag = 13,
        kWCTag      = 14
};

@property (weak, nonatomic) IBOutlet UIButton *buttonWiFi;
@property (weak, nonatomic) IBOutlet UIButton *buttonPay;
@property (weak, nonatomic) IBOutlet UIButton *buttonCoffe;
@property (weak, nonatomic) IBOutlet UIButton *buttonComfort;
@property (weak, nonatomic) IBOutlet UIButton *buttonWC;

-(void)setButtonWiFiActive;
-(void)setButtonWiFiUnActive;

-(void)setButtonCoffeActive;
-(void)setButtonCoffeUnActive;

-(void)setButtonPayActive;
-(void)setButtonPayUnActive;

-(void)setButtonComfortActive;
-(void)setButtonComfortUnActive;

-(void)setButtonWCActive;
-(void)setButtonWCUnActive;

@end
