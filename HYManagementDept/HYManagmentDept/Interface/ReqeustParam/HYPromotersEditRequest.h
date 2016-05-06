//
//  HYPromotersEditRequest.h
//  HYManagmentDept
//
//  Created by apple on 15/4/23.
//  Copyright (c) 2015年 回亿资本. All rights reserved.
//

#import "HYBaseRequestParam.h"
#import "HYPromotersEditResponse.h"

@interface HYPromotersEditRequest : HYBaseRequestParam

@property (nonatomic, strong) NSString *operator_id;    //操作员id
@property (nonatomic, assign) NSInteger promoters_type;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSArray *imgs;

@end
