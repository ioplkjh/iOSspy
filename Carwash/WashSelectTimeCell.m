//
//  SelectTimeCell.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/5/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "WashSelectTimeCell.h"

#define kCarWidth 64
#define kCarHeight 29


@interface WashSelectTimeCell()
@property (weak, nonatomic) IBOutlet UIView *dayBackgroundView;
@property (nonatomic, strong) NSMutableArray *buttonsCarArray;
@end
@implementation WashSelectTimeCell

- (void)awakeFromNib {
    [self.dayBackgroundView.layer setCornerRadius:2];
    [self.dayBackgroundView setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setupCarButtonFromArayContent:(NSArray*)arrayCars
{
    for(UIButton *btn in self.buttonsCarArray)
    {
        [btn removeFromSuperview];
    }

    self.buttonsCarArray = [@[] mutableCopy];
    self.scrollViewCar.contentSize = CGSizeMake(kCarWidth *arrayCars.count,0);
    for(NSDictionary *dict in arrayCars)
    {
        NSInteger index = [arrayCars indexOfObject:dict];
        UIButton *carButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [carButton setTag:index];
        [carButton setTitle:dict[@"title"] forState:UIControlStateNormal];
        [carButton addTarget:self action:@selector(onTapCarButton:) forControlEvents:UIControlEventTouchUpInside];
        [carButton setFrame:CGRectMake(kCarWidth*index, (self.scrollViewCar.frame.size.height - kCarHeight)/2.f, kCarWidth, kCarHeight)];
        
        [carButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        if([dict[@"available"] integerValue])
        {
            if([dict[@"selected"] integerValue])
            {
                [carButton setBackgroundImage:[UIImage imageNamed:@"car_button_active"] forState:UIControlStateNormal];
            }
            else
            {
                [carButton setBackgroundImage:[UIImage imageNamed:@"car_button_not_aktive"] forState:UIControlStateNormal];
                [carButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
        }
        else
        {
            [carButton setBackgroundImage:[UIImage imageNamed:@"car_button"] forState:UIControlStateNormal];
        }
        [self.buttonsCarArray addObject:carButton];
        [self.scrollViewCar addSubview:carButton];
    }
}

-(void)onTapCarButton:(UIButton*)button
{
    if([self.delegate respondsToSelector:@selector(didSelectCarButton:)])
    {
        [self.delegate didSelectCarButton:button];
    }
}

@end
