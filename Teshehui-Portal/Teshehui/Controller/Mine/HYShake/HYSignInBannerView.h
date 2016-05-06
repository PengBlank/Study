//
//  HYSignInBannerView.h
//  Teshehui
//
//  Created by HYZB on 16/3/25.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//


#import <UIKit/UIKit.h>

/**
 * 摇一摇签到头部视图
 */
@interface HYSignInBannerView : UIView

/** 当前连续签到次数 */
@property (nonatomic, copy) NSString *currentSignNum;

@end