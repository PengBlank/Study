//
//  HYLoginV2SelectCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"

@interface HYLoginV2SelectCell : HYBaseLineCell

@property (nonatomic, strong, readonly) UIImageView *rightArrow;
@property (nonatomic, assign) BOOL selectEnable;

@property (nonatomic, strong) NSString *valuePlaceholder;

@end
