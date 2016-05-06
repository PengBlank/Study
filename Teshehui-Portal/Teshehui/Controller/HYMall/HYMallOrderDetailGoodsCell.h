//
//  HYMallOrderDetailGoodsCell.h
//  Teshehui
//
//  Created by HYZB on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallOrderItem.h"

@protocol HYMallOrderDetailGoodsCellDelegate <NSObject>

@optional
- (void)didRequestReturnGoods:(HYMallOrderItem *)goods;
- (void)didRequestGuijiupei:(HYMallOrderItem *)goods;

@end

@interface HYMallOrderDetailGoodsCell : HYBaseLineCell

@property (nonatomic, weak) id<HYMallOrderDetailGoodsCellDelegate> delegate;
@property (nonatomic, strong) HYMallOrderItem *goodsInfo;
@property (nonatomic, assign) NSInteger isSears;

@end
