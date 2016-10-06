//
//  DetailOrderBotCell.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/29/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "DetailOrderBotCell.h"

@implementation DetailOrderBotCell

- (void)awakeFromNib {

    [self.canselOrderButton.layer setCornerRadius:4];
    [self.canselOrderButton setClipsToBounds:YES];
    [self.canselOrderButton.layer setBorderWidth:2];
    [self.canselOrderButton.layer setBorderColor:[UIColor colorWithRed:45.0/255.0 green:178.0/255.0 blue:151.0/255.0 alpha:1.0].CGColor];

    [self.commentButton.layer setCornerRadius:4];
    [self.commentButton setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
