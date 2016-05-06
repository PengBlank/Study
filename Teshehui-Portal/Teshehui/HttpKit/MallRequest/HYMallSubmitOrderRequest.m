//
//  HYMallFinishOrderRequest.m
//  Teshehui
//
//  Created by HYZB on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallSubmitOrderRequest.h"
#import "HYMallSubmitOrderResponse.h"
#import "HYUserInfo.h"
#import "HYMallCartShopInfo.h"
#import "JSONKit_HY.h"
#import "NSString+Addition.h"

@implementation HYMallSubmitOrderRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/addMallOrder.action"];
        self.httpMethod = @"POST";
        self.businessType = @"01";
        self.version = @"1.0.1";
        self.userid = [HYUserInfo getUserInfo].userId;
    }
    
    return self;
}

+ (instancetype)requestWithStoreList:(NSArray *)storelist isSelectExpress:(BOOL *)isselect
{
    BOOL isselectExpress = NO;
    
    HYMallSubmitOrderRequest *request = [[HYMallSubmitOrderRequest alloc] init];
    
    NSString *totalAmount = nil;
    NSInteger totalPoints = 0;
    NSString *deliveryFee = 0;
    NSMutableArray *poList = [NSMutableArray array];
    for (HYMallCartShopInfo *store in storelist)
    {
        //是否选择物流
        isselectExpress = ([store.expressInfo.expressId length] > 0 && store.expressInfo.is_support);
        if (!isselectExpress)
        {
            *isselect = isselectExpress;
            return nil;
        }
        
        if (!totalAmount)
        {
            totalAmount = store.totalPrice;
        }
        else
        {
            totalAmount = [totalAmount stringDecimalByAdding:store.totalPrice];
        }
        
        if (!deliveryFee)
        {
            deliveryFee = store.expressInfo.price;
        }
        else
        {
            deliveryFee = [deliveryFee stringDecimalByAdding:store.expressInfo.price];
        }
        
        totalPoints += store.totalPoint;
        
        NSMutableDictionary *storinfo = [NSMutableDictionary dictionary];
        
        if (store.store_id)
        {
            [storinfo setObject:store.store_id forKey:@"storeId"];
        }
        if (store.expressInfo.expressId)
        {
            [storinfo setObject:store.expressInfo.expressId forKey:@"storeDeliveryId"];
        }
        if (store.guestbook)  //买家留言
        {
            [storinfo setObject:store.guestbook forKey:@"messageToStore"];
        }
        
        if (store.expressInfo.price)
        {
            [storinfo setObject:store.expressInfo.price
                         forKey:@"storeDeliveryFee"];
        }
        
        NSMutableArray *itemlist = [NSMutableArray array];
        [storinfo setObject:itemlist forKey:@"orderItemList"];
        for (HYMallCartProduct *goods in store.goods)
        {
            if (goods.isSelect && goods.productSKUId)
            {
                NSMutableDictionary *iteminfo = [NSMutableDictionary dictionary];
                [itemlist addObject:iteminfo];
                
                [iteminfo setObject:goods.productSKUId forKey:@"productSKUCode"];
                [iteminfo setObject:goods.quantity forKey:@"quantity"];
                [iteminfo setObject:goods.salePrice forKey:@"price"];
                [iteminfo setObject:goods.salePoints forKey:@"points"];
                
                // supplierType：01   普通类型    06    海淘类型（String）
                if ([goods.supplierType isEqualToString:@"06"])
                {
                    //  isSears=2L:""  是否是海淘商品  1是 2否  (默认为 2 )
                    [iteminfo setObject:@(1) forKey:@"isSears"];
                }
            }
        }
        
        if (itemlist.count > 0)
        {
            [poList addObject:storinfo];
        }
    }
    
    NSString *polistjson = [poList JSONString];
    request.storeOrderItemPOList = polistjson;
    request.itemTotalAmount = totalAmount;
    request.orderTotalAmount = totalAmount;
    //暂时先本地算
    request.orderPayAmount = totalAmount;
    request.orderTbAmount = totalPoints;
    request.discountAmount = 0;
    request.discountDescription = nil;
    request.isNeedInvoice = NO;
    request.invoiceType = 0;
    request.invoiceTitle = nil;
    request.deliveryFee = deliveryFee;
    
    *isselect = isselectExpress;
    
    return request;
}

/*
[
 {
     "storeId": "57",
     "storeDeliveryId": 1,
     "storeDeliveryFee": 10,
     "messageToStore": "测试订单",
     "orderItemList": [
                       {
                           "productSKUCode": "150100000002001",
                           "quantity": 1,
                           "price": 12100,
                           "points": 10
                       },
                       {
                           "productSKUCode": "150100000067001",
                           "quantity": 2,
                           "price": 9075,
                           "points": 1000
                       }
                       ]
 },
 {
     "storeId": "63",
     "storeDeliveryId": 1,
     "storeDeliveryFee": 10,
     "messageToStore": "TESTEST",
     "orderItemList": [
                       {
                           "productSKUCode": "070800000008001",
                           "quantity": 1,
                           "price": 378.4,
                           "points": 238
                       }
                       ]
 }
 ]
 */
- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        [newDic setObject:self.businessType forKey:@"businessType"];
        if (self.userid.length > 0)
        {
            [newDic setObject:_userid
                       forKey:@"userId"];
        }
        
        if (self.itemTotalAmount)
        {
            [newDic setObject:self.itemTotalAmount
                       forKey:@"itemTotalAmount"];
        }
        
        if (self.orderPayAmount)
        {
            [newDic setObject:self.orderPayAmount
                       forKey:@"orderPayAmount"];
        }
        
        [newDic setObject:@(_orderTbAmount)
                   forKey:@"orderTbAmount"];
        
        if (self.orderTotalAmount)
        {
            [newDic setObject:self.orderTotalAmount
                       forKey:@"orderTotalAmount"];
        }
        
        if (self.discountAmount)
        {
            [newDic setObject:self.discountAmount
                       forKey:@"discountAmount"];
        }

        if (self.discountDescription.length > 0)
        {
            [newDic setObject:_discountDescription
                       forKey:@"discountDescription"];
        }
        if (self.userid.length > 0)
        {
            [newDic setObject:_userid forKey:@"userId"];
        }
        if (self.invoiceTitle.length > 0)
        {
            [newDic setObject:_invoiceTitle
                       forKey:@"invoiceTitle"];
        }
        if (self.userAddressId.length > 0)
        {
            [newDic setObject:_userAddressId forKey:@"userAddressId"];
        }
        
        if (self.storeOrderItemPOList.length > 0)
        {
            [newDic setObject:_storeOrderItemPOList forKey:@"storeOrderItemPOList"];
        }
        
        if (self.idCard.length > 0)
        {
            [newDic setObject:_idCard forKey:@"idCard"];
        }
        
        if (self.realName.length > 0)
        {
            [newDic setObject:_realName forKey:@"realName"];
        }
    }
    
    return newDic;
}


- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallSubmitOrderResponse *respose = [[HYMallSubmitOrderResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
