//
//  HYApplyAfterSaleListCell.h
//  Teshehui
//
//  Created by Kris on 15/10/13.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallOrderItem.h"
#import "HYMallChildOrder.h"

@protocol HYApplyAfterSaleListCellDelegate <NSObject>

@optional
- (void)didRequestReturnGoods:(HYMallOrderItem *)returnOrder withOrderCode:(NSString *)orderCode;

@end

@interface HYApplyAfterSaleListCell : HYBaseLineCell

@property (nonatomic, weak) id<HYApplyAfterSaleListCellDelegate> delegate;
@property (nonatomic, strong) HYMallOrderItem *returnOrder;
@property (nonatomic, strong) HYMallChildOrder *goodsInfo;

@end
