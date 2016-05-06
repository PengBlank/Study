//
//  HYPremoterListHeaderView.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseHeaderView.h"

@interface HYPremoterListHeaderView : HYBaseHeaderView

@property (nonatomic, strong) UITextField *fromDateField;
@property (nonatomic, strong) UITextField *toDateField;
@property (nonatomic, strong) UITextField *promoterField;

@property (nonatomic, strong) UITextField *inviCodeField;

- (void)clear;

@end
