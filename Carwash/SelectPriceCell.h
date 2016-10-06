//
//  SelectPriceCell.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/5/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPriceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *carToButton;
@property (weak, nonatomic) IBOutlet UIButton *serviceButton;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPrice;
@property (weak, nonatomic) IBOutlet UILabel *carInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *servicesInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
