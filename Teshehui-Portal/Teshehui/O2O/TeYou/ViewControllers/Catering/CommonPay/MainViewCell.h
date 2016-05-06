//
//  MainViewCell.h
//  Orange
//
//  Created by wujianming on 15/11/23.
//  Copyright © 2015年 teshehui. All rights reserved.
//  扫码主页折扣列表

#import <UIKit/UIKit.h>

typedef void (^DiscountBtnBlock)(UIButton *selectedBtn);

@interface MainViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *btn;

/** 点击折扣按钮事件回调*/
@property (nonatomic, copy) DiscountBtnBlock discountCallBack;

@end
