//
//  HYInfoInputButtonCell.h
//  Teshehui
//
//  Created by 成才 向 on 16/2/22.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
#import "HYInfoInputCell.h"

@interface HYInfoInputButtonCell : HYInfoInputCell

@property (nonatomic, strong, readonly) UIButton *additionBtn;
@property (nonatomic, copy) void (^didClickButton)(void);

@end
