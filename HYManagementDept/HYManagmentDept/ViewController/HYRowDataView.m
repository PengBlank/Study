//
//  HYRowDataView.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYRowDataView.h"
#import "UITableView+Extend.h"
#import "HYRefreshHeaderView.h"
#import "HYRefreshFooterView.h"
#import "HYGridCell.h"
#include "HYStyleConst.h"

@interface HYRowDataView ()
<
CCRefreshBaseViewDelegate>
{
    BOOL _shouldReplaceHeader;
    CGFloat _tableWidth;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *tableWrapper;
@property (nonatomic, strong) UIView *touchPreventer;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *rinfoLabel;

@property (nonatomic, strong) HYRefreshHeaderView *refreshHeader;
@property (nonatomic, strong) HYRefreshFooterView *refreshFooter;

@end

@implementation HYRowDataView

- (void)dealloc
{
    [_refreshHeader free];
    [_refreshFooter free];
}

- (void)setPage:(NSInteger)page
{
    if (page == 1) {
        [self resetVisibleScope];
    }
    if (_page != page) {
        _page = page;
    }
}

- (void)setTotal:(NSInteger)total
{
    if (_total != total) {
        _total = total;
    }
}

- (void)setNumber_per_page:(NSInteger)number_per_page
{
    if (_number_per_page != number_per_page) {
        _number_per_page = number_per_page;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _shouldReplaceHeader = NO;
        
        self.dataArray = [NSMutableArray array];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            _metrics.footHeight = 17;
            _metrics.footSize = 14;
            _metrics.tableMargin = 20;
            _metrics.additionInfoHeight = 15;
        }
        else
        {
            _metrics.footHeight = 15;
            _metrics.footSize = 12;
            _metrics.tableMargin = 10;
            _metrics.additionInfoHeight = 30;
        }
        
        CGRect rect = self.bounds;
        rect.size.height -= _metrics.footHeight;
        UIScrollView *tableWrapper = [[UIScrollView alloc] initWithFrame:rect];
        tableWrapper.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        tableWrapper.backgroundColor = [UIColor clearColor];
        tableWrapper.bounces = NO;
        tableWrapper.delegate = self;
        tableWrapper.canCancelContentTouches = NO;
        [self addSubview:tableWrapper];
        self.tableWrapper = tableWrapper;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStylePlain];
        //tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight| \
        UIViewAutoresizingFlexibleWidth;
        [_tableView setExtraLinesHidden];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = 50;
        tableView.layer.cornerRadius = 2.0;
        [self.tableWrapper addSubview:tableView];
        self.tableView = tableView;
        
        UIView *touchPreventer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, CGRectGetHeight(self.frame))];
        touchPreventer.tag = 1321;
        touchPreventer.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //touchPreventer.backgroundColor = [UIColor redColor];
        touchPreventer.tag = 1321;
        [self addSubview:touchPreventer];
        
        HYRefreshHeaderView* refreshHeader = [[HYRefreshHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableWrapper.frame), CGRectGetHeight(_tableView.frame))];
        refreshHeader.scrollView = self.tableView;
        refreshHeader.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        refreshHeader.delegate = self;
        self.refreshHeader = refreshHeader;
        
        HYRefreshFooterView *refreshFooter = [[HYRefreshFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), CGRectGetHeight(_tableView.frame))];
        refreshFooter.scrollView = _tableView;
        refreshFooter.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        refreshFooter.delegate = self;
        self.refreshFooter = refreshFooter;
        
        UILabel * infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_metrics.tableMargin, CGRectGetHeight(self.frame) - _metrics.footHeight, CGRectGetMidX(self.bounds)-_metrics.tableMargin, _metrics.footHeight)];
        infoLabel.textColor = [UIColor colorWithWhite:.63 alpha:1];
        infoLabel.font = [UIFont systemFontOfSize:_metrics.footSize];
        infoLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:infoLabel];
        self.infoLabel = infoLabel;
        
        UILabel * rinfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.bounds), CGRectGetHeight(self.frame) - _metrics.footHeight, CGRectGetMidX(self.bounds)-_metrics.tableMargin, _metrics.footHeight)];
        rinfoLabel.textColor = [UIColor colorWithWhite:.63 alpha:1];
        rinfoLabel.font = [UIFont systemFontOfSize:_metrics.footSize];
        rinfoLabel.textAlignment = NSTextAlignmentRight;
        rinfoLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:rinfoLabel];
        self.rinfoLabel = rinfoLabel;
    }
    return self;
}

