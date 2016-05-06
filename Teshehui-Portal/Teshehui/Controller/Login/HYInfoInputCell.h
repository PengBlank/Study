//
//  HYInfoInputCell.h
//  Teshehui
//
//  Created by 成才 向 on 16/2/19.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"

@interface HYInfoInputCell : HYBaseLineCell

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) UITextField *valueField;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, copy) void (^didGetValue)(NSString *value);

/// 点击return按钮
@property (nonatomic, copy) void (^didReturn)(void);

@property (nonatomic, assign) BOOL showName;    //default no

@end
