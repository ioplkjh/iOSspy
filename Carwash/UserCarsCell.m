//
//  UserCarsCell.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/13/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "UserCarsCell.h"

@implementation UserCarsCell

- (void)awakeFromNib {
    [self.bgView.layer setBorderWidth:0.5];
    [self.bgView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.bgView.layer setCornerRadius:4];
    [self.bgView setClipsToBounds:YES];}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
