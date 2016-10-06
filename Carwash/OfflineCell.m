//
//  OfflineCell.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/29/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import "OfflineCell.h"

@implementation OfflineCell

- (void)awakeFromNib
{
    [self.sendButton.layer setCornerRadius:4];
    [self.sendButton setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
