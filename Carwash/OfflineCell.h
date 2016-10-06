//
//  OfflineCell.h
//  Carwash
//
//  Created by Andrei Sabinin on 9/29/15.
//  Copyright © 2015 Empty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfflineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UILabel *midLabel;
@property (weak, nonatomic) IBOutlet UILabel *botLabel;
@end
