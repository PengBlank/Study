//
//  HYEnterpriseMemberApply.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HYEtAppStart,
    HYEtAppCenApproved,
    HYEtAppCenRefused,
    HYEtAppComApproved,
    HYEtAppComRefused,
    HYEtAppFinApproved,
    HYEtAppFinRefused
} HYEtAppStatus;

@interface HYEnterpriseMemberApply : NSObject

@property (nonatomic, strong) NSString *m_id;
@property (nonatomic, strong) NSString *enterprise_id;
@property (nonatomic, assign) HYEtAppStatus status;
@property (nonatomic, strong) NSString *status_txt;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *created;
@property (nonatomic, strong) NSString *agency_approve_time;
@property (nonatomic, strong) NSString *agency_approve_desc;
@property (nonatomic, strong) NSString *company_approve_time;
@property (nonatomic, strong) NSString *company_approve_desc;
@property (nonatomic, strong) NSString *finance_approve_time;
@property (nonatomic, strong) NSString *finance_approve_desc;
@property (nonatomic, assign) long long total_member;
@property (nonatomic, strong) NSString *enterprise_name;

- (id)initWithData:(NSDictionary *)data;

- (HYEtAppStatus)appStatus;
@end
