//
//  HYAddVIPCardRequestParma.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

/**
 * 批量添加会员卡
 */

#import "HYBaseRequestParam.h"
#import "HYAddVIPCardReponse.h"

@interface HYAddVIPCardRequestParma : HYBaseRequestParam
//必须字段
@property (nonatomic, copy) NSString *start_number;  //批量添加会员卡开始卡号
@property (nonatomic, copy) NSString *end_number;  //批量添加会员卡结束卡号
@property (nonatomic, copy) NSString *agency_id;  //代理商ID

//可选字段
@end
