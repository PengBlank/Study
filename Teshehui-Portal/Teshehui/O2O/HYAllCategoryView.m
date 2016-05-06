//
//  HYAllCategoryView.m
//  Teshehui
//
//  Created by Kris on 15/6/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYAllCategoryView.h"
@interface HYAllCategoryView()


@end

@implementation HYAllCategoryView


-(void)awakeFromNib
{
    
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        CGRect bounds = [UIScreen mainScreen].bounds;
        
        self.frame = CGRectMake(0, 64 + TFScalePoint(34), bounds.size.width, 240);
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark getter and setter
- (UITableView *)smartSortTableView
{
    if (!_smartSortTableView)
    {
        CGRect bounds = [UIScreen mainScreen].bounds;
        
        self.frame = CGRectMake(0, 64 + TFScalePoint(34), bounds.size.width, 120);
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, 120)
                                                             style:UITableViewStylePlain];
        [self addSubview:tableView];
        
        
        _smartSortTableView = tableView;
    }
    
    return _smartSortTableView;
}

//主table
- (UITableView *)allCategorySelectTableView
{
    if (!_allCategorySelectTableView)
    {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 140, 240)
                                                             style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView];
        
        _allCategorySelectTableView = tableView;
        
        UIImage *line = [[UIImage imageNamed:@"Line_InCell"]
                         stretchableImageWithLeftCapWidth:2 topCapHeight:0
                         ];
        UIImageView *linev = [[UIImageView alloc] initWithImage:line];
        linev.frame = CGRectMake(140, 0, 1, 240);
        [self addSubview:linev];
    }
    return _allCategorySelectTableView;
}

- (UITableView *)allCategoryTableView
{
    if (!_allCategoryTableView)
    {
        CGRect bounds = [UIScreen mainScreen].bounds;
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_allCategorySelectTableView.frame)+1, 0, bounds.size.width - 141, 240)
                                                             style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self addSubview:tableView];
        _allCategoryTableView = tableView;
    }
    return _allCategoryTableView;
}

- (void)showWithAnimation:(BOOL)animation andFrame:(CGRect)frame
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGRect newFrame = CGRectMake(0, CGRectGetMaxY(frame) + 60, bounds.size.width, self.bounds.size.height);
    
    if (!_backgroundNavView)
    {
        _backgroundNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 64)];
        _backgroundNavView.backgroundColor = [UIColor clearColor];
        _backgroundNavView.alpha = .5;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap:)];
        [_backgroundNavView addGestureRecognizer:tap1];
    }
    
    if (!_backgroundView)
    {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(newFrame), bounds.size.width, bounds.size.height)];
        _backgroundView.backgroundColor = [UIColor clearColor];
        _backgroundView.alpha = .5;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap:)];
        [_backgroundView addGestureRecognizer:tap2];
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:_backgroundView];
    [window addSubview:_backgroundNavView];
    [window addSubview:self];
    
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundNavView.backgroundColor = [UIColor blackColor];
    
    if (animation)
    {
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self setAlpha:1];
                         }];
    }
    else
    {
        self.frame = newFrame;
    }
}

- (void)dismissWithAnimation:(BOOL)animation
{
    if ([self superview])
    {
        if (animation)
        {
            [UIView animateWithDuration:0.5 animations:^
             {
                 _backgroundView.backgroundColor = [UIColor clearColor];
                 _backgroundNavView.backgroundColor = [UIColor clearColor];
                 [self setAlpha:0];
             } completion:^(BOOL finished) {
                 [_backgroundView removeFromSuperview];
                 [_backgroundNavView removeFromSuperview];
                 [self removeFromSuperview];
             }];
        }
        else
        {
            [_backgroundView removeFromSuperview];
            [_backgroundNavView removeFromSuperview];
            [self removeFromSuperview];
        }
        
    }
    
}

- (void)bgTap:(UITapGestureRecognizer *)tap
{
    [self dismissWithAnimation:YES];
}

#pragma mark getter and setter

@end
