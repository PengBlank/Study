//
//  SceneOrderListRequest.h
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/9.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  场景订单列表请求

#import "CQBaseRequest.h"

@interface SceneOrderListRequest : CQBaseRequest

/** 用户名 */
@property (nonatomic, copy) NSString *UId;

/** 类型（0全部、1可使用、2未付款、3无效订单 */
@property (assign)          NSInteger  type;
/**页数*/
@property (assign)          NSInteger pageIndex;
/**每页大小*/
@property (assign)          NSInteger pageSize;

@end
