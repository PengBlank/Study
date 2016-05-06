//
//  HYCardActiveRequest.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-31.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseRequestParam.h"
#import "HYCardActiveResponse.h"

@interface HYCardActiveRequest : HYBaseRequestParam

@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *phone_mob;

@end
