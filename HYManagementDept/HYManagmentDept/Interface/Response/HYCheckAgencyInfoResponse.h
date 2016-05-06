//
//  HYCheckAgencyInfoResponse.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseResponse.h"

@interface HYCheckAgencyInfoResponse : HYBaseResponse

@property (nonatomic, readonly, copy) NSString *agencyID;  //代理商ID
@property (nonatomic, readonly, copy) NSString *real_name;  //会员真实姓名
@property (nonatomic, readonly, copy) NSString *phone_mob;  //会员电话
@property (nonatomic, readonly, copy) NSString *id_card;  //会员身份证
@property (nonatomic, readonly, copy) NSString *name;  //所属代理商名

@end

