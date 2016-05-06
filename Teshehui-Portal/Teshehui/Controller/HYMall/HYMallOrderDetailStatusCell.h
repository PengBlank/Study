//
//  HYMallOrderDetailStatusCell.h
//  Teshehui
//
//  Created by HYZB on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallChildOrder.h"

@interface HYMallOrderDetailStatusCell : HYBaseLineCell
{
    UILabel *_priceLabel;
}

@property (nonatomic, copy) NSString *priceInfo;
@property (nonatomic, strong) HYMallChildOrder *childOrder;

@end
