//
//  HYPromotersAddRequest.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseRequestParam.h"
#import "HYPromotersAddResponse.h"

@interface HYPromotersAddRequest : HYBaseRequestParam

@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, assign) NSInteger promoters_type;

@end
