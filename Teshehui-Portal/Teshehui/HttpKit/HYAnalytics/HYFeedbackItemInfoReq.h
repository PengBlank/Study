//
//  HYFeedbackItemInfoReq.h
//  Teshehui
//
//  Created by HYZB on 15/11/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//
#import "JSONModel.h"
#import "HYAnalyticsBaseReq.h"


/*
 item_code,商品编码
 category_code,分类编码(三级分类)
 brand_code,品牌编码
 tsh_price,销售价
 */
@interface HYFeedbackItemInfo : JSONModel

@property (nonatomic, copy) NSString *item_code;
@property (nonatomic, copy) NSString *category_code;
@property (nonatomic, copy) NSString *brand_code;
@property (nonatomic, copy) NSString *tsh_price;

@end

@interface HYFeedbackItemInfoReq : HYAnalyticsBaseReq

/*枚举类型：
 1.	收藏
 2.	加入购物车
 3.	分享商品
 4.	点赞
 */
@property (nonatomic, copy) NSString *fb_type;
@property (nonatomic, copy) NSString *stg_id;  //Wap跳转APP时的唯一标识
@property (nonatomic, strong) NSArray<HYFeedbackItemInfo *> *fb_detail;

@end
