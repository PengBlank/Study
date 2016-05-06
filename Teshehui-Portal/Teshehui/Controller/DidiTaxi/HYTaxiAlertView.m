//
//  HYTaxiAlertView.m
//  Teshehui
//
//  Created by Kris on 15/11/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiAlertView.h"

@interface HYTaxiAlertView ()

@end

@implementation HYTaxiAlertView

+ (instancetype)instanceView
{
    UINib *nib = [UINib nibWithNibName:@"HYTaxiAlertView" bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    
    return views.count > 0 ? views[0] : nil;
}

- (void)show
{
    if (!self.superview)
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.frame = [UIScreen mainScreen].bounds;
        [window addSubview:self];
    }
    
    __weak typeof(self) b_self = self;
    b_self.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        b_self.alpha = 1.0;
    }];
}

-(void)awakeFromNib
{
    _mainTitleLabel.font = [UIFont systemFontOfSize:TFScalePoint(14)];
    
    [_secondBtn setBackgroundImage:[[UIImage imageNamed:@"btn_car_active"]stretchableImageWithLeftCapWidth:5 topCapHeight:10]forState:UIControlStateNormal];
    [_firstBtn setBackgroundImage:[[UIImage imageNamed:@"btn_car_inActive"]stretchableImageWithLeftCapWidth:5 topCapHeight:10]forState:UIControlStateNormal];
}

- (void)dismiss
{
    __weak typeof(self) b_self = self;
    [UIView animateWithDuration:.3 animations:^
     {
         b_self.alpha = 0;
     } completion:^(BOOL finished)
     {
         [b_self removeFromSuperview];
     }];
}

#pragma mark private methods
- (IBAction)fisrtBtnClick:(id)sender
{
    if (_firstBlock)
    {
        _firstBlock();
    }
    [self dismiss];
}

- (IBAction)secondBtnClick:(id)sender
{
    if (_secondBlock)
    {
        _secondBlock();
    }
    [self dismiss];
}
@end
