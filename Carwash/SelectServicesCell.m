//
//  SelectServicesCell.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/3/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "SelectServicesCell.h"

@implementation SelectServicesCell

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setButtonWiFiActive
{
    [self.buttonWiFi setBackgroundImage:[UIImage imageNamed:@"uslugi_icon_wifi_active"] forState:UIControlStateNormal];
}
-(void)setButtonWiFiUnActive
{
    [self.buttonWiFi setBackgroundImage:[UIImage imageNamed:@"uslugi_icon_wifi"] forState:UIControlStateNormal];
}

-(void)setButtonCoffeActive
{
    [self.buttonCoffe setBackgroundImage:[UIImage imageNamed:@"uslugi_icon_coffee_active"] forState:UIControlStateNormal];
}
-(void)setButtonCoffeUnActive
{
    [self.buttonCoffe setBackgroundImage:[UIImage imageNamed:@"uslugi_icon_coffee"] forState:UIControlStateNormal];
}

-(void)setButtonPayActive
{
    [self.buttonPay setBackgroundImage:[UIImage imageNamed:@"uslugi_icon_payment_active"] forState:UIControlStateNormal];
}
-(void)setButtonPayUnActive
{
    [self.buttonPay setBackgroundImage:[UIImage imageNamed:@"uslugi_icon_payment"] forState:UIControlStateNormal];
}

-(void)setButtonComfortActive
{
    [self.buttonComfort setBackgroundImage:[UIImage imageNamed:@"uslugi_icon_comfort_active"] forState:UIControlStateNormal];
}
-(void)setButtonComfortUnActive
{
    [self.buttonComfort setBackgroundImage:[UIImage imageNamed:@"uslugi_icon_comfort"] forState:UIControlStateNormal];
}

-(void)setButtonWCActive
{
    [self.buttonWC setBackgroundImage:[UIImage imageNamed:@"uslugi_icon_wc_active"] forState:UIControlStateNormal];
}
-(void)setButtonWCUnActive
{
    [self.buttonWC setBackgroundImage:[UIImage imageNamed:@"uslugi_icon_wc"] forState:UIControlStateNormal];
}


@end
