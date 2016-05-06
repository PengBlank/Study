//
//  HYPhoneChargeDataController.m
//  Teshehui
//
//  Created by Kris on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYPhoneChargeDataController.h"
#import "HYGetRechargeGoodsRequest.h"
#import "HYGetRechargeGoodsResponse.h"
#import "HYAddRechargeOrderRequest.h"
#import "HYAddRechargeOrderResponse.h"
#import "HYPhoneChargeModel.h"
#import "METoast.h"

@interface HYPhoneChargeDataController ()
{
    HYGetRechargeGoodsRequest *_getRechargeGoodsRequest;
    HYAddRechargeOrderRequest *_addRechargeOrderRequest;
}

@property (nonatomic, copy) NSString *phoneNum;

@end

@implementation HYPhoneChargeDataController

- (void)dealloc
{
    [_getRechargeGoodsRequest cancel];
    [_addRechargeOrderRequest cancel];
}

- (void)fetchRechargeGoodsType:(NSUInteger)type
                  withPlatForm:(NSUInteger)platForm
               completionBlock:(RechargeBlock)block
{
    [self fetchRechargeGoodsType:type
                    withPlatForm:platForm
                       andNumber:nil
                 completionBlock:block];
}

- (void)fetchRechargeGoodsType:(NSUInteger)type
                  withPlatForm:(NSUInteger)platForm
                     andNumber:(NSString *)num
               completionBlock:(RechargeBlock)block
{
    if (!_getRechargeGoodsRequest)
    {
        _getRechargeGoodsRequest = [[HYGetRechargeGoodsRequest alloc]init];
    }
    [_getRechargeGoodsRequest cancel];
    _getRechargeGoodsRequest.typeId = [NSString stringWithFormat:@"%lu",(unsigned long)platForm];
    _getRechargeGoodsRequest.catalogId = [NSString stringWithFormat:@"%lu",(unsigned long)type];;
    _getRechargeGoodsRequest.mobilePhone = num;
    //13418459758 for test
    self.phoneNum = num;
    
    [_getRechargeGoodsRequest sendReuqest:^(HYGetRechargeGoodsResponse *result, NSError *error) {
        if (result.dataList.count > 0)
        {
            if (block)
            {
                block(result.dataList);
            }
        }
        else
        {
            [METoast toastWithMessage:result.suggestMsg];
        }
    }];
}

//add recharge order
- (void)addRechargeOrderWithParamObjects:(id)param
                                    Type:(NSUInteger)type
                         CompletionBlock:(AddRechargeBlock)block
{
    if (!_addRechargeOrderRequest)
    {
        _addRechargeOrderRequest = [[HYAddRechargeOrderRequest alloc]init];
    }
    [_addRechargeOrderRequest cancel];
    
    HYPhoneChargeModel *paramModel = nil;
    if ([param isKindOfClass:[HYPhoneChargeModel class]])
    {
        paramModel = param;
    }
    if (paramModel)
    {
        _addRechargeOrderRequest.productCode = paramModel.productCode;
        _addRechargeOrderRequest.rechargeAmount = paramModel.parvalue;
        _addRechargeOrderRequest.orderAmount = paramModel.price;
        _addRechargeOrderRequest.rechargeType = [NSString stringWithFormat:@"%lu",(unsigned long)type];
        _addRechargeOrderRequest.rechargeTelephone = self.phoneNum;
    }
    
    [_addRechargeOrderRequest sendReuqest:^(HYAddRechargeOrderResponse *result, NSError *error) {
        if (result.order)
        {
            if (block)
            {
                block(result.order);
            }
        }
        else
        {
            [METoast toastWithMessage:result.suggestMsg];
        }
    }];
}

@end
