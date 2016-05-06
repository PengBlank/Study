//
//  HYGetRechargeGoodsResponse.h
//  Teshehui
//
//  Created by Kris on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYPhoneChargeModel.h"

@interface HYGetRechargeGoodsResponse : CQBaseResponse

@property (nonatomic, strong, readonly) NSArray *dataList;

@end
