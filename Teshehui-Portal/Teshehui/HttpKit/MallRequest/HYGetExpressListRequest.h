//
//  HYGetExpressListRequest.h
//  Teshehui
//
//  Created by HYZB on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 *  获取支持的物流列表
 */
#import "CQBaseRequest.h"
#import "HYGetExpressListResponse.h"

@interface HYGetExpressListRequest : CQBaseRequest

@property (nonatomic, assign) BOOL getAllExpressList;  //如果查询所有得物流公司列表，则不需要传递任何参数.默认为NO

@property (nonatomic, copy) NSString *address;  //收货地址id
@property (nonatomic, copy) NSString *storeId;  //店铺id
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *storeProductAmount;
@property (nonatomic, strong) NSArray *productSKUQuantity;

@end
