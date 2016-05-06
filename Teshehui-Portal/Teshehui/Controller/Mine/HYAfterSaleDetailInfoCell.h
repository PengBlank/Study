//
//  HYAfterSaleDetailInfoCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallAfterSaleInfo.h"

/**
 *  售后服务, 订单基础信息cell
 *  动态高度, 根据最后一行的高度改变
 */
@interface HYAfterSaleDetailInfoCell : HYBaseLineCell

@property (nonatomic, strong) HYMallAfterSaleInfo *saleInfo;

@end
