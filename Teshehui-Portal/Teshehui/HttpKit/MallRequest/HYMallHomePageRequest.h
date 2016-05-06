//
//  HYMallHomePageRequest.h
//  Teshehui
//
//  Created by HYZB on 14-10-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


/*
 * 29) 新改版首页合集信息
 */
#import "CQBaseRequest.h"
#import "HYMallHomePageResponse.h"

@interface HYMallHomePageRequest : CQBaseRequest

@property (nonatomic, copy) NSString *boardCodes;  //模块的代码
@property (nonatomic, assign) BOOL whetherChange;
@property (nonatomic, copy) NSString *tags;

@end
