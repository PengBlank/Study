//
//  HYProductDetailToolView.h
//  Teshehui
//
//  Created by HYZB on 15/8/17.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYProductDetailToolViewDelegate <NSObject>

@optional
- (void)addToShoppingCar;
- (void)collectProduct;
- (void)checkMoreProductWithStore;
- (void)buyNow;
- (void)setupHuanXin;

@end

@interface HYProductDetailToolView : UIView

@property (nonatomic, weak) id<HYProductDetailToolViewDelegate> delegate;
@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, assign) BOOL isCanBuy;

@property (nonatomic, readonly) UIButton *addBtn;

@end
