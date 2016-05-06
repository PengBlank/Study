//
//  HYOutOrderListResponse.h
//  HYManagmentDept
//
//  Created by Ray on 14-12-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseResponse.h"
#import "HYOutOrder.h"

@interface HYOutOrderListResponse : HYBaseResponse

@property (nonatomic, strong) NSArray *dataArray;
//@property (nonatomic, assign) NSInteger total;

@end
