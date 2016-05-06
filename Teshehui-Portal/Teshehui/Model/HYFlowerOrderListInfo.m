//
//  HYFlowerOrderListInfo.m
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerOrderListInfo.h"

@interface HYFlowerOrderListInfo ()

@property (nonatomic, assign) CGFloat userMessageHeight;
@property (nonatomic, assign) CGFloat addressHeight;
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation HYFlowerOrderListInfo

@synthesize statusDesc = _statusDesc;

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.orderID = GETOBJECTFORKEY(data, @"id", [NSString class]);
        self.order_no = GETOBJECTFORKEY(data, @"order_no", [NSString class]);
        self.pay_total = GETOBJECTFORKEY(data, @"pay_total", [NSString class]);
        self.created = GETOBJECTFORKEY(data, @"created", [NSString class]);
        self.order_status = GETOBJECTFORKEY(data, @"order_status", [NSString class]);
        self.total_amount = GETOBJECTFORKEY(data, @"total_amount", [NSString class]);
        self.quantity = GETOBJECTFORKEY(data, @"quantity", [NSString class]);
        self.product_name = GETOBJECTFORKEY(data, @"product_name", [NSString class]);
        self.product_desc = GETOBJECTFORKEY(data, @"product_desc", [NSString class]);
        self.product_img = GETOBJECTFORKEY(data, @"product_img", [NSString class]);
        self.product_pack = GETOBJECTFORKEY(data, @"product_pack", [NSString class]);
        self.province = GETOBJECTFORKEY(data, @"province", [NSString class]);
        self.city = GETOBJECTFORKEY(data, @"city", [NSString class]);
        self.district = GETOBJECTFORKEY(data, @"district", [NSString class]);
        self.receiver_address = GETOBJECTFORKEY(data, @"receiver_address", [NSString class]);
        self.receiver_name = GETOBJECTFORKEY(data, @"receiver_name", [NSString class]);
        self.small_product_img = GETOBJECTFORKEY(data, @"small_product_img", [NSString class]);
        self.middle_product_img = GETOBJECTFORKEY(data, @"middle_product_img", [NSString class]);
        self.unit_price = GETOBJECTFORKEY(data, @"unit_price", [NSString class]);
        self.points = GETOBJECTFORKEY(data, @"points", [NSString class]);
        self.delivery_time  = GETOBJECTFORKEY(data, @"delivery_time", [NSString class]);
        
        self.user_id = GETOBJECTFORKEY(data, @"user_id", [NSString class]);
        self.user_name = GETOBJECTFORKEY(data, @"user_name", [NSString class]);
        self.order_type = [GETOBJECTFORKEY(data, @"order_type", [NSString class]) integerValue];
        
        NSMutableString *address = [[NSMutableString alloc] initWithString:@"收货地址: "];
        
        if (self.province)
        {
            [address appendString:self.province];
        }
        if (self.city)
        {
            [address appendString:self.city];
        }
        if (self.district)
        {
            [address appendString:self.district];
        }
        if (self.receiver_address)
        {
            [address appendString:self.receiver_address];
            
        }
        
        if ([address length] > 0)
        {
            self.address = [address copy];
        }
        
        NSString *remark = GETOBJECTFORKEY(data, @"remark", [NSString class]);
        if ([remark length] <= 0)
        {
            remark = @"祝福语: 无";
        }
        else
        {
            remark = [NSString stringWithFormat:@"祝福语: %@", remark];
        }
        self.userMessage = remark;
    }
    
    return self;
}

- (CGFloat)userMessageHeight
{
    if (_userMessageHeight <= 0)
    {
        CGSize size = [self.userMessage sizeWithFont:[UIFont systemFontOfSize:12]
                                   constrainedToSize:CGSizeMake(300, 100)
                                       lineBreakMode:NSLineBreakByCharWrapping];
        _userMessageHeight = (size.height+6);
        _userMessageHeight = _userMessageHeight>20 ? _userMessageHeight : 20;
    }
    
    return _userMessageHeight;
}

- (CGFloat)addressHeight
{
    if (_addressHeight <= 0)
    {
        CGSize size = [self.address sizeWithFont:[UIFont systemFontOfSize:12]
                                   constrainedToSize:CGSizeMake(300, 100)
                                       lineBreakMode:NSLineBreakByCharWrapping];
        _addressHeight = (size.height+6);
        _addressHeight = _addressHeight>20 ? _addressHeight : 20;
    }
    
    return _addressHeight;
}

- (CGFloat)contentHeight
{
    if (_contentHeight <= 0)
    {
        _contentHeight = (100+self.userMessageHeight+self.addressHeight+120);
    }
    
    return _contentHeight;
}

- (NSString *)statusDesc
{
    if (!_statusDesc)
    {
        NSInteger status = [_order_status integerValue];
        switch (status) {
            case 1:
                _statusDesc = @"未支付";
                break;
            case 2:
                _statusDesc = @"已支付";
                break;
            case 3:
                _statusDesc = @"配送中";
                break;
            case 4:
                _statusDesc = @"已签收";
                break;
            case 5:
                _statusDesc = @"订单完成";
                break;
            case 6:
                _statusDesc = @"已取消";
                break;
            case 7:
                _statusDesc = @"已退货";
                break;
            case -99:
                _statusDesc = @"已删除";
                break;
            default:
                break;
        }
    }
    return _statusDesc;
}

@end
