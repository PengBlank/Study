//
//  HYTaxiPriceView.m
//  Teshehui
//
//  Created by 成才 向 on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiPriceView.h"
#import "Masonry.h"

@implementation HYTaxiPriceView
{
    IBOutlet UILabel *_totalFee;
}

- (void)awakeFromNib
{
    self.layer.borderColor = [UIColor colorWithWhite:.9 alpha:1].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 3.0;
}


- (void)setOrderView:(HYTaxiOrderView *)orderView
{
    _orderView = orderView;
    _totalFee.text = [NSString stringWithFormat:@"%@元", orderView.didiOrderTotalAmount];
    if (orderView.orderFee.count > 0)
    {
        UIView *pre = nil;  //记录前一个行的位置, 每行相对进行步局
        for (int i = 0; i < orderView.orderFee.count; i++)
        {
            HYTaxiOrderFee *fee = [orderView.orderFee objectAtIndex:i];
            UILabel *left = [[UILabel alloc] initWithFrame:CGRectZero];
            left.font = [UIFont systemFontOfSize:16.0];
            left.textColor = [UIColor colorWithWhite:.6 alpha:1];
            left.text = fee.feeName;
            [self addSubview:left];
            
            [left mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
            }];
            //如果已有前一行已布好局, 根据前一行相对进行布局
            if (pre)
            {
                [left mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(pre.mas_bottom).offset(15);
                }];
            }
            //没有则顶部距50进行布局
            else
            {
                CGFloat distanceTop = 50;
                [left mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(distanceTop);
                }];
            }
            pre = left;
            
            UILabel *right = [[UILabel alloc] initWithFrame:CGRectZero];
            right.font = [UIFont systemFontOfSize:16.0];
            right.textColor = [UIColor colorWithWhite:.6 alpha:1];
            right.text = fee.fee;
            [self addSubview:right];
            
            [right mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15);
                make.top.equalTo(left.mas_top);
            }];
        }
        
        //最后一行距底部58
        CGFloat distanceForLastWithBottom = 54;
        [self setNeedsLayout];
        [self layoutIfNeeded];
        CGRect frame = self.frame;
        frame.size.height = CGRectGetMaxY(pre.frame) + distanceForLastWithBottom;
        self.frame = frame;
        [self setNeedsLayout];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
