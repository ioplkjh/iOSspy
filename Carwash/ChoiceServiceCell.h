//
//  ChoiceServiceCell.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/10/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoiceServiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
