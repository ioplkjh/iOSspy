//
//  SearchResultCell.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/11/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

@class HCSStarRatingView;

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleWashLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *streenLabel;
@property (weak, nonatomic) IBOutlet UILabel *badgeNumber;
@property (weak, nonatomic) IBOutlet UIImageView *ImageBableView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *rating;

@end
