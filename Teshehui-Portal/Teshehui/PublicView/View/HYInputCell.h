//
//  HYInputCell.h
//  Teshehui
//
//  Created by ichina on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYTextField.h"
#import "HYBaseLineCell.h"

//@protocol HYInputCellDelegate <NSObject>
//
//- (void)setDefaultAction;
//
//@end

@interface HYInputCell : HYBaseLineCell

@property(nonatomic,strong) UILabel* nameLab;
@property(nonatomic,strong) UILabel* textLab;
@property(nonatomic,strong) HYTextField* textField;
@property (nonatomic, strong) UIButton *setDefaultBtn;
//@property (nonatomic, weak) id<HYInputCellDelegate> delegate;

@end
