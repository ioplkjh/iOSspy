//
//  ConfirmBotCell.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/8/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "ConfirmBotCell.h"

@implementation ConfirmBotCell

- (void)awakeFromNib {

    [self.choiceServiceButton.layer setBorderWidth:2];
    [self.choiceServiceButton.layer setBorderColor:[UIColor colorWithRed:45.0/255.0 green:178.0/255.0 blue:151.0/255.0 alpha:1.0].CGColor];
    [self.choiceServiceButton.layer setCornerRadius:4];
    [self.choiceServiceButton setClipsToBounds:YES];

    [self.orderConformButton.layer setCornerRadius:4];
    [self.orderConformButton setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
