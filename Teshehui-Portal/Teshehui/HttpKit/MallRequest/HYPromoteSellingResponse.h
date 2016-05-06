//
//  HYPromoteSellingResponse.h
//  Teshehui
//
//  Created by Kris on 15/9/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYProductSpareAmount.h"

@interface HYPromoteSellingResponse : CQBaseResponse

@property (nonatomic, strong) HYProductSpareAmount *spareAmount;

@end
