//
//  HYBaseLineHeadView.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYBaseLineHeadView : UIView
{
    UIImageView *_lineView;
}

@property (nonatomic, assign) BOOL hiddenLine;  //隐藏线， 默认NO
@property (nonatomic, assign) CGFloat separatorLeftInset;  //间距右边的距离，主要是为了适配IOS7以及以下, 默认16个px

@end
