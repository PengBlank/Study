//
//  HYMallProductListTableViewHeaderView.h
//  Teshehui
//
//  Created by Kris on 16/3/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYXibView.h"
#import "HYMallBrandStory.h"

@protocol HYMallProductListTableViewHeaderViewDelegate <NSObject>

@optional
- (void)contentHeightHasChange;

@end

@interface HYMallProductListTableViewHeaderView : HYXibView

@property (nonatomic, strong) HYMallBrandStory *data;
@property (nonatomic, assign, readonly) CGFloat contentHeight;
@property (nonatomic, weak) id<HYMallProductListTableViewHeaderViewDelegate> delegate;

@end
