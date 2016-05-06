//
//  HYAgencyDataInfo.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-19.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYAgencyDataInfo : NSObject

@property (nonatomic, strong) NSString *company_id;
@property (nonatomic, strong) NSString *m_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *real_name;
@property (nonatomic, strong) NSString *phone_mob;

- (id)initWithData:(NSDictionary *)data;

@end
