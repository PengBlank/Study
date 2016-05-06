//
//  HYOrderDetailInfoCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelOrderDetailInfoCell.h"
#import "Masonry.h"

@interface HYHotelOrderDetailInfoCell ()
{
    UILabel *_infoNameLab;
    UILabel *_infoValueLab;
}

@end

@implementation HYHotelOrderDetailInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _infoNameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoNameLab.font = [UIFont systemFontOfSize:14.0];
        _infoNameLab.backgroundColor = [UIColor clearColor];
        _infoNameLab.textColor = [UIColor colorWithWhite:.4 alpha:1];
        [self.contentView addSubview:_infoNameLab];
        [_infoNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        _infoValueLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoValueLab.font = [UIFont systemFontOfSize:14.0];
        _infoValueLab.backgroundColor = [UIColor clearColor];
        _infoValueLab.textColor = [UIColor colorWithWhite:.4 alpha:1];
        [self.contentView addSubview:_infoValueLab];
        [_infoValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_infoNameLab.mas_right).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.mas_lessThanOrEqualTo(-10);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfoName:(NSString *)infoName
{
    if (infoName != _infoName)
    {
        _infoName = infoName;
        _infoNameLab.text = infoName;
    }
}

- (void)setInfoValue:(NSString *)infoValue
{
    if (_infoValue != infoValue)
    {
        _infoValue = infoValue;
        _infoValueLab.text = infoValue;
    }
}

- (void)setIsRed:(BOOL)isRed
{
    if (isRed)
    {
        _infoValueLab.textColor = [UIColor colorWithRed:255.0f/255.0
                                                  green:154.0f/255.0f
                                                   blue:64.0f/255.0f
                                                  alpha:1.0];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _infoNameLab.textColor = [UIColor colorWithWhite:.4 alpha:1];
    _infoValueLab.textColor = [UIColor colorWithWhite:.4 alpha:1];
}

#pragma mark setter/getter
//- (void)setOrderStatusDesc:(NSString *)orderStatusDesc
//{
//    if (_orderStatusDesc != orderStatusDesc)
//    {
//        _orderStatusDesc = [orderStatusDesc copy];
//    }
//    _stautsLab.text = orderStatusDesc;
//}
//
//- (void)setOrderNO:(NSString *)orderNO
//{
//    if (_orderNO != orderNO)
//    {
//        _orderNO = [_orderNO copy];
//        _orderLab.text = orderNO;
//    }
//}
//
//- (void)setCreateTime:(NSString *)createTime
//{
//    if (_createTime != createTime)
//    {
//        _createTime = [createTime copy];
//        _timeLab.text = createTime;
//    }
//}

@end