- (void)setDelegate:(id<HYRowDataViewDelegate>)delegate
{
    if (_delegate != delegate)
    {
        _delegate = delegate;
        //self.tableView.delegate = delegate;
    }
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        //self.tableView.dataSource = dataSource;
    }
}

- (void)reloadData
{
    _shouldReload = YES;
    [self setTableColumnWidth:[_delegate getTableColumnWidth]];
    [self.tableView reloadData];
}

- (void)setTableColumnWidth:(NSArray *)tableColumnWidth
{
    if (_tableColumnWidth != tableColumnWidth)
    {
        _tableColumnWidth = tableColumnWidth;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            __block NSInteger width = 0;
            [tableColumnWidth enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                width += [(NSNumber *)obj integerValue];
            }];
            _tableWidth = width;
            [self layoutSubviews];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone &&
        _tableWidth > CGRectGetWidth(self.frame))
    {
        _shouldReplaceHeader = YES;
        CGRect frame = CGRectZero;
        frame.size.width = _tableWidth;
        frame.size.height = CGRectGetHeight(_tableWrapper.frame);
        frame.origin.x = _metrics.tableMargin;
        _tableView.frame = frame;
        
        [_tableView reloadData];
        
        _tableWrapper.contentSize = CGSizeMake(CGRectGetWidth(_tableView.frame)+20, CGRectGetHeight(frame));
    }
    else
    {
        _tableWrapper.contentSize = _tableWrapper.frame.size;
        CGRect frame = CGRectZero;
        frame.size.width = CGRectGetWidth(self.frame) - 40;
        frame.size.height = CGRectGetHeight(_tableWrapper.frame);
        frame.origin.x = _metrics.tableMargin;
        _tableView.frame = frame;
    }
}

#pragma mark - Refresh
- (void)refreshViewBeginRefreshing:(CCRefreshBaseView *)refreshView
{
    if (refreshView == _refreshHeader) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(rowDataViewWillBeginRefreshHeader:)])
        {
            [self.delegate rowDataViewWillBeginRefreshHeader:self];
        }
    }
    if (refreshView == _refreshFooter) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(rowDataViewWillBeginRefreshFooter:)])
        {
            [self.delegate rowDataViewWillBeginRefreshFooter:self];
        }
    }
}

#pragma mark - ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_delegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        [_delegate scrollViewDidScroll:scrollView];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (scrollView == _tableWrapper)
        {
            _shouldReplaceHeader = YES;
        }
        if (scrollView == _tableView)
        {
            if (scrollView.contentOffset.y < 0 || scrollView.contentOffset.y > scrollView.contentSize.height - CGRectGetHeight(scrollView.frame))
            {
                if (_shouldReplaceHeader)
                {
                    [self adjustRefresher];
                    _shouldReplaceHeader = NO;
                }
            }
        }
    }
}

//移动刷新头尾的位置
- (void)adjustRefresher
{
    if (_tableWrapper)
    {
        CGFloat wrapperx = _tableWrapper.contentOffset.x;
        if (wrapperx > 10)
        {
            wrapperx = wrapperx - 10;
        }
        CGRect headerFrame = _refreshHeader.frame;
        headerFrame.origin.x = wrapperx;
        headerFrame.size.width = CGRectGetWidth(_tableWrapper.frame);
        _refreshHeader.frame = headerFrame;
        
        CGRect footerFrame = _refreshFooter.frame;
        footerFrame.origin.x = wrapperx;
        footerFrame.size.width = CGRectGetWidth(_tableWrapper.frame);
        _refreshFooter.frame = footerFrame;
    }
}

- (void)endRefresh
{
    [_refreshHeader endRefreshing];
    [_refreshFooter endRefreshing];
}

- (void)resetVisibleScope
{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 20, 20) animated:NO];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self.tableWrapper scrollRectToVisible:CGRectMake(0, 0, 20, 20) animated:NO];
        [self adjustRefresher];
    }
}

