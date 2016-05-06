//
//  HYProductDefaultDeliveryRequest.h
//  Teshehui
//
//  Created by HYZB on 15/12/31.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "CQBaseResponse.h"
#import "HYMallDefaultProductDeliveryModel.h"

@interface HYProductDefaultDeliveryRequest : CQBaseRequest

@property (nonatomic, copy) NSString *userAddressId;
@property (nonatomic, strong) NSMutableArray *productStoreList;


/*
 "具体参数data":{
 "userId":"用户ID",
 "userAddressId":"用户地址ID",
 "productStoreList":"商品店铺列表" [{
 "storeId":"店铺ID",
 "productSKUList":"商品SKU列表"[{
 "productSKUCode":"商品SKU",
 "quantity":"数量"
 }]
 }]
 }
 */

@end

@interface HYProductDefaultDeliveryResponse : CQBaseResponse

@property (nonatomic, copy) NSArray *companyList;

@end
