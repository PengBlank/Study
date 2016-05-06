//
//  HYMallReturnsInfo.m
//  Teshehui
//
//  Created by HYZB on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallReturnsInfo.h"
#import "HYMallGoodsInfo.h"

@implementation HYMallReturnsInfo

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"order_id":@"orderId",
                                 @"order_sn": @"orderCode",
                                 @"goods_info": @"orderItem",
                                 @"seller_id": @"storeId",
                                 @"store_name": @"storeName",
                                 @"rec_id": @"refund_id"
                                 }];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self)
    {
        NSArray *array = GETOBJECTFORKEY(dict, @"goods_info", [NSArray class]);
        
        NSMutableArray *tempArr = [NSMutableArray array];
        for (id obj in array)
        {
            HYMallOrderItem *item = [[HYMallOrderItem alloc] initWithDataInfo:obj];
            [tempArr addObject:item];
        }
        
        if ([tempArr count])
        {
            self.orderItem = [tempArr copy];
        }
    }
    return self;
}

- (HYRefundStatus)refundStatus
{
    return _refund_status;
}

/*
退换货状态 0：待商家确认1：商家已确认2：商家拒绝3：买家已寄回商品4：卖家已重新发货5：买家已确认收货6：买家已寄出商品
*/

- (NSString *)statusDesc
{
    NSString *statusDesc = nil;
    switch (self.refund_status)
    {
        case 0:
            statusDesc = @"审核中";
            break;
        case 1:
            statusDesc = @"审核已通过";
            break;
        case 2:
            statusDesc = @"审核未通过";
            break;
        case 3:
        case 4:
        case 6:
            statusDesc = @"正在处理";
            break;
        case 5:
            if (self.refund_type == 2)  //如果为换货，则买家已确认收货对应说明换货已完成
            {
                statusDesc = @"已完成";
            }
            else
            {
                statusDesc = @"已完成";
            }
             break;
        case 7:
            statusDesc = @"退款中";
            break;
        case 8:
            statusDesc = @"已退款";
            break;
        default:
            statusDesc = @"联系客服";
            break;
    }
    
    return statusDesc;
}

@end

/*
HYRefundStatus refundStatusWithInt(NSInteger status)
{
    switch (status) {
        case 0:
            return HYRefund_MerchantVerifing;
            break;
        case 1:
            return HYRefund_MerchantVerified;
            break;
        case 2:
            return HYRefund_MerchantRefused;
            break;
        case 3:
            return HYRefund_MerchantRecieved;
            break;
        case 4:
            return HYRefund_MerchantResend;
            break;
        case 5:
            return HYRefund_BuyerRecieved;
            break;
        case 6:
            return HYRefund_BuyerSent;
            break;
        default:
            return HYRefund_Unkown;
            break;
    }
}
 */
