//
//  HYHomeMoreView.h
//  Teshehui
//
//  Created by HYZB on 15/11/11.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HomeMoreType)
{
    HYScanQRCode,
    HYCheckQRCode
};

@interface HYHomeMoreView : UIView

@property (nonatomic, copy) void(^didClickType)(HomeMoreType type);

- (void)setMenuViewShow:(BOOL)show animation:(BOOL)animation;

@end
