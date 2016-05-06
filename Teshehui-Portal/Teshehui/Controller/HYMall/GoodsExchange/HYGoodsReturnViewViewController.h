//
//  HYGoodsReturnViewViewController.h
//  Teshehui
//
//  Created by RayXiang on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYMallOrderItem.h"
#import "HYMallOrderGoodsInfo.h"

typedef NS_ENUM(NSUInteger, HYGoodsReturnType)
{
    HYGoodsReturn,
    HYGoodsExchange
};


/**
 *  @brief  申请退货
 */
@interface HYGoodsReturnViewViewController : HYMallViewBaseController
<UITableViewDelegate, UITableViewDataSource>
{
    HYGoodsReturnType _retType;
}

@property (nonatomic, strong) HYMallOrderItem *orderItem;

@property (nonatomic, copy) void (^returnCallback)(BOOL success);

@property (nonatomic, strong) HYMallOrderGoodsInfo *orderGoods;
@end
