//
//  InfoWashCell.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/8/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCSStarRatingView;

@interface InfoWashCell : UITableViewCell
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wifiImageView;
@property (weak, nonatomic) IBOutlet UIImageView *coffeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *payImageView;
@property (weak, nonatomic) IBOutlet UIImageView *comfortImageView;
@property (weak, nonatomic) IBOutlet UIImageView *wcImageView;

@end
