//
//  HYCardActiveResponse.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-31.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseResponse.h"
#import "HYCardActiveInfo.h"

@interface HYCardActiveResponse : HYBaseResponse

@property (nonatomic, strong) HYCardActiveInfo *activeInfo;

@end
