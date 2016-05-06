//
//  HYGetGoodsCommentReq.h
//  Teshehui
//
//  Created by HYZB on 15/10/19.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYGetGoodsCommentReq : CQBaseRequest

@property (nonatomic, copy) NSString *orderCode; // 订单编号
@property (nonatomic, copy) NSString *productSkuCode; // 商品SKU编码
@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;

@end
