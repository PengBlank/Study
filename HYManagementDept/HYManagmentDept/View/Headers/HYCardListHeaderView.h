//
//  HYCardListHeaderView.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-29.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseHeaderView.h"
#import "HYUserInfo.h"

@interface HYCardListHeaderView : HYBaseHeaderView

- (id)initWithFrame:(CGRect)frame organType:(OrganType)organType;

@property (nonatomic, strong) UITextField *cardNumField;
@property (nonatomic, strong) UITextField *premoterField;
@property (nonatomic, strong) UITextField *fromDateField;
@property (nonatomic, strong) UITextField *toDateField;
@property (nonatomic, strong) UIButton *statBtn;

@property (nonatomic, assign) OrganType organType;

- (void)clear;

@end
