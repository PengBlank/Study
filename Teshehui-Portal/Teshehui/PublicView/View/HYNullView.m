//
//  HYNullView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-6.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYNullView.h"

@interface HYNullView ()
{
    UIButton *_goToMallHomeBtn;
}

@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) UIImageView *defIamgeView;

@end

@implementation HYNullView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = NO;
        _needTouch = NO;
        
        _defIamgeView = [[UIImageView alloc] initWithFrame:TFRectMake(128, 90, 64, 64)];
        _defIamgeView.image = [UIImage imageNamed:@"load_logo"];
        [self addSubview:_defIamgeView];
        
        _descLab = [[UILabel alloc] initWithFrame:TFRectMake(60, 154, 200, 60)];
        _descLab.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        [_descLab setFont:[UIFont systemFontOfSize:15]];
        _descLab.backgroundColor = [UIColor clearColor];
        _descLab.textAlignment = NSTextAlignmentCenter;
        _descLab.lineBreakMode = NSLineBreakByCharWrapping;
        _descLab.numberOfLines = 0;
        [self addSubview:_descLab];
        
        _goToMallHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goToMallHomeBtn.frame = TFRectMake(110, 230, 100, 40);
        [_goToMallHomeBtn setTitle:@"去逛逛" forState:UIControlStateNormal];
        [_goToMallHomeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_goToMallHomeBtn setBackgroundImage:[[UIImage imageNamed:@"mall_afterSaleType"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [_goToMallHomeBtn addTarget:self action:@selector(goToHome:) forControlEvents:UIControlEventTouchUpInside];
        _goToMallHomeBtn.hidden = YES;
        _goToMallHomeBtn.titleLabel.font = [UIFont systemFontOfSize:TFScalePoint(13)];
        [self addSubview:_goToMallHomeBtn];
        
        _eventBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _eventBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_eventBtn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1.0]
                        forState:UIControlStateNormal];
        [_eventBtn setBackgroundImage:[[UIImage imageNamed:@"button_orderlist_phonecharge"]stretchableImageWithLeftCapWidth:2 topCapHeight:2]
                             forState:UIControlStateNormal];
        _eventBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_eventBtn];
        _eventBtn.hidden = YES;
    }
    return self;
}

- (void)setIcon:(UIImage *)icon
{
    if (_icon != icon) {
        _icon = icon;
        _defIamgeView.image = icon;
    }
}

/// 将图标跟文字居中
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_descLab sizeToFit];
    CGFloat h = _defIamgeView.image.size.height + 20 + _descLab.frame.size.height;
    CGFloat y = self.frame.size.height/2 - h/2 - 80;
    _defIamgeView.frame = CGRectMake(self.frame.size.width/2 - _defIamgeView.frame.size.width/2,
                                     y,
                                     _defIamgeView.frame.size.width,
                                     _defIamgeView.frame.size.height);
    _descLab.frame = CGRectMake(self.frame.size.width/2-_descLab.frame.size.width/2,
                                CGRectGetMaxY(_defIamgeView.frame)+20,
                                _descLab.frame.size.width,
                                _descLab.frame.size.height);
    _eventBtn.frame = CGRectMake((self.frame.size.width-100)/2,
                                 CGRectGetMaxY(_descLab.frame)+10, 100, 30);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (self.needTouch)
    {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark setter/getter
- (void)setDescInfo:(NSString *)descInfo
{
    if (descInfo != _descInfo)
    {
        _descInfo = [descInfo copy];
        _descLab.text = descInfo;
        [self layoutSubviews];
    }
}

- (void)setNeedTouch:(BOOL)needTouch
{
    if (needTouch != _needTouch)
    {
        _needTouch = needTouch;
        self.userInteractionEnabled = needTouch;
    }
}

#pragma mark private methods

@end
