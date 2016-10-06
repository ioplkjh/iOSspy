//
//  SelectTimeCell.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/5/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "SelectTimeCell.h"

#define kCarWidth 64
#define kCarHeight 29


@interface SelectTimeCell()
@property (weak, nonatomic) IBOutlet UIView *dayBackgroundView;
@property (nonatomic, strong) NSMutableArray *buttonsCarArray;
@end
@implementation SelectTimeCell

- (void)awakeFromNib {

    [self.dayBackgroundView.layer setCornerRadius:2];
    [self.dayBackgroundView setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setupCarButtonFromArayContent:(NSArray*)arrayCars
{
   
}

-(void)onTapCarButton:(UIButton*)button
{

}



@end
