//
//  SelectTimeCell.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/5/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NMRangeSlider;

@interface SelectTimeCell : UITableViewCell

typedef NS_ENUM(NSInteger, TypeTimeButton)
{
    kTodayTag           = 10,
    kTommorowTag        = 11,
    kDayAfterTommorowag = 12
};

@property (weak, nonatomic) IBOutlet NMRangeSlider *rangeSlider;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *todayButton;
@property (weak, nonatomic) IBOutlet UIButton *tommorowDayButton;
@property (weak, nonatomic) IBOutlet UIButton *dayAfterTommorowButton;

-(void)setupCarButtonFromArayContent:(NSArray*)arrayCars;

@end
