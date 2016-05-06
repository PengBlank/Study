//
//  HYEnterpriseMember.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYEnterpriseMember : NSObject
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *real_name;
@property (nonatomic, strong) NSString *id_card;
@property (nonatomic, strong) NSString *phone_mob;
@property (nonatomic, strong) NSString *name;

- (id)initWithData:(NSDictionary *)data;
@end
