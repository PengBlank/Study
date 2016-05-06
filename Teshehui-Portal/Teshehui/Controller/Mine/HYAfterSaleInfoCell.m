//
//  HYAfterSaleInfoCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYAfterSaleInfoCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIColor+hexColor.h"

@implementation HYAfterSaleInfoCell
{
    UIImageView *_pic;
    UILabel *_name;
    UILabel *_price;
    UILabel *_date;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectZero];
        pic.layer.masksToBounds = YES;
        pic.layer.borderColor = [UIColor colorWithHexColor:@"cecece" alpha:1].CGColor;
        pic.layer.borderWidth = 1.0;
        [self.contentView addSubview:pic];
        _pic = pic;
    
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectZero];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont systemFontOfSize:13.0];
        name.textColor = [UIColor colorWithHexColor:@"494949" alpha:1];
        name.text = @"订单:";
        [self.contentView addSubview:name];
        _name = name;
        
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectZero];
        price.backgroundColor = [UIColor clearColor];
        price.font = [UIFont systemFontOfSize:13.0];
        price.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
        price.text = @"订单:";
        [self.contentView addSubview:price];
        _price = price;
        
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectZero];
        date.backgroundColor = [UIColor clearColor];
        date.font = [UIFont systemFontOfSize:13.0];
        date.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
        date.text = @"订单:";
        [self.contentView addSubview:date];
        _date = date;
        
        //Layout!
        [pic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(72, 72));
        }];
        
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pic.mas_top);
            make.left.equalTo(pic.mas_right).offset(10);
            make.right.mas_lessThanOrEqualTo(-12);
        }];
        
        [price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(name.mas_bottom).offset(5);
            make.left.equalTo(name.mas_left);
            make.right.mas_lessThanOrEqualTo(-12);
        }];
        
        [date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(price.mas_bottom).offset(5);
            make.left.equalTo(price.mas_left);
            make.right.mas_lessThanOrEqualTo(-12);
        }];
        
        
        //Test
        pic.image = [UIImage imageNamed:@"loading"];
        name.text = @"女士头套";
        price.text = @"退回商品总金额:$120+10现金券";
        date.text = @"申请时间:2015-02-34 18:00:00";
    }
    return self;
}

- (void)setOrder:(HYMallAfterSaleInfo *)order
{
    if (_order != order)
    {
        _order = order;
        
        if (order.useDetail.thumbnailPicUrl.length > 0)
        {
            NSURL *url = [NSURL URLWithString:order.useDetail.thumbnailPicUrl];
            [_pic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading"]];
        }
        if (order.detailInfo.count > 0)
        {
            HYMallAfterSaleDetailInfo *detail = [order.detailInfo objectAtIndex:0];
            _name.text = detail.productName;
            if (detail.salePrice)
            {
                NSString *pre = @"退回商品总金额:";
                NSString *price = [NSString stringWithFormat:@"%@+%@", detail.salePrice, detail.point];
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", pre, price]];
                [attr setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexColor:@"888888" alpha:1]} range:NSMakeRange(0, pre.length)];
                [attr setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexColor:@"494949" alpha:1]} range:NSMakeRange(pre.length, price.length)];
                _price.attributedText = attr;
            }
            else
            {
                _price.attributedText = nil;
            }
            
            if (_order.createTime)
            {
                NSString *pre = @"申请时间:";
                NSString *price = [NSString stringWithFormat:@"%@", detail.createTime];
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", pre, price]];
                [attr setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexColor:@"888888" alpha:1]} range:NSMakeRange(0, pre.length)];
                [attr setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexColor:@"494949" alpha:1]} range:NSMakeRange(pre.length, price.length)];
                _date.attributedText = attr;
            }
            else {
                _date.attributedText = nil;
            }
        }
        
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
