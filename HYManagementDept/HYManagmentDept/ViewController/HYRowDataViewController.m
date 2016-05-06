//
//  HYRowDataViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-12.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYRowDataViewController.h"
#import "UIImage+ResizableUtil.h"
#import "UIAlertView+Utils.h"
#import "UITableView+Extend.h"

@interface HYRowDataViewController ()
@end

@implementation HYRowDataViewController

#pragma makr - View cicle

- (void)dealloc
{
    [_rowDatarequest cancel];
    [_refreshHeader free];
    [_refreshFooter free];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _shouldReplaceHeader = YES;
        _isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        _page = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    
    //重设table width
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        NSArray *columnWidth = [self getTableColumnWidth];
        __block NSInteger width = 0;
        [columnWidth enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            width += [(NSNumber *)obj integerValue];
        }];
        
        CGFloat xoffset = 10;
        
        if (width <= CGRectGetWidth(self.view.frame) - 2 * xoffset)
        {
            width = CGRectGetWidth(self.view.frame);
        }
        
        CGRect frame = _tableView.frame;
        frame.size.width = width;
        _tableView.frame = frame;
        
        [_tableView reloadData];
        
        _tableWrapper.contentSize = CGSizeMake(CGRectGetWidth(_tableView.frame) + 2 * xoffset, CGRectGetHeight(_tableView.frame));
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private data
- (void)sendRequest
{
    //if (_isLoading)
    {
        [_rowDatarequest cancel];
        _rowDatarequest = nil;
    }
    _isLoading = YES;
    
    [self showLoadingView];
    
    __weak typeof(self) _self = self;
    [self.rowDatarequest sendReuqest:^(id result, NSError *error)
     {
         HYRowDataViewController *s_self = _self;
         
         [s_self hideLoadingView];
         if (s_self.refreshHeader.isRefreshing)
         {
             [s_self.refreshHeader endRefreshing];
         }
         if (s_self.refreshFooter.isRefreshing)
         {
             [s_self.refreshFooter endRefreshing];
         }
         
         if (s_self.page == 1)
         {
             [s_self.dataSource removeAllObjects];
         }
         
         s_self.isLoading = NO;
         
         HYRowDataResponse *rs = (HYRowDataResponse *)result;
         if (rs)
         {
             if (rs.status == 200)
             {
                 [s_self.dataSource addObjectsFromArray:rs.dataArray];
                 
                 
                 [s_self setTotal:rs.total
                      currentPage:s_self.page
                          perPage:s_self.rowDatarequest.num_per_page];
                 
                 if (rs.total == s_self.dataSource.count ||
                     s_self.dataSource.count == 0)
                 {
                     s_self.refreshFooter.hidden = YES;
                 }
                 else
                 {
                     s_self.refreshFooter.hidden = NO;
                 }
             }
             else
             {
                 [UIAlertView showMessage:error.domain];
                 [s_self setTotalNumber:s_self.dataSource.count];
                 s_self.refreshFooter.hidden = YES;
             }
         }
         
         [s_self.tableView reloadData];
         
         //移动显示区域到左上角
         if (s_self.page == 1)
         {
             [s_self.tableView scrollRectToVisible:CGRectMake(0, 0, 20, 20) animated:NO];
             if (s_self.tableWrapper)
             {
                 [s_self.tableWrapper scrollRectToVisible:CGRectMake(0, 0, 20, 20) animated:NO];
                 [s_self adjustRefresher];
             }
         }
     }];
}

- (void)reloadDatas
{
    _page = 1;
    [self sendRequest];
}

#pragma mark - Setter/Getter
- (HYSortHeadView *)headView
{
    if (!_headView)
    {
        CGFloat yoff;
        CGFloat xoff;
        CGFloat height;
        if (_isPad)
        {
            yoff = 20;
            xoff = 20;
            height = 55;
        }
        else
        {
            yoff = 10;
            xoff = 10;
            height = 45;
        }
        _headView = [[HYSortHeadView alloc] initWithFrame:CGRectMake(xoff, yoff, CGRectGetWidth(self.view.frame) - xoff * 2, height)];
        _headView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        //_headView.backgroundColor = [
        _headView.delegate = self;
        [self.view addSubview:_headView];
    }
    return _headView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)createTableWithOffset:(CGFloat)yoffset
{
    CGFloat xoffset;
    CGFloat footHeight;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        xoffset = 20;
        yoffset += 10;
        footHeight = 50;
    }
    else
    {
        xoffset = 10;
        yoffset += 10;
        footHeight = 25;
    }
    float tableWidth = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGRectGetWidth(self.view.frame) - 2*xoffset : 768;
    
    _tableView = [[UITableView alloc] initWithFrame:
                  CGRectMake(xoffset,
                             yoffset,
                             tableWidth,
                             CGRectGetHeight(self.view.frame) - yoffset - footHeight)
                                              style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight| \
    UIViewAutoresizingFlexibleWidth;
    [_tableView setExtraLinesHidden];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 40;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        _tableWrapper = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_tableView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(_tableView.frame))];
        _tableWrapper.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableWrapper.canCancelContentTouches = NO;
        _tableWrapper.bounces = NO;
        _tableWrapper.delegate = self;
        
        CGRect frame = _tableView.frame;
        frame.origin.y = 0;
        _tableView.frame = frame;
        [_tableWrapper addSubview:_tableView];
        [self.view addSubview:_tableWrapper];
        
        [self addTouchPreventer];
        
    }
    else
    {
        [self.view addSubview:_tableView];
    }
}

