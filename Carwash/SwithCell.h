//
//  SwithCell.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/5/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwithCellDelegate <NSObject>

@optional
-(void)changeSwitchValue:(UISwitch*)switchValue;

@end

@interface SwithCell : UITableViewCell

@property (weak, nonatomic) NSObject<SwithCellDelegate> *delegate;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;
@property (weak, nonatomic) IBOutlet UILabel *labelSwitch;
@end
