//
//  HYGetMyEmployeesListResponse.h
//  Teshehui
//
//  Created by HYZB on 14-7-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYEmployee.h"

@interface HYGetMyEmployeesListResponse : CQBaseResponse

@property (nonatomic, strong) NSArray *employees;

@end