- (void)setTotal:(NSInteger)total currentPage:(NSInteger)page perPage:(NSInteger)per
{
    self.total = total;
    self.page = page;
    self.number_per_page = per;
    if (total == 0)
    {
        self.infoLabel.text = [NSString stringWithFormat:@"共%ld个项目", (long)total];
    }
    else
    {
        NSInteger totalPage = total / per;
        NSInteger e = total % per;
        if (e > 0)
        {
            totalPage ++;
        }
        
        self.infoLabel.text = [NSString stringWithFormat:@"共%ld个项目，当前已加载%ld/%ld页", (long)total, (long)page, (long)totalPage];
    }
    self.canLoadMore = (total > _dataArray.count) || _dataArray.count == 0;
}

- (void)setTotal:(NSInteger)total currentNum:(NSInteger)num
{
    NSString *leftInfo = [NSString stringWithFormat:@"总共%ld项", (long)total];
    NSString *rightInfo = [NSString stringWithFormat:@"已加载%ld项", (long)num];
    self.infoLabel.text = leftInfo;
    self.rinfoLabel.text = rightInfo;
    self.canLoadMore = (total > _dataArray.count);
}

- (void)setAdditionInfo:(NSString *)additionInfo
{
    if (_additionInfo != additionInfo)
    {
        _additionInfo = additionInfo;
        
        if (!_additionLabel)
        {
            CGRect frame = CGRectZero;
            frame = _tableView.frame;
            frame.size.height -= _metrics.additionInfoHeight;
            _tableView.frame = frame;
            if (_tableWrapper)
            {
                frame = _tableWrapper.frame;
                frame.size.height -= _metrics.additionInfoHeight;
                _tableWrapper.frame = frame;
            }
            _additionLabel = [[UILabel alloc] initWithFrame:
                              CGRectMake(10,
                                         CGRectGetMinY(_infoLabel.frame)-_metrics.additionInfoHeight,
                                         CGRectGetWidth(frame) - 20,
                                         _metrics.additionInfoHeight)];
            _additionLabel.textColor = [UIColor colorWithRed:176/255.0 green:0 blue:0 alpha:1];
            _additionLabel.font = [UIFont systemFontOfSize:_metrics.footSize];
            _additionLabel.numberOfLines = 2;
            _additionLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
            [self addSubview:_additionLabel];
        }
        _additionLabel.text = _additionInfo;
    }
}

- (void)setCanRefresh:(BOOL)canRefresh
{
    _refreshHeader.hidden = !canRefresh;
}

- (void)setCanLoadMore:(BOOL)canLoadMore
{
    _refreshFooter.hidden = !canLoadMore;
}

#pragma mark - 数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"grid";
    HYGridCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HYGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.rowView.columnWidths = _tableColumnWidth;
        cell.rowView.defaultFont = [UIFont systemFontOfSize:16.0];
    }
    if (_shouldReload)
    {
        cell.rowView.columnWidths = _tableColumnWidth;
    }
    cell.rowView.bottomLineBold = indexPath.row == self.dataArray.count - 1;
    
    cell.rowView.indexPath = indexPath;
    if (self.dataArray.count > indexPath.row)
    {
        id model = [self.dataArray objectAtIndex:indexPath.row];
        [self.delegate configureCell:cell withModel:model];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([_delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
    {
        return [_delegate tableView:tableView heightForHeaderInSection:section];
    }
    if (section == 0) {
        return 45;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HYGridRowView *rowView = nil;
    rowView = [[HYGridRowView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 45)];
    rowView.columnWidths = _tableColumnWidth;
    rowView.backgroundColor = kGridHeaderColor;
    CGFloat fontsize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 14.0 : 16.0;
    rowView.defaultFont = [UIFont systemFontOfSize:fontsize];
    [rowView setContents:[self.delegate tableHeaderTexts]];
    rowView.bottomLineBold = YES;
    UIView *topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rowView.frame), 5)];
    topline.backgroundColor = kGridFrameColor;
    topline.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [rowView addSubview:topline];
    return rowView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [_delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)clear
{
    [self.dataArray removeAllObjects];
}

- (void)add:(NSArray *)array
{
    [self.dataArray addObjectsFromArray:array];
}

- (NSInteger)count
{
    return self.dataArray.count;
}

- (id)dataAtIndex:(NSInteger)idx
{
    if (_dataArray.count > idx)
    {
        return [_dataArray objectAtIndex:idx];
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
