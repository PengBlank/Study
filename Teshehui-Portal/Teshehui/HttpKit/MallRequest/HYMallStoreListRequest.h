//
//  HYMallStoreListRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 *商城的所有商家接口
 */

#import "CQBaseRequest.h"
#import "HYMallStoreListResponse.h"

@interface HYMallStoreListRequest : CQBaseRequest

@property (nonatomic, copy) NSString *boardCode;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;

@end


/*
 
 boardCode
 pageNo
 单页显示记录,可选参数，不传取版块默认展示数量（pageSize）
*/