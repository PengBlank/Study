//
//  HYInactiveBatchMigrateParam.h
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//


//批量中心下会员卡未激活未关联推广员的会员卡转移

#import "HYBaseRequestParam.h"
#import "HYInactiveBatchMigrateResponse.h"

@interface HYInactiveBatchMigrateParam : HYBaseRequestParam

@property (nonatomic, copy) NSString *start; //会员起始卡号
@property (nonatomic, copy) NSString *user_id;  //操作员会员ID
@property (nonatomic, copy) NSString *end;  //会员结束卡号

@end

/*
 start	INT	会员起始卡号
 user_id	INT	操作员会员ID
 end	INT	会员结束卡号
 */
