//
//  CloseTableViewCell.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/13/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCSStarRatingView;

@interface CloseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *nameAndCarLabel;

@end
