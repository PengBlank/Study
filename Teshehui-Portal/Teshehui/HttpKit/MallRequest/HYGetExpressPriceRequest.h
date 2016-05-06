//
//  HYGetExpressPrice.h
//  Teshehui
//
//  Created by HYZB on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYGetExpressPriceResponse.h"

@interface HYGetExpressPriceRequest : CQBaseRequest

@property (nonatomic, copy) NSString *address_id;  //收货地址id
@property (nonatomic, copy) NSString *store_id;  //店铺ID，多个店铺用","隔开
@property (nonatomic, copy) NSString *shipping_id;  //配送快递ID
@property (nonatomic, copy) NSString *goods_id;  //商品ID，多个商品用","隔开

@end
