//
//  HYOnlinePurchaseRequest.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-11-4.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseRequestParam.h"
#import "HYOnlinePurchaseResponse.h"

@interface HYOnlinePurchaseRequest : HYBaseRequestParam

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *id_card_type;
@property (nonatomic, strong) NSString *id_card_num;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *phone_code;
@property (nonatomic, strong) NSString *invitation_code;

@end
