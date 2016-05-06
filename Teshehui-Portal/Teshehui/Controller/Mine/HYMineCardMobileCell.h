//
//  HYMineCardMobileCell.h
//  Teshehui
//
//  Created by HYZB on 14-10-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYTextField.h"
#import "HYTelNumberInfo.h"

@protocol HYMineCardMobileCellDelegate <NSObject>

- (void)didSelectSetTelNumberType:(HYTelNumberInfo *)telNumber;

@end

/**
 *  @brief 我的名片界面、电话cell
 */
@interface HYMineCardMobileCell : HYBaseLineCell
{
    UIButton *_setTypeBtn;
}

@property(nonatomic,strong) HYTextField* textField;
@property(nonatomic,strong) HYTelNumberInfo *telNumber;

@property (nonatomic, weak) id<UITextFieldDelegate> fieldDelegate;
@property (nonatomic, weak) id<HYMineCardMobileCellDelegate> delegate;

@end
