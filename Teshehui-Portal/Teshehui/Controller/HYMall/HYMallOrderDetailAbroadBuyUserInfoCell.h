//
//  HYMallOrderListAbroadBuyUserInfoCell.h
//  Teshehui
//
//  Created by HYZB on 16/4/20.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
@class HYMallChildOrder;

@interface HYMallOrderDetailAbroadBuyUserInfoCell : HYBaseLineCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setUserInfoWithOrderInfo:(HYMallChildOrder *)orderInfo;

@end
