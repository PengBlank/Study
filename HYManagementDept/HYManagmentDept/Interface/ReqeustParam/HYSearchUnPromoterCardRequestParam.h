//
//  HYSearchUnPromoterCardRequestParam.h
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

//添加操作员的时候搜索中心下面的不是操作员的会员卡号

#import "HYBaseRequestParam.h"
#import "HYSearchUnPromoterCardResponse.h"

@interface HYSearchUnPromoterCardRequestParam : HYBaseRequestParam

@property (nonatomic, copy) NSString *number;  // 会员卡号

@end
