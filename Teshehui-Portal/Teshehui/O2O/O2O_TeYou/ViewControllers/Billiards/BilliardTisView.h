//
//  BilliardTisView.h
//  Teshehui
//
//  Created by apple_administrator on 15/11/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BilliardsTableInfo.h"

@interface BilliardTisView : UIView
@property (nonatomic ,copy) void(^BilliardsViewBlock)(void);

- (id)initWithFrame:(CGRect)frame billiardsTableInfo:(BilliardsTableInfo *)info;
- (void)show;
- (void)dismiss;
@end
