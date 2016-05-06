//
//  DownMenuView.h
//  DownMenu
//
//  Created by apple_administrator on 15/9/1.
//  Copyright (c) 2015年 Tkun. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DownMenuViewDelegate <NSObject>

- (void)selectedRowWithObj:(NSObject *)Obj isAll:(BOOL)isAll;
- (void)selectedRowWithIndx:(NSInteger)index;
- (void)selectedRowWithObj:(NSObject *)obj;
- (void)selectedRowWithItem:(NSString *)objString;

@end

typedef void(^TopicListViewHideBlock)();

@interface DownMenuView : UIView
<
UITableViewDataSource,
UITableViewDelegate
>
{
    UIView *_backgroundView;
    UIView *_backgroundNavView;
}

@property (nonatomic, assign) NSInteger   categoryType;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightableView;
@property (nonatomic, strong) UITableView *sortTableView;
@property (nonatomic, assign) BOOL      isShow;

@property (nonatomic , copy) void(^CategoryViewHideBlock)( NSInteger indexLeft,NSInteger indexRight);

@property (nonatomic, assign) id <DownMenuViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame hiddenBlock:(TopicListViewHideBlock)block;

- (void)bindData:(NSMutableArray *)objArray index:(NSInteger)index;
- (void)initCategoryTable;
- (void)initSortTable;

- (void)showInView:(UIView *)view index:(NSInteger)index;
- (void)dismiss;
- (void)hidenView;

@end
