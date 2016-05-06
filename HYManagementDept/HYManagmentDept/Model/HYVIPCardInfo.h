//
//  HYVIPCardInfo.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

/**
 * 会员卡的基本信息
 */
#import <Foundation/Foundation.h>

@interface HYVIPCardInfo : NSObject

@property (nonatomic, copy) NSString *number;   //会员卡号
@property (nonatomic, copy) NSString *agency_name;  //代理运营中心名称
@property (nonatomic, copy) NSString *status;   //状态
@property (nonatomic, copy) NSString *active_time;  //激活时间
@property (nonatomic, strong) NSString *enterprise_name;
@property (nonatomic, strong) NSString *promoters_name;

- (id)initWithData:(NSDictionary *)data;

@end
