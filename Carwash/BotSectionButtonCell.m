//
//  BotSectionButtonCell.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/13/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "BotSectionButtonCell.h"

@implementation BotSectionButtonCell

- (void)awakeFromNib
{
    [self.myCarButton.layer setBorderWidth:2];
    [self.myCarButton.layer setBorderColor:[UIColor colorWithRed:45.0/255.0 green:178.0/255.0 blue:151.0/255.0 alpha:1.0].CGColor];
    [self.myCarButton.layer setCornerRadius:6];
    [self.myCarButton setClipsToBounds:YES];
    
    [self.saveButton.layer setBorderWidth:0.0];
    [self.saveButton.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.saveButton.layer setCornerRadius:6];
    [self.saveButton setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
