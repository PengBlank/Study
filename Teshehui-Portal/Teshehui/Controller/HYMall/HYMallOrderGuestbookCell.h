//
//  HYMallOrderRemarkCell.h
//  Teshehui
//
//  Created by HYZB on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


/**
 *  卖家留言
 */
#import "HYBaseLineCell.h"

@interface HYMallOrderGuestbookCell : HYBaseLineCell

@property (nonatomic, weak) id<UITextFieldDelegate> fieldDelegate;
@property (nonatomic, strong) UITextField *guestbookField;

@end
