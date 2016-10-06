//
//  ConfirmBotCell.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/8/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmBotCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *choiceServiceButton;
@property (weak, nonatomic) IBOutlet UIButton *orderConformButton;
@property (weak, nonatomic) IBOutlet UISwitch *switchHalfControll;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeSpendLabel;

@end
