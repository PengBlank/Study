//
//  HYOutOrderListRequest.h
//  HYManagmentDept
//
//  Created by Ray on 14-12-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseRequestParam.h"
#import "HYOutOrderListResponse.h"

@interface HYOutOrderListRequest : HYBaseRequestParam

@property (nonatomic, strong) NSString *order_no;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger num_per_page;

@end
