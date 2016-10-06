//
//  HotelAnnotationView.m
//  iTEZ
//
//  Created by Andrei Sabinin on 8/21/15.
//  Copyright (c) 2015 CookieDev. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    [super setSelected:selected animated:animated];
    
    if(selected)
    {
        NSDictionary *dictInfo = (NSDictionary *)self.object;
        UIImage *imageUnder = [UIImage imageNamed:@"sign_no_active"];
        UIImage *imageTop   = [UIImage imageNamed:@"popup"];

        self.buttonCustomeCallOut = [UIButton buttonWithType:UIButtonTypeCustom];//iconShare//iconShareBlue
        [self.buttonCustomeCallOut addTarget:self action:@selector(buttonHandlerCallOut:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonCustomeCallOut setBackgroundImage:[UIImage imageNamed:@"popup"] forState:UIControlStateNormal];
        [self.buttonCustomeCallOut setBackgroundColor:[UIColor clearColor]];
        [self.buttonCustomeCallOut setFrame:CGRectMake((imageUnder.size.width - /*imageTop.size.width*/280)/2.f,-67 /*(imageUnder.size.height)*/, 280, 67)];
        [self.buttonCustomeCallOut setTitle:@"" forState:UIControlStateNormal];
        [self addSubview:self.buttonCustomeCallOut];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0., (57-44)/2., 44, 44)];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [imageView setContentMode:UIViewContentModeCenter];
        [imageView setImage:[UIImage imageNamed:@"logo_carwash"]];
        [self.buttonCustomeCallOut addSubview:imageView];
        [self.buttonCustomeCallOut setUserInteractionEnabled:YES];
        
        
        UIImageView *imageViewArrow = [[UIImageView alloc] initWithFrame:CGRectMake(255., 8., 20., 20.)];
        imageViewArrow.image = [UIImage imageNamed:@"icon_arrow"];
        imageViewArrow.contentMode = UIViewContentModeScaleAspectFit;
        
        UILabel *labelTop = [[UILabel alloc] initWithFrame:CGRectMake(50., 8. ,146+80 , 21)];
        UILabel *labelBot = [[UILabel alloc] initWithFrame:CGRectMake(54., 29. ,146+80 , 21)];
        [labelTop setText:[NSString stringWithFormat:@"\"%@\"",dictInfo[@"title"]]];
        
        [labelTop setFont:[UIFont systemFontOfSize:14]];
        [labelTop setTextColor:[UIColor colorWithRed:45.0/255.0 green:178.0/255.0 blue:151.0/255.0 alpha:1.0]];
        
        [labelBot setText:dictInfo[@"address"]];
        [labelBot setFont:[UIFont systemFontOfSize:12]];
        [labelBot setTextColor:[UIColor darkGrayColor]];
        [self.buttonCustomeCallOut addSubview:labelTop];
        [self.buttonCustomeCallOut addSubview:labelBot];
        [self.buttonCustomeCallOut addSubview:imageViewArrow];

    }
    else
    {
        //Remove your custom view...
        [self.buttonCustomeCallOut setUserInteractionEnabled:NO];
        [self.buttonCustomeCallOut removeFromSuperview];
        self.buttonCustomeCallOut = nil;
    }
}
- (void)buttonHandlerCallOut:(UIButton*)sender
{
    NSLog(@"Annotation Clicked");
    if([self.delegate respondsToSelector:@selector(annotationView:didClickPopupViewButton:)])
    {
        [self.delegate annotationView:self didClickPopupViewButton:sender];
    }
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* v = [super hitTest:point withEvent:event];
    if (v != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return v;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rec = self.bounds;
    BOOL isIn = CGRectContainsPoint(rec, point);
    if(!isIn)
    {
        for (UIView *v in self.subviews)
        {
            isIn = CGRectContainsPoint(v.frame, point);
            if(isIn)
                break;
        }
    }
    return isIn;
}

@end
