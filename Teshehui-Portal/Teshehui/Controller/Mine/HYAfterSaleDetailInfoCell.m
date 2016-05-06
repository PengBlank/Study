//
//  HYAfterSaleDetailInfoCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYAfterSaleDetailInfoCell.h"
#import "Masonry.h"
#import "UIColor+hexColor.h"

@implementation HYAfterSaleDetailInfoCell
{
    //the left label!
    UILabel *_labelOrder;
    UILabel *_labelType;
    UILabel *_labelStatus;
    UILabel *_labelDate;
    UILabel *_labelDesc;
    
    //the right labels
    UILabel *_order;
    UILabel *_type;
    UILabel *_status;
    UILabel *_date;
    UILabel *_desc;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.separatorLeftInset = 0;
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        icon.image = [UIImage imageNamed:@"icon_order2"];
        [self.contentView addSubview:icon];
        
        _labelOrder = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelOrder.font = [UIFont systemFontOfSize:14.0];
        _labelOrder.backgroundColor = [UIColor clearColor];
        _labelOrder.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
        _labelOrder.text = @"对应订单号:";
        [self.contentView addSubview:_labelOrder];
        
        _labelType = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelType.font = [UIFont systemFontOfSize:14.0];
        _labelType.backgroundColor = [UIColor clearColor];
        _labelType.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
        _labelType.text = @"售后类型:";
        [self.contentView addSubview:_labelType];
        
        _labelStatus = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelStatus.font = [UIFont systemFontOfSize:14.0];
        _labelStatus.backgroundColor = [UIColor clearColor];
        _labelStatus.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
        _labelStatus.text = @"单据状态:";
        [self.contentView addSubview:_labelStatus];
        
        _labelDate = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelDate.font = [UIFont systemFontOfSize:14.0];
        _labelDate.backgroundColor = [UIColor clearColor];
        _labelDate.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
        _labelDate.text = @"申请时间:";
        [self.contentView addSubview:_labelDate];
        
        _labelDesc = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelDesc.font = [UIFont systemFontOfSize:14.0];
        _labelDesc.backgroundColor = [UIColor clearColor];
        _labelDesc.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
        _labelDesc.text = @"问题描述:";
        [self.contentView addSubview:_labelDesc];
        
        _order = [[UILabel alloc] initWithFrame:CGRectZero];
        _order.font = [UIFont systemFontOfSize:14.0];
        _order.backgroundColor = [UIColor clearColor];
        _order.textColor = [UIColor colorWithHexColor:@"494949" alpha:1];
        _order.text = @"asdfsdfsdf";
        [self.contentView addSubview:_order];
        
        _type = [[UILabel alloc] initWithFrame:CGRectZero];
        _type.font = [UIFont systemFontOfSize:14.0];
        _type.backgroundColor = [UIColor clearColor];
        _type.textColor = [UIColor colorWithHexColor:@"494949" alpha:1];
        _type.text = @"闪电退";
        [self.contentView addSubview:_type];
        
        _status = [[UILabel alloc] initWithFrame:CGRectZero];
        _status.font = [UIFont systemFontOfSize:14.0];
        _status.backgroundColor = [UIColor clearColor];
        _status.textColor = [UIColor colorWithHexColor:@"494949" alpha:1];
        _status.text = @"审核通过";
        [self.contentView addSubview:_status];
        
        _date = [[UILabel alloc] initWithFrame:CGRectZero];
        _date.font = [UIFont systemFontOfSize:14.0];
        _date.backgroundColor = [UIColor clearColor];
        _date.textColor = [UIColor colorWithHexColor:@"494949" alpha:1];
        [self.contentView addSubview:_date];
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectZero];
        desc.font = [UIFont systemFontOfSize:14.0];
        desc.backgroundColor = [UIColor clearColor];
        desc.textColor = [UIColor colorWithHexColor:@"494949" alpha:1];
        desc.numberOfLines = 0;
        desc.text = @"sdfffffs";
        [self.contentView addSubview:desc];
        _desc = desc;
        
        //Layout!
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(10);
        }];
        CGFloat linespace = 8;
        [_labelOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(10);
            make.centerY.equalTo(icon.mas_centerY);
        }];
        [_labelType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_labelOrder.mas_left);
            make.top.equalTo(_labelOrder.mas_bottom).offset(linespace);
        }];
        [_labelStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_labelOrder.mas_left);
            make.top.equalTo(_labelType.mas_bottom).offset(linespace);
        }];
        [_labelDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_labelOrder.mas_left);
            make.top.equalTo(_labelStatus.mas_bottom).offset(linespace);
        }];
        [_labelDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_labelDate.mas_left);
            make.top.equalTo(_labelDate.mas_bottom).offset(linespace);
        }];
        [_labelDesc setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh+1 forAxis:UILayoutConstraintAxisHorizontal];
        
        CGFloat vspace = 15;
        [_order mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_labelOrder.mas_right).offset(vspace);
            make.top.equalTo(_labelOrder.mas_top);
            make.right.mas_lessThanOrEqualTo(-10);
        }];
        [_status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_labelStatus.mas_right).offset(vspace);
            make.top.equalTo(_labelStatus.mas_top);
            make.right.mas_lessThanOrEqualTo(-10);
        }];
        [_type mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_labelType.mas_right).offset(vspace);
            make.top.equalTo(_labelType.mas_top);
            make.right.mas_lessThanOrEqualTo(-10);
        }];
        [_date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_labelDate.mas_right).offset(vspace);
            make.top.equalTo(_labelDate.mas_top);
            make.right.mas_lessThanOrEqualTo(-10);
        }];
        [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_labelDesc.mas_right).offset(vspace);
            make.top.equalTo(_labelDesc.mas_top);
            make.right.mas_lessThanOrEqualTo(-10);
        }];
    }
    return self;
}

/*
 UILabel *_order;
 UILabel *_type;
 UILabel *_status;
 UILabel *_date;
 UILabel *_desc;
 */
- (void)setSaleInfo:(HYMallAfterSaleInfo *)saleInfo
{
    if (_saleInfo != saleInfo)
    {
        _saleInfo = saleInfo;
        _order.text = saleInfo.orderCode;
        _type.text = saleInfo.operationTypeName;
        _status.text = saleInfo.statusShowName;
        _date.text = saleInfo.createTime;
        
        HYMallAfterSaleDetailInfo *detail = saleInfo.useDetail;
        if (detail != nil)
        {
            _desc.text = detail.remark;
        }
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        CGRect frame = self.frame;
        frame.size.height = CGRectGetMaxY(_desc.frame) + 10;
        self.frame = frame;
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
