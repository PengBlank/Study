//
//  HYOrderListHeaderView.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-29.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseHeaderView.h"
#import "HYUserInfo.h"

@interface HYOrderListHeaderView : HYBaseHeaderView

@property (nonatomic, strong) UITextField *orderSnField;
@property (nonatomic, strong) UITextField *premoterField;
@property (nonatomic, strong) UITextField *fromDateField;
@property (nonatomic, strong) UITextField *toDateField;

- (id)initWithFrame:(CGRect)frame organType:(OrganType)organType;

- (void)clear;

@property (nonatomic, assign) OrganType organType;

@end
