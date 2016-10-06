//
//  SelectPriceCell.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/5/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "SelectPriceCell.h"

@implementation SelectPriceCell

- (void)awakeFromNib
{
    [self.textFieldPrice.layer setBorderWidth:0.5];
    [self.textFieldPrice.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.textFieldPrice.layer setCornerRadius:4];
    [self.textFieldPrice setClipsToBounds:YES];
    
    [self.carToButton.layer setBorderWidth:2];
    [self.carToButton.layer setBorderColor:[UIColor colorWithRed:45.0/255.0 green:178.0/255.0 blue:151.0/255.0 alpha:1.0].CGColor];
    [self.carToButton.layer setCornerRadius:4];
    [self.carToButton setClipsToBounds:YES];

    [self.serviceButton.layer setBorderWidth:2];
    [self.serviceButton.layer setBorderColor:[UIColor colorWithRed:45.0/255.0 green:178.0/255.0 blue:151.0/255.0 alpha:1.0].CGColor];
    [self.serviceButton.layer setCornerRadius:4];
    [self.serviceButton setClipsToBounds:YES];
    
//    self.serviceButton.layer

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
