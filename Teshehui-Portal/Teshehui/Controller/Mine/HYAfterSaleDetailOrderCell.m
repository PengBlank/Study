//
//  HYAfterSaleDetailOrderCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYAfterSaleDetailOrderCell.h"
#import "UIColor+hexColor.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@implementation HYAfterSaleDetailOrderCell
{
    UIImageView *_pic;
    UILabel *_name;
    UILabel *_size;
    UILabel *_quantity;
    UILabel *_price;
    UILabel *_status;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.separatorLeftInset = 0;
        UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectZero];
        pic.layer.masksToBounds = YES;
        pic.layer.borderColor = [UIColor colorWithHexColor:@"cecece" alpha:1].CGColor;
        pic.layer.borderWidth = 1.0;
        [self.contentView addSubview:pic];
        _pic = pic;
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectZero];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont systemFontOfSize:14.0];
        name.textColor = [UIColor colorWithHexColor:@"494949" alpha:1];
        name.text = @"订单:";
        [self.contentView addSubview:name];
        _name = name;
        
        UILabel *size = [[UILabel alloc] initWithFrame:CGRectZero];
        size.backgroundColor = [UIColor clearColor];
        size.font = [UIFont systemFontOfSize:14.0];
        size.textColor = [UIColor colorWithHexColor:@"494949" alpha:1];
        size.text = @"颜色:";
        [self.contentView addSubview:size];
        _size = size;
        
        UILabel *quantity = [[UILabel alloc] initWithFrame:CGRectZero];
        quantity.backgroundColor = [UIColor clearColor];
        quantity.font = [UIFont systemFontOfSize:14.0];
        quantity.textColor = [UIColor colorWithHexColor:@"494949" alpha:1];
        quantity.text = @"退回数量:";
        [self.contentView addSubview:quantity];
        _quantity = quantity;
        
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectZero];
        price.backgroundColor = [UIColor clearColor];
        price.font = [UIFont systemFontOfSize:14.0];
        price.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
        price.text = @"金额:";
        [self.contentView addSubview:price];
        _price = price;
        
        UILabel *status = [[UILabel alloc] initWithFrame:CGRectZero];
        status.backgroundColor = [UIColor clearColor];
        status.font = [UIFont systemFontOfSize:14.0];
        status.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
        status.text = @"订单:";
        [self.contentView addSubview:status];
        _status = status;
        
        //Layout!
        CGFloat linespace = 8;
        [pic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(75, 75));
        }];
        
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pic.mas_top);
            make.left.equalTo(pic.mas_right).offset(8);
            make.right.mas_lessThanOrEqualTo(-12);
        }];
        
        [size mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(name.mas_bottom).offset(linespace);
            make.left.equalTo(name.mas_left);
            make.right.mas_lessThanOrEqualTo(-12);
        }];
        
        [quantity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(size.mas_bottom).offset(linespace);
            make.left.equalTo(name.mas_left);
            make.right.mas_lessThanOrEqualTo(-12);
        }];
        
        [price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(quantity.mas_bottom).offset(linespace);
            make.left.equalTo(quantity.mas_left);
            make.right.mas_lessThanOrEqualTo(-12);
        }];
        
        [status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(price.mas_bottom).offset(3);
            make.left.equalTo(price.mas_left);
            make.right.mas_lessThanOrEqualTo(-12);
        }];
        
        //Test
        pic.image = [UIImage imageNamed:@"loading"];
        name.text = @"女士头套";
        size.text = @"白色 尺码";
        quantity.text = @"退回数量:1";
        price.text = @"退回商品总金额:$120+10现金券";
        status.text = @"商品状态:待处理";
    }
    return self;
}

/*
 UIImageView *_pic;
 UILabel *_name;
 UILabel *_size;
 UILabel *_quantity;
 UILabel *_price;
 UILabel *_status;
 */
- (void)setSaleInfo:(HYMallAfterSaleInfo *)saleInfo
{
    if (_saleInfo != saleInfo)
    {
        _saleInfo = saleInfo;
        
        NSURL *url = [NSURL URLWithString:saleInfo.useDetail.thumbnailPicUrl];
        [_pic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading"]];
        _name.text = saleInfo.useDetail.productName;
        _size.text = saleInfo.useDetail.specifications;
        
        if (saleInfo.useDetail.quantity)
        {
            NSString *pre = @"退回数量:";
            NSString *price = [NSString stringWithFormat:@"%@", saleInfo.useDetail.quantity];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", pre, price]];
            [attr setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexColor:@"888888" alpha:1]} range:NSMakeRange(0, pre.length)];
            [attr setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexColor:@"494949" alpha:1]} range:NSMakeRange(pre.length, price.length)];
            _quantity.attributedText = attr;
        }
        else
        {
            _quantity.text = nil;
        }
        if (saleInfo.useDetail.salePrice)
        {
            NSString *pre = @"退回商品总金额:";
            NSString *price = [NSString stringWithFormat:@"¥%@+%@现金券", saleInfo.useDetail.salePrice, saleInfo.useDetail.point];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", pre, price]];
            [attr setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexColor:@"888888" alpha:1]} range:NSMakeRange(0, pre.length)];
            [attr setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexColor:@"494949" alpha:1]} range:NSMakeRange(pre.length, price.length)];
            _price.attributedText = attr;
        }
        else
        {
            _price.text = nil;
        }
        if (saleInfo.useDetail.quantity)
        {
            NSString *pre = @"商品状态:";
            NSString *price = [NSString stringWithFormat:@"%@", saleInfo.useDetail.statusShowName];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", pre, price]];
            [attr setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexColor:@"888888" alpha:1]} range:NSMakeRange(0, pre.length)];
            [attr setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexColor:@"494949" alpha:1]} range:NSMakeRange(pre.length, price.length)];
            _status.attributedText = attr;
        }
        else
        {
            _status.text = nil;
        }
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        CGRect frame = self.frame;
        frame.size.height = CGRectGetMaxY(_status.frame) + 10;
        self.frame = frame;
    }
}

//- (void)updateConstraints
//{
//    [super updateConstraints];
//    CGRect frame = self.frame;
//    frame.size.height = CGRectGetMaxY(_status.frame) + 10;
//    self.frame = frame;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
