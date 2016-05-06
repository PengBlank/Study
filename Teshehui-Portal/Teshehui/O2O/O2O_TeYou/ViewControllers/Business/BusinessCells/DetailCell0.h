//
//  DetailCell0.h
//  Teshehui
//
//  Created by apple_administrator on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "BaseCell.h"
#import "DLStarRatingControl.h"
#import "BusinessdetailInfo.h"

@protocol DetailCell0Delegate <NSObject>

- (void)ClickPhoneCallback;

@end
@interface DetailCell0 : BaseCell

@property (nonatomic,strong) UILabel                    *titleLabel;
@property (nonatomic,strong) UILabel                    *addressLabel;
@property (nonatomic,strong) UIView                    *lineView;
@property (nonatomic,strong) UIButton                   *phoneBtn;
@property (nonatomic,strong) UIImageView                *addressIcon;
@property (nonatomic,assign) id <DetailCell0Delegate> delegate;

-  (void)bindDataWithDetailSection0:(BusinessdetailInfo *)info;
@end
