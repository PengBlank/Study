//
//  HYShakeContentView.h
//  Teshehui
//
//  Created by HYZB on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYShakeViewModel;
@class HYShakeCashItem;
@class HYShakeActivityItem;
@class HYShakeGoodsItem;
@class HYShakeProductPOModel;


@protocol HYShakeContentViewDelegate <NSObject>

/** 签到页面 */
- (void)goSignInView;

/** 现金劵页面 */
- (void)goTokenView;

/** 账户余额页面 */
- (void)goBalanceView;

/** 分享页面 */
- (void)goShowView;

/** 商品详情页面 */
- (void)goDetailView;

/** 活动页面 */
- (void)goActivityView;

@end
/**
 * 摇一摇弹窗界面
 */
@interface HYShakeContentView : UIView

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, weak) id <HYShakeContentViewDelegate>delegate;

@property (nonatomic, strong) HYShakeViewModel *shakeModel;
@property (nonatomic, strong) HYShakeProductPOModel *productModel;

@property (nonatomic, strong) HYShakeCashItem *cashItem;
@property (nonatomic, strong) HYShakeActivityItem *actItem;
@property (nonatomic, strong) HYShakeGoodsItem *goodsItem;

@end
