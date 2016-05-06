//
//  HYAddPromotersRequestParam.h
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

//添加推广员
#import "HYBaseRequestParam.h"
#import "HYAddPromotersResponse.h"

@interface HYAddPromotersRequestParam : HYBaseRequestParam

@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *proportion;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *tel;

@end


/*
 number	INT	会员卡号
 proportion	FLOAT	分配比例
 code	INT	邀请码
 tel	INT	电话号码
*/