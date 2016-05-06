//
//  PrepaidCell.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/22.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/**
 *  商家订单 已付款cell
 *
 */

#import "BaseCell.h"
#import "OrderInfo.h"
@interface PrepaidCell : BaseCell

@property (nonatomic,strong) UIImageView    *leftImage;
@property (nonatomic,strong) UIImageView    *markImage;

@property (nonatomic,strong) UILabel        *nameLabel;
@property (nonatomic,strong) UILabel        *payStatusLabel;
@property (nonatomic,strong) UILabel        *numberLabel;
@property (nonatomic,strong) UILabel        *payType;
@property (nonatomic,strong) UILabel        *payMoney;
@property (nonatomic,strong) UILabel        *orderTime;

@property (nonatomic,strong) UIView         *topLineView;

@property (nonatomic,strong) UIView         *bottomLineView;
@property (nonatomic,strong) UIButton       *commentBtn;

@property (nonatomic,strong) OrderInfo      *orderInfo;

@property (nonatomic,copy)   void (^goCommentBlock)(OrderInfo *oInfo);

- (void)bindData:(OrderInfo *)baseInfo;
+ (CGFloat)cellHeight;

@end
