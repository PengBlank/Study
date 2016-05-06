//
//  HYMallFullOrderSectionView.h
//  Teshehui
//
//  Created by HYZB on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallCartShopInfo.h"

@protocol HYMallFullOrderSectionDelegate <NSObject>

@optional
- (void)didExpandCellWithSection:(NSInteger)section;

@end

@interface HYMallFullOrderSectionView : UIView

@property (nonatomic, weak) id<HYMallFullOrderSectionDelegate> delegate;
@property (nonatomic, strong) HYMallCartShopInfo *store;
@property (nonatomic, assign) BOOL isExpend;

@end
