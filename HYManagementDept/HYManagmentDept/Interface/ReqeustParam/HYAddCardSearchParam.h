//
//  HYAddCardSearchParam.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-29.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseRequestParam.h"
#import "HYAddCardSearchResponse.h"

@interface HYAddCardSearchParam : HYBaseRequestParam

@property (nonatomic, strong) NSString *number;

@property (nonatomic, strong) NSString *end_number;

@end
