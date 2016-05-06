//
//  HYCIOrderListCell.h
//  Teshehui
//
//  Created by HYZB on 15/7/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYCIOrderDetail.h"

@protocol HYCIOrderListCellDelegate <NSObject>

@optional
- (void)didPaymentCIOrder:(HYCIOrderDetail *)order;

@end

@interface HYCIOrderListCell : HYBaseLineCell

@property (nonatomic, weak) id<HYCIOrderListCellDelegate> delegate;
@property (nonatomic, strong) HYCIOrderDetail *order;

@end
