//
//  HYProductParamInfoCell.h
//  Teshehui
//
//  Created by HYZB on 14-9-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


/**
 *  产品的参数说明
 */

#import "HYBaseLineCell.h"
#import "HYMallGoodsDetail.h"

@protocol HYProductParamInfoCellDelegate <NSObject>

@optional
- (void)didSelectProductSKU:(HYProductSKU *)sku;

@end

@interface HYProductParamInfoCell : HYBaseLineCell

@property (nonatomic, weak) id<HYProductParamInfoCellDelegate> delegate;
@property (nonatomic, strong) HYMallGoodsDetail *goodDetaiInfo;

@end
