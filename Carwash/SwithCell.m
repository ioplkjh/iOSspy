//
//  SwithCell.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/5/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "SwithCell.h"

@interface SwithCell()

@end

@implementation SwithCell

- (void)awakeFromNib
{
    [self.switcher addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)valueChanged:(UISwitch*)switchValue
{
    if([self.delegate respondsToSelector:@selector(changeSwitchValue:)])
    {
        [self.delegate changeSwitchValue:switchValue];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
