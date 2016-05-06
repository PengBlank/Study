//
//  TravelOrderListCell.h
//  Teshehui
//
//  Created by apple_administrator on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "BaseCell.h"
#import "TravelOrderInfo.h"
@interface TravelOrderListCell : BaseCell


@property (nonatomic,strong) UIImageView    *topMarkImage;
@property (nonatomic,strong) UIImageView    *logoImage;
@property (nonatomic,strong) UIImageView    *economizeImage;
@property (nonatomic,strong) UIImageView    *rightArrow;        // 右边箭头
//@property (nonatomic,strong) UIImageView    *codeImage;
//@property (nonatomic,strong) UIImageView    *downloadImage;

//@property (nonatomic,strong) UILabel        *codeLabel;       // 二维码标题
@property (nonatomic,strong) UILabel        *titleLabel;        // 标题
@property (nonatomic,strong) UILabel        *detailLabel;       // 详细
@property (nonatomic,strong) UILabel        *residueLabel;      // 剩余次数
@property (nonatomic,strong) UILabel        *economizeLabel;    // 省
@property (nonatomic,strong) UILabel        *priceLabel;        // 价格
@property (nonatomic,strong) UILabel        *payType;           // 支付类型
@property (nonatomic,strong) UILabel        *ticketType;        // 票类型
@property (nonatomic,strong) UILabel        *ticketName;        // 票名
@property (nonatomic,strong) UILabel        *myTicketName;      // 新的票名
@property (nonatomic,strong) UILabel        *availabilityLabel; // 有效期
//@property (nonatomic,strong) UILabel        *useDateLabel;      // 使用日期
@property (nonatomic,strong) UILabel        *orderNumLbale;     // 订单号－－－
@property (nonatomic,strong) UILabel        *creationTime;      // 订单创建时间－－－

@property (nonatomic,strong) UIView         *topLineView;       // 顶部的线
@property (nonatomic,strong) UIView         *midLineView;       // 中间的线
@property (nonatomic,strong) UIView         *bottomLineView;    // 底部的线

@property (nonatomic,strong) UIButton       *commentButton;     // 评论按钮

@property (nonatomic,strong) TravelOrderInfo      *orderInfo;

@property (nonatomic,copy)  void (^codeImageClickBlock)(TravelOrderInfo *oInfo);
@property (nonatomic,copy)  void (^saveQRImageClickBlock)(UIImage *image,TravelOrderInfo *oInfo);
@property (nonatomic,copy)  void (^commentButtonClickBlock)(TravelOrderInfo *orderInfo, NSInteger type, BOOL isButton);  // 评论按钮Block

- (void)bindData:(TravelOrderInfo *)baseInfo type:(NSInteger)type;;


@end
