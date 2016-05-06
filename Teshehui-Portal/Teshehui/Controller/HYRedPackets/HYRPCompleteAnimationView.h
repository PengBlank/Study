//
//  HYRPCompleteAnimationView.h
//  Teshehui
//
//  Created by apple on 15/3/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYRPCompleteAnimationView : UIView
{
    IBOutlet UIImageView *_coin;
    IBOutlet UIImageView *_coin2;
    IBOutlet UIImageView *_bag;
}

+ (instancetype)view;

+ (void)show;
+ (void)dismiss;

@end
