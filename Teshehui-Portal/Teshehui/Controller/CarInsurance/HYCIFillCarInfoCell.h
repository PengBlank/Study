//
//  HYCIFillCarInfoCell.h
//  Teshehui
//
//  Created by HYZB on 15/7/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYCICarInfoFillType.h"

@protocol HYCIFillCarInfoCellDelegate;

@interface HYCIFillCarInfoCell : HYBaseLineCell

@property (nonatomic, strong) HYCICarInfoFillType *infoType;
@property (nonatomic, strong, readonly) UITextField *inputTF;
@property (nonatomic, strong, readonly) UILabel *descLab;
@property (nonatomic, strong, readonly) UIButton *checkBtn;
@property (nonatomic, weak) id<HYCIFillCarInfoCellDelegate> delegate;

@end

@protocol HYCIFillCarInfoCellDelegate <NSObject>

@optional
- (void)didTextInputFinished:(HYCIFillCarInfoCell *)cell;
- (void)didTextInputNext:(NSInteger)nextIndex;
- (void)didEidtCheckStatus:(BOOL)checked;

@end
