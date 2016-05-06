//
//  HYCommentItemReq.h
//  Teshehui
//
//  Created by HYZB on 15/11/25.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYAnalyticsBaseReq.h"

/*
 商品详情，格式如下
 [{
 item_code,商品编码
 sku_code,SKU编码
 description_score,描述相符得分
 service_score,服务态度得分
 delivery_score 发货速度得分
 }]
 */

@interface HYCommentItem : JSONModel

@property (nonatomic, copy) NSString *item_code;
@property (nonatomic, copy) NSString *sku_code;
@property (nonatomic, copy) NSString *description_score;
@property (nonatomic, copy) NSString *service_score;
@property (nonatomic, copy) NSString *delivery_score;

@end

@interface HYCommentItemReq : HYAnalyticsBaseReq

@property (nonatomic, strong) NSArray<HYCommentItem *> *ct_detail;
@property (nonatomic, copy) NSString *oc;   //当前订单编码

@end
