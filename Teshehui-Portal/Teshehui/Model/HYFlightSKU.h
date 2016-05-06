//
//  HYFlightSKU.h
//  Teshehui
//
//  Created by HYZB on 15/5/29.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYProductSKU.h"
#import "HYCabins.h"

@protocol HYFlightSKU<HYProductSKU>@end

@interface HYFlightSKU : HYProductSKU

@property (nonatomic, strong) HYCabins *expandedResponse;

@end
