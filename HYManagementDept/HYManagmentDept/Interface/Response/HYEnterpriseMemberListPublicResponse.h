//
//  HYEnterpriseMemberListPublicResponse.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseResponse.h"

/**
 *  获取企业会员返回
 */
@interface HYEnterpriseMemberListPublicResponse : HYBaseResponse

@property (nonatomic, strong) NSArray *memberList;

@end


@interface HYEtMemberForPb : NSObject
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *real_name;

- (instancetype)initWithData:(NSDictionary *)data;
@end