//
//  HYJptelFillCredCardCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-21.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYTextField.h"

@interface HYHotelFillCredCardCell : HYBaseLineCell<UITextFieldDelegate>

@property (nonatomic, readonly, strong) HYTextField *textField;
@property (nonatomic, readonly, strong) UIButton *infoBtn;

@end
