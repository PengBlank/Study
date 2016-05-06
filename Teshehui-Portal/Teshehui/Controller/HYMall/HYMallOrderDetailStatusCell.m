//
//  HYMallOrderDetailStatusCell.m
//  Teshehui
//
//  Created by HYZB on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderDetailStatusCell.h"

@interface HYMallOrderDetailStatusCell ()
{
    UILabel *_childOrderLabel;
    UILabel *_creationTimeLabel;
    UILabel *_orderTotalFeeLabel;
    UILabel *_orderStatusLabel;
    
    UIImageView *_childOrderImg;
}

@end

@implementation HYMallOrderDetailStatusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _childOrderLabel = [UILabel new];
        _childOrderLabel.frame = CGRectMake(50, 10, 300, 15);
        _childOrderLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_childOrderLabel];
        
        _childOrderImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mallOrder_order"]];
        _childOrderImg.frame = CGRectMake(25, 10, 15, 18);
        [self.contentView addSubview:_childOrderImg];
        
        _orderStatusLabel = [UILabel new];
        _orderStatusLabel.frame = CGRectMake(50, 35, 250, 15);
        _orderStatusLabel.font = [UIFont systemFontOfSize:14];
        _orderStatusLabel.text = [NSString stringWithFormat:@"订单状态："];
        [self.contentView addSubview:_orderStatusLabel];
        
        _orderTotalFeeLabel = [UILabel new];
        _orderTotalFeeLabel.frame = CGRectMake(50, 60, TFScalePoint(260), 15);
        _orderTotalFeeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_orderTotalFeeLabel];
        
        _creationTimeLabel = [UILabel new];
        _creationTimeLabel.frame = CGRectMake(50, 85, 250, 15);
        _creationTimeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_creationTimeLabel];
        
        
        
//        self.textLabel.font = [UIFont systemFontOfSize:16];
//        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
//        
//        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
//        self.detailTextLabel.text = @"订单金额(含运费):";
//        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
//        
//        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, 36, 120, 20)];
//        _priceLabel.textColor = [UIColor colorWithRed:161.0/255.0
//                                                green:0
//                                                 blue:0
//                                                alpha:1.0];
//        _priceLabel.font = [UIFont systemFontOfSize:14];
//        [self.contentView addSubview:_priceLabel];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.textLabel.frame = CGRectMake(14, 10, 120, 20);
//    self.detailTextLabel.frame = CGRectMake(14, 36, 120, 20);
}

#pragma mark setter/getter
- (void)setChildOrder:(HYMallChildOrder *)childOrder
{
    _childOrder = childOrder;
    
    if (_childOrder.orderCode)
    {
        _childOrderLabel.text = [NSString stringWithFormat:@"子订单：%@",_childOrder.orderCode];
    }
    if (_childOrder.orderShowStatus)
    {
        _orderStatusLabel.text = [NSString stringWithFormat:@"订单状态：%@",_childOrder.orderShowStatus];
    }
    if (_childOrder.orderActualAmount)
    {
        _orderTotalFeeLabel.text = [NSString stringWithFormat:@"订单金额：￥%@+%@现金券（含运费）",_childOrder.orderActualAmount,_childOrder.orderTbAmount];
    }
    if (_childOrder.creationTime)
    {
        _creationTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",_childOrder.creationTime];
    }
}

//- (void)setPriceInfo:(NSString *)priceInfo
//{
//    if (priceInfo != _priceInfo)
//    {
//        _priceInfo = priceInfo;
//        _priceLabel.text = priceInfo;
//    }
//}



@end
