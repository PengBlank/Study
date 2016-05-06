//
//  HYXibView.h
//  Teshehui
//
//  Created by Kris on 16/2/26.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYXibViewBehavior.h"

//抽象父类，面向接口编程，交给子类多态实现
@interface HYXibView : UIView
<
HYXibViewAction,
UIGestureRecognizerDelegate
>
{
    HYXibViewBehavior *_xibViewBehavior;
}

+ (instancetype)instanceView;
/*
@property (nonatomic, weak) id<HYXibViewActionDelegate> actionDelegate;
*/

@end


