//
//  HYXibViewActionProtocol.h
//  Teshehui
//
//  Created by Kris on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#ifndef HYXibViewActionProtocol_h
#define HYXibViewActionProtocol_h

@class HYXibView;
//seperate the action from 继承 and 组合
@protocol HYXibViewAction <NSObject>

@optional
//- (void)showOfView:(HYXibView *)view;
//- (void)tapAction:(UITapGestureRecognizer *)tap ofView:(HYXibView *)view;
- (void)performShow;
- (void)performShowAboveView:(UIView *)view;
- (void)performTapAction;
//no time for changing it,i will do it later
- (void)bindDataWithViewModel:(id)model;

@end

#endif /* HYXibViewActionProtocol_h */
