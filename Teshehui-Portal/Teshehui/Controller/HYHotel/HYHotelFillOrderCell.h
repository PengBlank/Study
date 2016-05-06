//
//  HYHotelOrderCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYHotelFillUserInfoCell.h"

@interface HYHotelFillOrderCell : HYBaseLineCell<UITextFieldDelegate>
{
    UITextField *_tempFeild;
}

@property (nonatomic, weak) id<HYHotelFillUserInfoCellDelegate> delegate;
@property (nonatomic, assign) NSInteger roomCount;
@property (nonatomic, readonly) NSString *fillInfo;
@property (nonatomic, strong) NSArray *guests;

- (void)fieldResignFirstResponder;
@end
