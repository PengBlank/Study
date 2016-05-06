//
//  HYInfoValidateCell.h
//  Teshehui
//
//  Created by 成才 向 on 16/2/19.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"

@interface HYInfoValidateCell : HYBaseLineCell

@property (nonatomic, strong) NSString *mob;

@property (nonatomic, copy) void (^startValidate)(NSString *mob);

- (void)startCounting;

/// 编辑内容改这对
@property (nonatomic, copy) void (^didGetValue)(NSString *value);

/// 点击return按钮
@property (nonatomic, copy) void (^didReturn)(void);

@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, assign) BOOL showName;
@property (nonatomic, assign) BOOL canEditPhone;

@end
