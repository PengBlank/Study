//
//  HYLuckyPrizeView.h
//  Teshehui
//
//  Created by HYZB on 15/3/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYLuckyPrize.h"

@interface HYLuckyPrizeView : UIView
{
    UIImageView *_prizeView;
    UIImageView *_levelView;
    UILabel *_nameLab;
    UILabel *_priceLab;
}

@property (nonatomic, strong) HYLuckyPrize *prize;

@end
