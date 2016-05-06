//
//  HYMallSearchResultHeaderView.h
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallCategoryInfo.h"
#import "HYProductListSummary.h"

@protocol HYMallSearchResultHeaderViewDelegate <NSObject>

- (void)clearConditionAtIndex:(NSInteger)idx;
- (void)reloadWithCorrect;
- (void)goToMakeWish;

@end

@interface HYMallSearchResultHeaderView : UIView

@property (nonatomic, strong) HYMallCategoryInfo *cate;
@property (nonatomic, strong) NSArray *conditions;

- (void)setCorrectName:(NSString *)correctName
         withWrongName:(NSString *)wrongName;

- (void)setNull;    //重新搜索

- (void)setHide;

@property (nonatomic, weak) id<HYMallSearchResultHeaderViewDelegate> delegate;

@end
