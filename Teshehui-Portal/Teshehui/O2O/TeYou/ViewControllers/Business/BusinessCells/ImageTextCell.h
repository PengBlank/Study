//
//  ImageTextCell.h
//  Teshehui
//
//  Created by apple_administrator on 15/8/28.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "BaseCell.h"
#import "BusinessdetailInfo.h"

@protocol BusinessPhoneCellDelegate <NSObject>

- (void)ClickPhoneCallback;
- (void)ClickPayMoneyCallback;

@end
@interface ImageTextCell : BaseCell
{
    UIView *_linview;
}
@property (nonatomic,strong) UILabel        *contentLabel;
@property (nonatomic,strong) UIImageView    *imageV;
@property (nonatomic,strong) UIButton       *phoneBtn;
@property (nonatomic,assign) id <BusinessPhoneCellDelegate> delegate;

@property (nonatomic,copy) void (^phoneCallBack)(void);
@property (nonatomic,copy) void (^payCallBack)(void);

- (void)bindDataWithDetailSection1:(BusinessdetailInfo *)baseInfo;
- (void)bindData:(BusinessdetailInfo *)baseInfo andIndex:(NSInteger)index;
- (void)bindDataWithSectionTwo:(BusinessdetailInfo *)baseInfo andIndex:(NSInteger)index;
@end
