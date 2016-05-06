//
//  HYHomeMoreView.m
//  Teshehui
//
//  Created by HYZB on 15/11/11.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYHomeMoreView.h"
#import "HYImageButton.h"

@interface HYHomeMoreView ()
{
    BOOL _show;
    UIImageView *_bgView;
}

@end

@implementation HYHomeMoreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _show = NO;
        CGFloat x = frame.size.width - 130;
        CGRect rect = CGRectMake(x, 66, 120, 80);
        
        _bgView = [[UIImageView alloc] initWithFrame:rect];
        _bgView.image = [[UIImage imageNamed:@"check_more_bg"] stretchableImageWithLeftCapWidth:4
                                                                            topCapHeight:20];
        _bgView.userInteractionEnabled = YES;
        [self addSubview:_bgView];
        
        HYImageButton *scanBtn = [HYImageButton buttonWithType:UIButtonTypeCustom];
        scanBtn.frame = CGRectMake(6, 6, 114, 30);
        [scanBtn setTitle:@"扫一扫"
                 forState:UIControlStateNormal];
        [scanBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [scanBtn setTitleColor:[UIColor grayColor]
                      forState:UIControlStateNormal];
        [scanBtn setImage:[UIImage imageNamed:@"icon_sys"]
                 forState:UIControlStateNormal];
        [scanBtn addTarget:self
                    action:@selector(btnEvent:)
          forControlEvents:UIControlEventTouchUpInside];
        scanBtn.type = ImageButtonTypeCustom;
        scanBtn.imageOrigin = CGPointMake(4, 9);
        scanBtn.titleOrigin = CGPointMake(30, 7);
        scanBtn.tag = 1;
        [_bgView addSubview:scanBtn];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(5, 42, 110, 1)];
        line.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                   topCapHeight:0];
        [_bgView addSubview:line];
        
        HYImageButton *buyBtn = [HYImageButton buttonWithType:UIButtonTypeCustom];
        [buyBtn setTitleColor:[UIColor grayColor]
                      forState:UIControlStateNormal];
        buyBtn.frame = CGRectMake(6, 42, 114, 30);
        [buyBtn setTitle:@"快速买单"
                 forState:UIControlStateNormal];
        [buyBtn setImage:[UIImage imageNamed:@"icon_md"]
                 forState:UIControlStateNormal];
        [buyBtn addTarget:self
                    action:@selector(btnEvent:)
          forControlEvents:UIControlEventTouchUpInside];
        [buyBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        buyBtn.type = ImageButtonTypeCustom;
        buyBtn.imageOrigin = CGPointMake(4, 9);
        buyBtn.titleOrigin = CGPointMake(30, 7);
        buyBtn.tag = 2;
        [_bgView addSubview:buyBtn];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setMenuViewShow:NO animation:NO];
}

#pragma mark private methods
- (void)btnEvent:(UIButton *)sender
{
    if (self.didClickType)
    {
        HomeMoreType type = (sender.tag==1) ? HYScanQRCode : HYCheckQRCode;
        self.didClickType(type);
    }
    
    [self setMenuViewShow:NO animation:NO];
}

#pragma mark pulice methods
- (void)setMenuViewShow:(BOOL)show animation:(BOOL)animation
{
    if (_show != show)
    {
        _show = show;
        
        CGFloat x = [[UIScreen mainScreen] bounds].size.width - 130;
        if (show)
        {
            if (!self.superview)
            {
                UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                [window addSubview:self];
            }
            
            if (animation)
            {
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     _bgView.frame = CGRectMake(x, 66, 120, 80);
                                 }];
            }
            else
            {
                _bgView.frame = CGRectMake(x, 66, 120, 80);
            }
        }
        else
        {
            if (self.superview)
            {
                if (animation)
                {
                    [UIView animateWithDuration:0.5
                                     animations:^{
                                         _bgView.frame = CGRectMake(x, 64, 120, 0);
                                     }
                                     completion:^(BOOL finished) {
                                         if (finished)
                                         {
                                             [self removeFromSuperview];
                                         }
                                     }];
                }
                else
                {
                    [self removeFromSuperview];
                }
            }
        }
    }
}

@end
