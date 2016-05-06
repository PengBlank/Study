//
//  HYMallApplaudRequest.h
//  Teshehui
//
//  Created by HYZB on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


/**
 *  点赞
 */
#import "CQBaseRequest.h"
#import "HYMallApplaudResponse.h"

@interface HYMallApplaudRequest : CQBaseRequest

@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *productName;

@end
