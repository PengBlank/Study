//
//  HYAfterSaleBriefCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYAfterSaleBriefCell.h"
#import "Masonry.h"
#import "UIColor+hexColor.h"

@implementation HYAfterSaleBriefCell
{
    UILabel *_orderNo;
    UILabel *_status;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        icon.image = [UIImage imageNamed:@"icon_order2"];
        [self.contentView addSubview:icon];
        
        UILabel *order = [[UILabel alloc] initWithFrame:CGRectZero];
        order.backgroundColor = [UIColor clearColor];
        order.font = [UIFont systemFontOfSize:14.0];
        order.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
        order.text = @"订单:";
        [self.contentView addSubview:order];
        
        UILabel *no = [[UILabel alloc] initWithFrame:CGRectZero];
        no.backgroundColor = [UIColor clearColor];
        no.font = [UIFont systemFontOfSize:14.0];
        no.textColor = [UIColor colorWithHexColor:@"494949" alpha:1];
        no.text = @"";
        [self.contentView addSubview:no];
        _orderNo = no;
        
        UILabel *status = [[UILabel alloc] initWithFrame:CGRectZero];
        status.backgroundColor = [UIColor clearColor];
        status.font = [UIFont systemFontOfSize:14.0];
        status.textColor = [UIColor colorWithHexColor:@"494949" alpha:1];
        status.text = @"";
        [self.contentView addSubview:status];
        _status = status;
        
        //Layout!
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        [order mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(4);
            make.centerY.equalTo(icon.mas_centerY);
        }];
        [no mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(order.mas_right).offset(3);
            make.centerY.equalTo(order.mas_centerY);
        }];
        [status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.equalTo(icon.mas_centerY);
        }];
        [no mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.lessThanOrEqualTo(status.mas_left);
        }];
        
        //Test datas
        _orderNo.text = @"abcdedf223422abcdedf223422abcdedf223422abcdedf223422abcdedf223422";
        _status.text = @"待处理待处理";
    }
    return self;
}

- (void)setItem:(HYMallAfterSaleInfo *)item
{
    if (_item != item)
    {
        _item = item;
        _orderNo.text = item.orderCode;
        _status.text = item.statusShowName;
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
