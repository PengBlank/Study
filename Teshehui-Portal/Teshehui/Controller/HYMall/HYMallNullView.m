//
//  HYMallNullView.m
//  Teshehui
//
//  Created by Kris on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallNullView.h"
#import "UIImage+Addition.h"

@interface HYMallNullView ()
{
    UIButton *_goToMallHomeBtn;
}

@end

@implementation HYMallNullView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.icon = [UIImage imageNamed:@"icon_empty"];
        
        _goToMallHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goToMallHomeBtn.frame = TFRectMake(110, 230, 100, 40);
        [_goToMallHomeBtn setTitle:@"去逛逛" forState:UIControlStateNormal];
        [_goToMallHomeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_goToMallHomeBtn setBackgroundImage:[[UIImage imageNamed:@"mall_afterSaleType"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [_goToMallHomeBtn addTarget:self action:@selector(goToHome:) forControlEvents:UIControlEventTouchUpInside];
        _goToMallHomeBtn.hidden = YES;
        _goToMallHomeBtn.titleLabel.font = [UIFont systemFontOfSize:TFScalePoint(13)];
        [self addSubview:_goToMallHomeBtn];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _goToMallHomeBtn.frame = CGRectMake(self.frame.size.width/2 - _goToMallHomeBtn.frame.size.width/2,
                                        CGRectGetMaxY(self.descLab.frame) + 10,
                                        _goToMallHomeBtn.frame.size.width,
                                        _goToMallHomeBtn.frame.size.height);
}

#pragma mark private methods
- (void)goToHome:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(goBackToMallHomeFromButton:)])
    {
        [self.delegate goBackToMallHomeFromButton:sender];
    }
}

-(void)setFilterype:(NSInteger)filterype
{
    _filterype = filterype;
    
    _goToMallHomeBtn.hidden = !(0 == _filterype);
   
}
@end