- (UITableView *)tableView
{
    return nil;
    if (!_tableView)
    {

        CGFloat xoffset, yoffset;
        CGFloat footHeight;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            xoffset = 20;
            yoffset = 10;
            footHeight = 50;
        }
        else
        {
            xoffset = 10;
            yoffset = 10;
            footHeight = 25;
        }
        
        float tableWidth = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGRectGetWidth(self.view.frame) - 2*xoffset : 768;
        
        _tableView = [[UITableView alloc] initWithFrame:
                      CGRectMake(xoffset,
                                 CGRectGetMaxY(_headView.frame) + yoffset,
                                 tableWidth,
                                 CGRectGetHeight(self.view.frame)-CGRectGetMaxY(_headView.frame) - yoffset - footHeight)
                                                  style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight| \
        UIViewAutoresizingFlexibleWidth;
        [_tableView setExtraLinesHidden];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 40;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            _tableWrapper = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_tableView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(_tableView.frame))];
            _tableWrapper.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            _tableWrapper.canCancelContentTouches = NO;
            _tableWrapper.bounces = NO;
            _tableWrapper.delegate = self;
            
            CGRect frame = _tableView.frame;
            frame.origin.y = 0;
            _tableView.frame = frame;
            [_tableWrapper addSubview:_tableView];
            [self.view addSubview:_tableWrapper];
            
            [self addTouchPreventer];
            
        }
        else
        {
            [self.view addSubview:_tableView];
        }
    }
    return _tableView;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel)
    {
        CGFloat footHeight;
        CGFloat footSize;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            footHeight = 40;
            footSize = 14;
        }
        else
        {
            footHeight = 15;
            footSize = 12;
        }
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetHeight(self.view.frame) - footHeight, 400, footHeight)];
        _infoLabel.textColor = [UIColor colorWithRed:176/255.0 green:0 blue:0 alpha:1];
        _infoLabel.font = [UIFont systemFontOfSize:footSize];
        _infoLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:_infoLabel];
    }
    return _infoLabel;
}

- (HYRefreshHeaderView *)refreshHeader
{
    if (!_refreshHeader)
    {
        _refreshHeader = [[HYRefreshHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableWrapper.frame), CGRectGetHeight(_tableView.frame))];
        _refreshHeader.scrollView = _tableView;
        _refreshHeader.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _refreshHeader.delegate = self;
    }
    return _refreshHeader;
}

- (HYRefreshFooterView *)refreshFooter
{
    if (!_refreshFooter)
    {
        _refreshFooter = [[HYRefreshFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), CGRectGetHeight(_tableView.frame))];
        _refreshFooter.scrollView = _tableView;
        _refreshFooter.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _refreshFooter.delegate = self;
    }
    return _refreshFooter;
}

#pragma mark - Private View controll
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

- (void)addTouchPreventer
{
    if (!_tableWrapper)
    {
        return;
    }
    CGFloat y = CGRectGetMinY(_tableWrapper.frame);
    CGFloat w = 30;
    CGFloat h = CGRectGetHeight(_tableWrapper.frame);
    UIView *touchPreventer = [self.view viewWithTag:1321];
    if (!touchPreventer)
    {
        touchPreventer = [[UIView alloc] initWithFrame:CGRectMake(0, y, w, h)];
        touchPreventer.tag = 1321;
        touchPreventer.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //touchPreventer.backgroundColor = [UIColor redColor];
        touchPreventer.tag = 1321;
        [self.view addSubview:touchPreventer];
    }
    
    touchPreventer.frame = CGRectMake(0, y, w, h);
}

- (void)setTotalNumber:(NSInteger)total
{
    self.infoLabel.text = [NSString stringWithFormat:@"共%ld个项目", (long)total];
}

- (void)setTotal:(NSInteger)total currentPage:(NSInteger)page perPage:(NSInteger)per
{
    NSInteger totalPage = total / per;
    NSInteger e = total % per;
    if (e > 0)
    {
        totalPage ++;
    }
    
    if (total == 0)
    {
        page = 0;
    }
    self.infoLabel.text = [NSString stringWithFormat:@"共%ld个项目，当前已加载%ld/%ld页", (long)total, (long)page, (long)totalPage];
}

#pragma mark - TableView

- (NSArray *)getTableColumnWidth
{
    return @[];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"grid";
    HYGridCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HYGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.rowView.columnWidths = [self getTableColumnWidth];
    }
    cell.rowView.indexPath = indexPath;
    id model = [self.dataSource objectAtIndex:indexPath.row];
    [self configureCell:cell withModel:model];
    return cell;
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HYGridRowView *rowView = nil;
    rowView = [[HYGridRowView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 40)];
    rowView.columnWidths = [self getTableColumnWidth];
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    //    {
    //        rowView.columnWidthFixed = YES;
    //    }
    rowView.backgroundColor = TableHeaderBackgroundColor;
    rowView.defaultFont = [UIFont systemFontOfSize:18.0];
    [rowView setContents:[self tableHeaderTexts]];
    return rowView;
}

- (NSArray *)tableHeaderTexts
{
    return @[];
}

#pragma mark - ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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

#pragma mark - Refresh
- (void)refreshViewBeginRefreshing:(CCRefreshBaseView *)refreshView
{
    if (refreshView == _refreshHeader) {
        _page = 1;
        [self sendRequest];
    }
    if (refreshView == _refreshFooter) {
        _page += 1;
        [self sendRequest];
    }
}

#pragma mark - Head
- (void)headViewDidClickedQueryBtn:(HYSortHeadView *)headView
{
    [self.view endEditing:YES];
    _page = 1;
    [self sendRequest];
}

- (void)headViewDidClickedAllBtn:(HYSortHeadView *)headView
{
    [self.view endEditing:YES];
    _page = 1;
    [self sendRequest];
}

#pragma mark - Child implements
- (void)configureCell:(HYGridCell *)cell withModel:(id)model
{
    //Empty
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
