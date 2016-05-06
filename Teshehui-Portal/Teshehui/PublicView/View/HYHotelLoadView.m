//
//  HYHotelLoadView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-14.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelLoadView.h"

@interface HYHotelLoadView ()
{
    UIActivityIndicatorView *_activityIndicatorView;
}

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation HYHotelLoadView

- (id)initWithDef
{
    CGRect rect = CGRectMake(10, 64, 300, 0);
    self = [super initWithFrame:rect];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (UILabel *)textLabel
{
    if (!_textLabel)
    {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 8, 120, 20)];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.backgroundColor = [UIColor clearColor];
        [_textLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_textLabel];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(80, 6, 24, 24)];
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [self addSubview:_activityIndicatorView];
    }
    
    return _textLabel;
}

#pragma mark pulic methods
- (void)startLoadAnimation
{
    if (!self.superview)
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
    }
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.frame = CGRectMake(10, 64, 300, 36);
                     }];
    
    self.textLabel.text = @"努力加载中...";
    [_activityIndicatorView startAnimating];
}

- (void)stopLoadAnimation
{
    self.textLabel.text = @"加载完毕";
    [_activityIndicatorView stopAnimating];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.frame = CGRectMake(10, 64, 300, 0);
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         if (finished)
                         {
                             [self removeFromSuperview];
                             self.alpha = 1.0;
                         }
                     }];
}
@end
