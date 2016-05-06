//
//  HYEtApproveRequest.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseRequestParam.h"

@interface HYEtApproveRequest : HYBaseRequestParam
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *desc;
@end

@interface HYEtApproveResponse : HYBaseResponse

@end
