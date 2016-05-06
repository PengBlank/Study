//
//  HYAddVIPCardReponse.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseResponse.h"

@interface HYAddVIPCardReponse : HYBaseResponse

@property (nonatomic, readonly, assign) NSInteger count;  //返回批量添加成功的总数，返回0则没有批量添加成功

@end
