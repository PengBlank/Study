//
//  HYAfterSaleHandleView.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallAfterSaleInfo.h"
#import "HYAfterSaleDefines.h"


@protocol HYAfterSaleHandleDelegate <NSObject>

- (void)checkHandleType:(HYAfterSaleHandleType)type;

@end

@interface HYAfterSaleHandleView : UIView

@property (nonatomic, weak) id<HYAfterSaleHandleDelegate> delegate;
@property (nonatomic, strong) HYMallAfterSaleInfo *saleInfo;

@end
