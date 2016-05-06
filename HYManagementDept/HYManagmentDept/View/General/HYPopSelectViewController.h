//
//  HYPopSelectViewController.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-16.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYPopSelectViewController;
@protocol HYPopSelectViewDelegate <NSObject>
@optional
- (void)popSelectView:(HYPopSelectViewController *)select didSelectIndex:(NSInteger)selectIdx andGetString:(NSString *)getString;
- (void)cancelSelectPop:(HYPopSelectViewController *)popSelect;

@end

@interface HYPopSelectViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger selectedIdx;
@property (nonatomic, weak) id<HYPopSelectViewDelegate> delegate;

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, weak) UIView *associatedControl;


@end
