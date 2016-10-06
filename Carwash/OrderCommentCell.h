//
//  OrderCommentCell.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/19/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleWashLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerCell;

@end
