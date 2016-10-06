//
//  SelectTimeCell.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/5/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WashSelectTimeCellDelegate <NSObject>

@optional

-(void)didSelectCarButton:(UIButton*)button;

@end

@interface WashSelectTimeCell : UITableViewCell

typedef NS_ENUM(NSInteger, TypeTimeButton)
{
    kTodayTag           = 10,
    kTommorowTag        = 11,
    kDayAfterTommorowag = 12
};
@property (nonatomic, weak) NSObject<WashSelectTimeCellDelegate> *delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewCar;

@property (weak, nonatomic) IBOutlet UIButton *todayButton;
@property (weak, nonatomic) IBOutlet UIButton *tommorowDayButton;
@property (weak, nonatomic) IBOutlet UIButton *dayAfterTommorowButton;

-(void)setupCarButtonFromArayContent:(NSArray*)arrayCars;

@end
