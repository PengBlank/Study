//
//  HYPromoters.h
//  HYManagmentDept
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

//推广员
#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, HYPromoterReviewStatus) {
    HYPromoterWaitReview    =0,
    HYPromoterAccept        =1,
    HYPromoterReject        =2,
    HYPromoterUnknownStatus =-1
};

@interface HYPromoters : NSObject

@property (nonatomic, strong) NSString *m_id;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *created;
@property (nonatomic, strong) NSString *real_name;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *phone_mob;
@property (nonatomic, strong) NSString *proportion;
@property (nonatomic, strong) NSString *agency_id;
@property (nonatomic, strong) NSString *company_id;
@property (nonatomic, strong) NSString *display;
@property (nonatomic, strong) NSString *user_id;

@property (nonatomic, strong) NSString *nickname;   //别名
@property (nonatomic, assign) NSInteger promoters_type; //操作员类型
@property (nonatomic, assign) HYPromoterReviewStatus audit_status;   //审核状态
@property (nonatomic, strong) NSString *rejection_reason;

@property (nonatomic, strong) NSArray *imgURLs;


- (id)initWithData:(NSDictionary *)data;

@end

/*
 code	INT	邀请码
 status	INT	邀请码状态 1：有效
 created	INT	申请时间
 real_name	STRING	操作员姓名
 number	INT	操作员卡号
 phone_mob	INT	操作员电话
 proportion	FLOAT	操作员分成比例
*/