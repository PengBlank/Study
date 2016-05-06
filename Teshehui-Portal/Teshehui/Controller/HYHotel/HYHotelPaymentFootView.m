//
//  HYHotelPaymentFootView.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYHotelPaymentFootView.h"
#import "Masonry.h"

@implementation HYHotelPaymentFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UILabel *total = [[UILabel alloc] initWithFrame:CGRectZero];
        total.text = @"总额:";
        total.textColor = [UIColor grayColor];
        total.backgroundColor = [UIColor clearColor];
        total.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:total];
        [total mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
//        NSString *orderTitle = _roomSKU.isPrePay ? @"立即预付" : @"立即预订";
        UIButton *orderBtn = [[UIButton alloc] initWithFrame:CGRectZero];
//        [orderBtn setTitle:orderTitle forState:UIControlStateNormal];
//        [orderBtn addTarget:self action:@selector(advanceBooking:) forControlEvents:UIControlEventTouchUpInside];
        orderBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:153/255.0 blue:19/255.0 alpha:1];
        orderBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:orderBtn];
        _orderBtn = orderBtn;
        [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(80);
        }];
        
        UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectZero];
        priceLab.backgroundColor = [UIColor clearColor];
        priceLab.textColor = [UIColor colorWithRed:224/255.0 green:2/255.0 blue:43/255.0 alpha:1];
        [self addSubview:priceLab];
        _priceLab = priceLab;
        [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(total.mas_right).offset(10);
            make.right.lessThanOrEqualTo(orderBtn.mas_left);
            make.top.mas_equalTo(5);
        }];
        
        
        UILabel *pointLab = [[UILabel alloc] initWithFrame:CGRectZero];
        pointLab.backgroundColor = [UIColor clearColor];
        pointLab.textColor = [UIColor colorWithRed:255/255.0 green:126/255.0 blue:50/255.0 alpha:1];
        pointLab.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:pointLab];
        _pointsLab = pointLab;
        [pointLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(priceLab.mas_left);
            make.top.equalTo(priceLab.mas_bottom).offset(3);
            make.right.lessThanOrEqualTo(orderBtn.mas_left);
        }];
    }
    return self;
}

- (void)setPrice:(NSString *)price
{
    if (_price != price)
    {
        _price = price;
        @try {
            NSString *sprice = [NSString stringWithFormat:@"￥%.0f", price.floatValue];
            NSMutableAttributedString *priceattr = [[NSMutableAttributedString alloc] initWithString:sprice];
            [priceattr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11.0]} range:NSMakeRange(0, 1)];
            [priceattr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} range:NSMakeRange(1, sprice.length-1)];
            _priceLab.attributedText = priceattr;
        }
        @catch (NSException *exception) {
            DebugNSLog(@"set price exeption:%@", exception.description);
            _priceLab.text = nil;
        }
        @finally {
            
        }
    }
}

- (void)setPoints:(NSString *)points
{
    if (_points != points)
    {
        _points = points;
        _pointsLab.text = [NSString stringWithFormat:@"赠送现金券:%@", points];
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
