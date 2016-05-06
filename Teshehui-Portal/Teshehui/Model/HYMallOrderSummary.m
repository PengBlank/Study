//
//  HYMallOrderSummary.m
//  Teshehui
//
//  Created by HYZB on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderSummary.h"
#import "NSDate+Addition.h"

@implementation HYMallOrderSummary

////php 解析过程
//- (id)initWithDataInfo:(NSDictionary *)data
//{
//    self = [super init];
//    
//    if (self)
//    {
//        self.orderId = GETOBJECTFORKEY(data, @"orderId", [NSString class]);
//        self.orderCode = GETOBJECTFORKEY(data, @"orderCode", [NSString class]);
//        self.orderShowStatus = GETOBJECTFORKEY(data, @"orderShowStatus", [NSString class]);
//        self.status = [GETOBJECTFORKEY(data, @"status", [NSString class]) intValue];
//        self.buyerId = GETOBJECTFORKEY(data, @"buyerId", [NSString class]);
//        
//        self.deliveryFee = GETOBJECTFORKEY(data, @"deliveryFee", [NSString class]);
//        self.discountAmount = GETOBJECTFORKEY(data, @"discountAmount", [NSString class]);
//        self.orderTbAmount = GETOBJECTFORKEY(data, @"orderTbAmount", [NSString class]);
//        self.itemTotalAmount = GETOBJECTFORKEY(data, @"itemTotalAmount", [NSString class]);
//        self.orderTotalAmount = GETOBJECTFORKEY(data, @"orderTotalAmount", [NSString class]);
//        self.orderPayAmount = GETOBJECTFORKEY(data, @"orderPayAmount", [NSString class]);
////        self.storeId = GETOBJECTFORKEY(data, @"storeId", [NSString class]);
////        self.storeName = GETOBJECTFORKEY(data, @"storeName", [NSString class]);
//        self.creationTime = GETOBJECTFORKEY(data,@"creationTime",[NSString class]);
//        self.cancelTime = GETOBJECTFORKEY(data,@"cancelTime",[NSString class]);
////        self.remark = GETOBJECTFORKEY(data,@"evaluable",[NSString class]);
////        self.isDelete = GETOBJECTFORKEY(data, @"isDelete", [NSString class]);
////        self.businessType = GETOBJECTFORKEY(data, @"businessType", [NSString class]);
////        self.buyerEmail = GETOBJECTFORKEY(data, @"buyerEmail", [NSString class]);
////        self.payType = GETOBJECTFORKEY(data, @"payType", [NSString class]);
//        
//        NSArray *items = GETOBJECTFORKEY(data, @"orderItemList", [NSArray class]);
//        NSMutableArray *muTempArray = [NSMutableArray array];
//        for (NSDictionary *dict in items)
//        {
//            HYMallOrderItem *goodsInfo = [[HYMallOrderItem alloc] initWithDataInfo:dict];
//            goodsInfo.orderId = self.orderId;
//            [muTempArray addObject:goodsInfo];
//        }
//        self.orderItem = [muTempArray copy];
//        
//        NSDictionary *adds = GETOBJECTFORKEY(data, @"deliveryAddressPO", [NSDictionary class]);
//        
//        self.address = [[HYAddressInfo alloc] initWithDataInfo:adds];
//    }
//    
//    return self;
//}

//java 解析过程
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    if (self = [super initWithDictionary:dict error:err])
    {
//        NSArray *addrs = [dict objectForKey:@"deliveryAddressPOList"];
//        if (addrs.count > 0)
//        {
//            self.address = [[HYAddressInfo alloc] initWithOrderAddrInfo:addrs[0]];
//        }
//        for (HYMallOrderItem *item in self.orderItem)
//        {
//            item.orderId = self.orderId;
//        }
    }
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

//java 解析
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{@"childOrderPOList": @"orderItem"}];
}

- (HYOrderGoodsEvaluationStatus)evaluable
{
    HYOrderGoodsEvaluationStatus e = HYCannotEvaluation;
    for (HYMallOrderItem *goods in self.orderItem)
    {
        if (goods.isEvaluable == HYCanEvaluation)
        {
            e = HYCanEvaluation;
            break;
        }
        else if (goods.isEvaluable == HYCanAddEvaluation)
        {
            e = HYCanAddEvaluation;
        }
    }
    return e;
}

- (NSString *)statusDesc
{
    NSString *statusDesc = nil;
    switch (self.status)
    {
        case 10:
            statusDesc = @"待付款";
            break;
        case 20:
            statusDesc = @"待审核";
            break;
        case 30:
            statusDesc = @"待发货";
            break;
        case 40:
            statusDesc = @"待收货";
            break;
        case 50:
            statusDesc = @"交易完成";
            break;
        case -10:
            statusDesc = @"申请取消中";
            break;
        case -20:
            statusDesc = @"已取消";
            break;
        default:  //异常订单
            statusDesc = @"联系客服";
            break;
    }
    
    return statusDesc;
}

/*
@APP

新版商城订单状态以及相关操作说明

10:待付款; 20:待审核; 30:待发货; 40:待收货; 50:交易完成; -10:申请取消中; -20:已取消;

 */
@end
