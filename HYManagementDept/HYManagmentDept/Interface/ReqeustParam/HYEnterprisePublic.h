//
//  HYEnterprisePublic.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseRequestParam.h"

@interface HYEnterprisePublicSingleRequest : HYBaseRequestParam
@property (nonatomic, strong) NSString *number; //会员卡号
@property (nonatomic, strong) NSString *user_id;  //代理商id
@end

@interface HYEnterprisePublicResponse : HYBaseResponse
@property (nonatomic, strong) NSString *number;
@property (nonatomic, assign) NSInteger count;
@end

@interface HYEnterprisePublicRequest : HYBaseRequestParam
//必须字段
@property (nonatomic, copy) NSString *start_number;  //批量添加会员卡开始卡号
@property (nonatomic, copy) NSString *end_number;  //批量添加会员卡结束卡号
@property (nonatomic, copy) NSString *user_id;  //代理商ID
@end

