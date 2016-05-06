//
//  HYMallMoreGoodsRequest.h
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYMallMoreGoodsResponse.h"

@interface HYMallMoreGoodsRequest : CQBaseRequest

@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSString *boardCode;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;

@end
