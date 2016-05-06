//
//  HYMallCartFooterView.h
//  Teshehui
//
//  Created by RayXiang on 14-9-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallCartSecFooter.h"

@protocol HYMallCartFooterViewDelegate <NSObject>
@optional
- (void)footerViewDidClickCheckButton:(BOOL)check;
- (void)footerViewDidClickBuyButton;

@end

@interface HYMallCartFooterView : UIView

@property (nonatomic, weak) id<HYMallCartFooterViewDelegate> delegate;
@property (nonatomic, strong, readonly) UIButton *checkBtn;
@property (nonatomic, strong, readonly) UIButton *buyBtn;
@property (nonatomic, strong, readonly) HYMallCartSecFooter *footer;

@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *points;
@property (nonatomic, strong) NSString *spare;  //省多少钱


- (void)setPrice:(NSString *)price
          points:(NSString *)points
           spare:(NSString *)spare;

- (void)setCheckBtnSelected:(BOOL)status;

//点导航栏编辑后弹出的收藏夹
- (void)showNewFooter:(BOOL)status;

@end
