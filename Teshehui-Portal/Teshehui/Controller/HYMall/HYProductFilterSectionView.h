//
//  HYProductFilterSectionView.h
//  Teshehui
//
//  Created by 成才 向 on 15/9/5.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallFullOrderSectionView.h"

@interface HYProductFilterSectionView : UIView

@property (nonatomic, weak) id<HYMallFullOrderSectionDelegate> delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isExpend;

@end
