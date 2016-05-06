//
//  HYCardActiveInfo.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-31.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYCardActiveInfo : NSObject

@property (nonatomic, strong) NSString *m_id;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *agency_id;
@property (nonatomic, strong) NSString *deadline;
@property (nonatomic, assign) NSInteger m_status;   //0未激活，1已激活
@property (nonatomic, strong) NSString *active_time;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *phone_mob;

- (instancetype)initWithData:(NSDictionary *)data;

@end
