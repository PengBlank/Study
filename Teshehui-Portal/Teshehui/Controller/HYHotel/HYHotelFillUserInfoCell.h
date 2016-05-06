//
//  HYHotelFillUserInfoCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"

@protocol HYHotelFillUserInfoCellDelegate;
@interface HYHotelFillUserInfoCell : HYBaseLineCell<UITextFieldDelegate>

@property (nonatomic, weak) id<HYHotelFillUserInfoCellDelegate> delegate;

@property (nonatomic, readonly, strong) UITextField *nameField;
@property (nonatomic, readonly, strong) UITextField *phoneField;

- (void)fieldResignFirstResponder;
- (void)configFields;
@end

@protocol HYHotelFillUserInfoCellDelegate <NSObject>

@optional
- (void)displayAllContacts;
- (void)cellBecomeFirstResponder:(UITableViewCell *)cell;
- (void)didSelectHotelPassenger;
- (void)didNameInputComplete:(UITableViewCell *)cell;
@end