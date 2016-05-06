//
//  HYVipListHeaderView.h
//  HYManagmentDept
//
//  Created by apple on 15/4/24.
//  Copyright (c) 2015年 回亿资本. All rights reserved.
//

#import "HYBaseHeaderView.h"
#import "HYUserInfo.h"

@interface HYVipListHeaderView : HYBaseHeaderView

@property (nonatomic, strong) UITextField *orderSnField;
@property (nonatomic, strong) UITextField *premoterField;
@property (nonatomic, strong) UITextField *fromDateField;
@property (nonatomic, strong) UITextField *toDateField;

- (id)initWithFrame:(CGRect)frame organType:(OrganType)organType;
@property (nonatomic, assign) OrganType organType;
@end
