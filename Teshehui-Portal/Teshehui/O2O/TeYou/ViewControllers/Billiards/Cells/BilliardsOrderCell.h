//
//  BilliardsOrderCell.h
//  Teshehui
//
//  Created by apple_administrator on 15/11/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "BaseCell.h"
#import "BilliardsOrderInfo.h"
@interface BilliardsOrderCell : BaseCell
{
    UIImageView *_imageV;
}
@property (nonatomic,strong) UIImageView *topMarkImage;
@property (nonatomic,strong) UIImageView *logoImage;

@property (nonatomic,strong) UILabel     *tableNo;//几号球台
@property (nonatomic,strong) UILabel     *titleLabel;//标题
@property (nonatomic,strong) UILabel     *orderNo;//订单号
@property (nonatomic,strong) UILabel     *tablePrice;//球台价格
@property (nonatomic,strong) UILabel     *startTime;//开始时间
@property (nonatomic,strong) UILabel     *tableStatus;//球台状态
@property (nonatomic,strong) UILabel     *payWay;//支付方式
@property (nonatomic,strong) UIView      *topLineView;
@property (nonatomic,strong) UIView      *bottomLineView;
@property (nonatomic,strong) UIButton    *buyButton;//购买按钮

@property (nonatomic,strong) BilliardsOrderInfo     *orderInfo;

@property (nonatomic,copy)  void (^buyBtnClickBlock)(BilliardsOrderInfo *oInfo);
@property (nonatomic,copy)  void (^payBtnClickBlock)(BilliardsOrderInfo *oInfo);
@property (nonatomic,copy)  void (^commentBtnClickBlock)(BilliardsOrderInfo *oInfo);

- (void)bindData:(BilliardsOrderInfo *)baseInfo type:(NSInteger)type;;

@end
