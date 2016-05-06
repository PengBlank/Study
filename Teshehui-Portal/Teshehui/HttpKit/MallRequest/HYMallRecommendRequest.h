//
//  HYMallRecommendRequest.h
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 *  力荐商品换一批
 */
#import "CQBaseRequest.h"
#import "HYMallRecommendResponse.h"

@interface HYMallRecommendRequest : CQBaseRequest

@property (nonatomic, copy) NSString *boardCode;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;

@end


/*
 boardCode
 pageNo
 单页显示记录,可选参数，不传取版块默认展示数量（pageSize）
*/