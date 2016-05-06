//
//  HYFlowerPay_1_Cell.m
//  Teshehui
//
//  Created by ichina on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerPay_1_Cell.h"

@implementation HYFlowerPay_1_Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = NO;
        
        _ddbhLab = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 280, 20)];
         _ddbhLab.backgroundColor = [UIColor clearColor];
        _ddbhLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview: _ddbhLab];
        
        _xdsjLab = [[UILabel alloc]initWithFrame:CGRectMake(10,30, 280, 20)];
        _xdsjLab.backgroundColor = [UIColor clearColor];
        _xdsjLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview: _xdsjLab];
        
        _shrLab = [[UILabel alloc]initWithFrame:CGRectMake(10,50, 280, 20)];
        _shrLab.backgroundColor = [UIColor clearColor];
        _shrLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview: _shrLab];
        
        _sjLab = [[UILabel alloc]initWithFrame:CGRectMake(10,70, 280, 20)];
        _sjLab.backgroundColor = [UIColor clearColor];
        _sjLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview: _sjLab];
        
        _shdzLab = [[UILabel alloc]initWithFrame:CGRectMake(10,90, 280, 40)];
        _shdzLab.numberOfLines = 2;
        _shdzLab.backgroundColor = [UIColor clearColor];
        _shdzLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview: _shdzLab];
    }
    return self;
}

-(void)setList:(HYFlowerOrderInfo*)OrderInfo
{
    _ddbhLab.text = [NSString stringWithFormat:@"订单编号: %@",OrderInfo.order_no];
    _xdsjLab.text = [NSString stringWithFormat:@"下单时间: %@",OrderInfo.created];
    _shrLab.text = [NSString stringWithFormat:@"收货人: %@",OrderInfo.receiver_name];
    _sjLab.text = [NSString stringWithFormat:@"手机: %@",OrderInfo.receiver_phone];
    _shdzLab.text = [NSString stringWithFormat:@"收货地址:%@%@%@%@",OrderInfo.province,OrderInfo.city,OrderInfo.district,OrderInfo.receiver_address];
}

@end
