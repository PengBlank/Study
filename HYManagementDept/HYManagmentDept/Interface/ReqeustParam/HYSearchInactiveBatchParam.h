//
//  HYSearchInactiveBatchParam.h
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

//搜索中心下会员卡未激活未关联推广员的会员卡

#import "HYBaseRequestParam.h"
#import "HYSearchInactiveBatchResponse.h"

@interface HYSearchInactiveBatchParam : HYBaseRequestParam

@property (nonatomic, copy) NSString *start_number; //起始卡号
@property (nonatomic, copy) NSString *end_number;  //结束卡号
@property (nonatomic, assign) NSInteger type;

@end
