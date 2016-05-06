//
//  HYInactiveSingleMigrateResponse.h
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseResponse.h"

@interface HYInactiveSingleMigrateResponse : HYBaseResponse



@end


/*
 data	OBJECT	10003:缺少参数
 10007：会员卡号需12位
 10009：结束卡号不能小于等于起始卡号
 返回批量添加成功的总数，返回0则没有批量
 */