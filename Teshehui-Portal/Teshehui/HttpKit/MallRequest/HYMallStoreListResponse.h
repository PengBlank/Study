//
//  HYMallStoreListResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYMallHomeItem.h"

@interface HYMallStoreListResponse : CQBaseResponse

@property (nonatomic, strong, readonly) NSArray *storeList;

@end
