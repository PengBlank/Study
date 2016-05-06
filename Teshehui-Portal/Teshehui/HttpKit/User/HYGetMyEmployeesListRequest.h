//
//  HYGetMyEmployeesList.h
//  Teshehui
//
//  Created by HYZB on 14-7-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYGetMyEmployeesListResponse.h"

@interface HYGetMyEmployeesListRequest : CQBaseRequest

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *user_id;

@end
