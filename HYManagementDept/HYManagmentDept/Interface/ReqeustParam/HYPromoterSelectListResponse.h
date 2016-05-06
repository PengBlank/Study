//
//  HYPromoterSelectListResponse.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseResponse.h"

@interface HYPromoterSelectInfo : NSObject
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *real_name;
- (instancetype)initWithData:(NSDictionary *)data;
@end

@interface HYPromoterSelectListResponse : HYBaseResponse

@property (nonatomic, strong) NSArray *promoterList;

@end
