//
//  HYMallOrderReturnListResponse.h
//  Teshehui
//
//  Created by HYZB on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYMallAfterSaleInfo.h"

@interface HYMallOrderReturnListResponse : CQBaseResponse

@property (nonatomic, strong) NSArray<HYMallAfterSaleInfo*> *returnList;

@end
