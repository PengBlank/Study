//
//  HYMeiWeiQiQiOrderListRequest.h
//  Teshehui
//
//  Created by HYZB on 15/12/26.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYMeiWeiQiQiOrderListRequest : CQBaseRequest

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;

/*
 "orderCode":"订单编号",
 "userId":"用户编号，登录后传值",
 "type":"类别 0：全部订单；1：未完成；2：已完成；3:已取消"
 "pageNo":"商品列表页码"，
 "pageSize":"商品列表单页显示记录数"
 */

@end
