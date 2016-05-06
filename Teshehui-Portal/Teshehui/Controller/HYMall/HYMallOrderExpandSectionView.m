//
//  HYMallOrderExpandSectionView.m
//  Teshehui
//
//  Created by HYZB on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderExpandSectionView.h"

@implementation HYMallOrderExpandSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _expand = YES;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-1)];
        bgView.backgroundColor = [UIColor colorWithRed:235.0/255.0
                                                 green:235.0/255.0
                                                  blue:241.0/255.0
                                                 alpha:1.0];
        [self addSubview:bgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        label.backgroundColor = [UIColor clearColor];
        label.shadowColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0.5, 0.5);
        label.text = @"订单详情";
        [self addSubview:label];
        
        _expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _expandBtn.frame = CGRectMake(frame.size.width-90, 6, 80, 28);
        [_expandBtn setBackgroundImage:[UIImage imageNamed:@"mall_order_handle_btn_bg"]
                              forState:UIControlStateNormal];
        [_expandBtn setTitle:@"全部收起"
                    forState:UIControlStateNormal];
        [_expandBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_expandBtn setTitleColor:[UIColor colorWithWhite:0.4
                                                    alpha:1.0]
                         forState:UIControlStateNormal];
        [_expandBtn addTarget:self
                       action:@selector(expandAllCell)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_expandBtn];
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

#pragma mark - private methods
- (void)expandAllCell
{
    if ([self.delegate respondsToSelector:@selector(didExpandAllCell:)])
    {
        _expand = !_expand;
        
        NSString *title = _expand ? @"全部收起" : @"全部展开";
        [_expandBtn setTitle:title
                    forState:UIControlStateNormal];
        
        [self.delegate didExpandAllCell:_expand];
    }
}
@end
