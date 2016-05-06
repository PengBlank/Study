//
//  HYBuyCarView.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYBuyCarViewDelegate;

@interface HYShoppingCarView : UIView
{
    UILabel *_quantityLab;
}

@property (nonatomic, weak) id<HYBuyCarViewDelegate> delegate;
@property (nonatomic, assign) NSInteger quantity;

+ (HYShoppingCarView *)sharedView;
+ (void)showWithDelegate:(id<HYBuyCarViewDelegate>)delegate;
+ (void)dismiss;

@end


@protocol HYBuyCarViewDelegate <NSObject>

@optional
- (void)didCheckBuyCarList;

@end