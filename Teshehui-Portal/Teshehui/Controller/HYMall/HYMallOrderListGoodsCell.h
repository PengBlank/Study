//
//  HYMallOrderListGoodsCell.h
//  Teshehui
//
//  Created by HYZB on 14-9-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallOrderItem.h"
#import "HYMallChildOrder.h"
@class HYUserInfo;
@class HYMallOrderSummary;
@protocol HYMallOrderListGoodsCellDelegate <NSObject>

@optional
- (void)didHandleIndemnity:(HYMallOrderItem *)goods inOrder:(HYMallOrderSummary *)order;
- (void)didRequestReturnGoods:(HYMallOrderItem *)goods inOrder:(HYMallOrderSummary *)order;
@end

@interface HYMallOrderListGoodsCell : HYBaseLineCell

@property (nonatomic, weak) id<HYMallOrderListGoodsCellDelegate> delegate;

@property (nonatomic, assign) BOOL showReturnGoods;
@property (nonatomic, strong) HYMallOrderItem *goodsInfo;
@property (nonatomic, strong) HYMallChildOrder *childOrderInfo;
@property (nonatomic, strong) HYMallOrderSummary *order;

//加入用户数据以确定是否可以进行贵就赔服务
@property (nonatomic, strong) HYUserInfo *userinfo;

@end
