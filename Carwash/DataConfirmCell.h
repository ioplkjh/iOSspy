//
//  DataConfirmCell.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/5/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataConfirmCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITextField *topTextField;

@property (weak, nonatomic) IBOutlet UIView *botView;
@property (weak, nonatomic) IBOutlet UITextField *botLabel;
@property (weak, nonatomic) IBOutlet UIButton *botButton;

@end
