//
//  HYOutOrderListHeaderView.h
//  HYManagmentDept
//
//  Created by Ray on 14-12-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseHeaderView.h"

@interface HYOutOrderListHeaderView : HYBaseHeaderView

@property (nonatomic, strong) UITextField *orderSnField;
@property (nonatomic, strong) UITextField *fromDateField;
@property (nonatomic, strong) UITextField *toDateField;

- (void)clear;

@end
