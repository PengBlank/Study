//
//  HYShakeGoodsItem.h
//  Teshehui
//
//  Created by HYZB on 16/3/26.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYShakeViewModel;
@class HYShakeProductPOModel;
/**
 * 摇一摇商品
 */
@interface HYShakeGoodsItem : UIView

@property (nonatomic, strong) HYShakeViewModel *shakeModel;
@property (nonatomic, strong) HYShakeProductPOModel *productModel;
@property (nonatomic, strong) UIButton *detailBtn;

@end
