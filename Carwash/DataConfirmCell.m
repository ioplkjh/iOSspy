//
//  DataConfirmCell.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/5/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "DataConfirmCell.h"

@implementation DataConfirmCell

- (void)awakeFromNib
{
    [self.topView.layer setBorderWidth:0.5];
    [self.topView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.topView.layer setCornerRadius:6];
    [self.topView setClipsToBounds:YES];
    
    [self.botView.layer setBorderWidth:0.5];
    [self.botView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.botView.layer setCornerRadius:6];
    [self.botView setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
