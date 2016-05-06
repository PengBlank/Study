//
//  HYSingleAddCardRequestParam.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-19.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseRequestParam.h"
#import "HYSingleAddCardResponse.h"

@interface HYSingleAddCardRequestParam : HYBaseRequestParam

@property (nonatomic, strong) NSString *number; //会员卡号
@property (nonatomic, strong) NSString *agency_id;  //代理商id

@end
