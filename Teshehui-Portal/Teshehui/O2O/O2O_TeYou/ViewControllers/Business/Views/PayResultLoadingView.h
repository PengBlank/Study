//
//  PayResultLoadingView.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefineConfig.h"
@interface PayResultLoadingView : UIView

@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UILabel   *desLabel;


- (instancetype)initWithFrame:(CGRect)frame payType:(O2OPayType)type;
@end
