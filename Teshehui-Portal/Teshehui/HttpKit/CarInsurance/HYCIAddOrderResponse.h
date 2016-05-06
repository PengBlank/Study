//
//  HYCIAddOrderResponse.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYCIOrderDetail.h"

@interface HYCIAddOrderResponse : CQBaseResponse

@property (nonatomic, strong) HYCIOrderDetail *order;

@end
