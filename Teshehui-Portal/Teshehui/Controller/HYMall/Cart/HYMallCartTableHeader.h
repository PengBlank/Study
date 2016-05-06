//
//  HYMallCartTableHeader.h
//  Teshehui
//
//  Created by RayXiang on 14-9-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallCartShopInfo.h"

@class HYMallCartTableHeader;
@protocol hyMallCartTableHeaderDelegate <NSObject>
@optional
- (void)cartHeaderDidClickCheckButton:(HYMallCartTableHeader *)header;
- (void)cartHeaderDidClickEditButton:(HYMallCartTableHeader *)header;

@end

@interface HYMallCartTableHeader : UIView

@property (nonatomic, assign) BOOL edit;

@property (nonatomic, strong) HYMallCartShopInfo *shopInfo;

@property (nonatomic, weak) id<hyMallCartTableHeaderDelegate> delegate;

@property (nonatomic, assign) NSInteger section;

- (void)setEditBtnHidden:(NSNumber *)status;

@end
