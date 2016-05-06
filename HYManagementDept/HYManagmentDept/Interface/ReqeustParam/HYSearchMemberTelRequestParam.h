//
//  HYSearchMemberTelRequestParam.h
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

//搜索会员的电话

#import "HYBaseRequestParam.h"
#import "HYSearchMemberTelResponse.h"

@interface HYSearchMemberTelRequestParam : HYBaseRequestParam

@property (nonatomic, copy) NSString *number;  // 会员卡号

@end
