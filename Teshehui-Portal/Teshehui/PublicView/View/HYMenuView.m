//
//  HYMenuView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-5-29.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMenuView.h"
#import "HYFlowerTypeInfo.h"

@interface HYMenuView ()<UIGestureRecognizerDelegate>
{
    BOOL _show;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HYMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _show = NO;
        _currentIndex = 0;
        CGFloat x = [UIScreen mainScreen].bounds.size.width - 120;
        CGRect rect = CGRectMake(x, 64, 120, 0);
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:rect];
        bgView.image = [[UIImage imageNamed:@"menu_bg"] stretchableImageWithLeftCapWidth:1
                                                                            topCapHeight:1];
        
        _tableView = [[UITableView alloc] initWithFrame:rect
                                                  style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = bgView;
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        [self addSubview:_tableView];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setMenuViewShow:NO animation:YES];
}

#pragma mark setter/getter
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (_currentIndex != currentIndex && currentIndex<[self.dataSource count])
    {
        _currentIndex = currentIndex;
    }
}

- (void)setDataSource:(NSArray *)dataSource
{
    if (_dataSource != dataSource)
    {
        _dataSource = dataSource;
        
        if (_currentIndex >= [dataSource count])
        {
            _currentIndex = 0;
        }
        
        [self.tableView reloadData];
    }
}

#pragma mark private methods
- (void)setMenuViewShow:(BOOL)show animation:(BOOL)animation
{
    if (_show != show)
    {
        _show = show;
        
        CGFloat x = [[UIScreen mainScreen] bounds].size.width - 120;
        if (show)
        {
            if (!self.superview)
            {
                UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                [window addSubview:self];
            }
            
            if (animation)
            {
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     _tableView.frame = CGRectMake(x, 64, 120, 200);
                                 }];
            }
            else
            {
                _tableView.frame = CGRectMake(x, 64, 120, 200);
            }
        }
        else
        {
            if (self.superview)
            {
                if (animation)
                {
                    [UIView animateWithDuration:0.5
                                     animations:^{
                                         _tableView.frame = CGRectMake(x, 64, 120, 0);
                                     }
                                     completion:^(BOOL finished) {
                                         if (finished)
                                         {
                                             [self removeFromSuperview];
                                         }
                                     }];
                }
                else
                {
                    [self removeFromSuperview];
                }
            }
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentIndex == indexPath.row)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:218.0/255.0
                                                           green:80.0/255.0
                                                            blue:94.0/255.0
                                                           alpha:1.0];
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    if (indexPath.row < [self.dataSource count])
    {
        id obj = [self.dataSource objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[HYFlowerTypeInfo class]])
        {
            HYFlowerTypeInfo *type = (HYFlowerTypeInfo *)obj;
            cell.textLabel.text = type.categoryName;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != _currentIndex)
    {
        _currentIndex = indexPath.row;
        
        [tableView reloadData];
        
        if ([self.delegate respondsToSelector:@selector(didSelectedMenuItem:)])
        {
            id item = [self.dataSource objectAtIndex:_currentIndex];
            [self.delegate didSelectedMenuItem:item];
        }
    }
    
    [self setMenuViewShow:NO animation:YES];
}


@end
