//
//  HYPromoteSellingRequest.h
//  Teshehui
//
//  Created by Kris on 15/9/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

typedef NS_ENUM(NSInteger, HYSettleType)
{
    HYSettleTypeProductDetail   =   1,
    HYSettleTypeCart            =   2,
    HYSettleTypeOrder           =   3
};

@interface HYPromoteSellingRequest : CQBaseRequest

@property (nonatomic, strong) NSArray *productSKUInfos;
@property (nonatomic, assign) HYSettleType settleType;

@end
