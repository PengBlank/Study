//
//  HYRowDataRequest.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseRequestParam.h"
#import "HYRowDataResponse.h"

@interface HYRowDataRequest : HYBaseRequestParam
{
    NSInteger _num_per_page;
    NSInteger _page;
}

@property (nonatomic, assign) NSInteger num_per_page;
@property (nonatomic, assign) NSInteger page;

@end
