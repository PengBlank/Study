//
//  HYMallAfterSaleDetailResponse.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYMallAfterSaleInfo.h"

@interface HYMallAfterSaleDetailResponse : CQBaseResponse

@property (nonatomic, strong) HYMallAfterSaleInfo *afterSaleInfo;

@end
