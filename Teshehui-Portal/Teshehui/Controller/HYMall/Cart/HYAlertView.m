//
//  HYAlertView.m
//  Teshehui
//
//  Created by Kris on 15/12/25.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYAlertView.h"

@interface HYAlertView ()

@property (weak, nonatomic) IBOutlet UIView *alertMainView;

@end

@implementation HYAlertView

+ (instancetype)instanceView
{
    UINib *nib = [UINib nibWithNibName:@"HYAlertView" bundle:nil];
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
    _alertMainView.layer.cornerRadius = 10;
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
- (IBAction)firstBtnClick:(id)sender
{
    if (_firstBlock)
    {
        _firstBlock();
    }
    [self dismiss];
}

- (IBAction)secBtnClcik:(id)sender
{
    if (_secondBlock)
    {
        _secondBlock();
    }
    [self dismiss];
}



@end
