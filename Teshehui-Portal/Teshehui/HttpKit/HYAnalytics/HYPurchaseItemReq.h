//
//  HYPurchaseItemReq.h
//  Teshehui
//
//  Created by HYZB on 15/11/25.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//
#import "JSONModel.h"
#import "HYAnalyticsBaseReq.h"


/*
 订单详情，格式如下
 [{
 item_code,商品编码
 category_code,分类编码(三级分类)
 brand_code,品牌编码
 sku_code,SKU标识
 color,颜色
 size,尺码
 quantity,数量
 tsh_price,销售价
 disc_price优惠价
 }]
 */
@interface HYOrderItem : JSONModel

@property (nonatomic, copy) NSString *item_code;
@property (nonatomic, copy) NSString *category_code;
@property (nonatomic, copy) NSString *brand_code;
@property (nonatomic, copy) NSString *sku_code;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, copy) NSString *tsh_price;
@property (nonatomic, copy) NSString *disc_price;

@end

@interface HYPurchaseItemReq : HYAnalyticsBaseReq

@property (nonatomic, strong) NSArray<HYOrderItem *> *order_detail;
@property (nonatomic, copy) NSString *oc;
@property (nonatomic, copy) NSString *stg_id;

@end
