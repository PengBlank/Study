//
//  HYCommentsViewController.m
//  Teshehui
//
//  Created by RayXiang on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCommentsViewController.h"
#import "HYCommentCell.h"
#import "HYCommentHeaderCell.h"
#import "MWPhotoBrowser.h"

//http
#import "HYMallGetGoodsCommentRequest.h"
#import "HYMallGetGoodsCommentResponse.h"
#import "HYNullView.h"
#import "HYTableViewFooterView.h"
#import "HYUserInfo.h"

@interface HYCommentsViewController ()
<HYCommentCellDelegate, MWPhotoBrowserDelegate>
{
    BOOL _hasMore;
    BOOL _isLoading;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HYMallGetGoodsCommentRequest *commentsRequest;
@property (nonatomic, strong) NSMutableArray *commentsList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) HYNullView *nullView;
@property (nonatomic, assign) NSInteger orderTotal;

@property (nonatomic, strong) NSMutableArray *photoBrows;
@property (nonatomic, strong) NSMutableArray *thumbBrows;

@end

@implementation HYCommentsViewController

-(void)dealloc
{
    [HYLoadHubView dismiss];
    [_commentsRequest cancel];
    _commentsRequest = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.page = 1;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.backgroundView = nil;
    /*tableview.backgroundColor = [UIColor colorWithRed:240/255.0
     green:239/255.0
     blue:245/255.0
     alpha: 1];*/
    tableview.delaysContentTouches = NO;
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    tableview.tableFooterView = v;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
    
    self.commentsList = [NSMutableArray array];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"评价";
    [self getCommentsList];
}

#pragma mark - Private

- (void)getCommentsList
{
    self.commentsRequest = [[HYMallGetGoodsCommentRequest alloc] init];
    _commentsRequest.goods_id = _goods_id;
    _commentsRequest.goods_id = @"1581";
    _commentsRequest.page = _page;
    _commentsRequest.num_per_page = 10;
    _commentsRequest.userid = [HYUserInfo getUserInfo].userId;
    
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_commentsRequest sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        NSArray* array;
        if (result && [result isKindOfClass:[HYMallGetGoodsCommentResponse class]])
        {
            HYMallGetGoodsCommentResponse *response = (HYMallGetGoodsCommentResponse *)result;
            if (response.status == 200) {
                array = response.commentArray;
                b_self.orderTotal = response.commentTotal;
            }
        }
        [b_self updateViewWithData:array error:error];
    }];
}

- (void)loadMoreData
{
    if (_hasMore && !_isLoading)
    {
        _page++;
        [(HYTableViewFooterView *)self.tableView.tableFooterView startLoadMore];
        [self getCommentsList];
    }
}

- (void)updateViewWithData:(NSArray *)array error:(NSError *)error
{
    if ([array count] > 0)
    {
        [_commentsList addObjectsFromArray:array];
        [self.tableView reloadData];
        _nullView.hidden = YES;
    }
    else if ([_commentsList count] <= 0)
    {
        _nullView.hidden = NO;
        [self.tableView reloadData];
        
        if (error)
        {
            _nullView.descInfo = @"商品评价获取失败，请稍后再试";
            _nullView.needTouch = YES;
        }
        else
        {
            _nullView.descInfo = @"该商品没有评价";
            _nullView.needTouch = NO;
        }
    }
    else
    {
        [self.tableView setHidden:NO];
        [_nullView setHidden:YES];
        
        [(HYTableViewFooterView *)self.tableView.tableFooterView stopLoadMore];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentsList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *identifier = @"commentHeaderCell";
        HYCommentHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!headerCell)
        {
            headerCell = [[HYCommentHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        headerCell.commentNum = self.commentNum;
        headerCell.commentLevel = self.commentLevel;
        return headerCell;
    }
    else
    {
        static NSString *identifier = @"commentCell";
        HYCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[HYCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        HYMallGoodCommentInfo *model = [self modelWithPath:indexPath];
        cell.commentInfo = model;
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 45;
    }
    else
    {
        HYMallGoodCommentInfo *model = [self modelWithPath:indexPath];
        CGFloat h = [HYCommentCell heightForModel:model];
        return h;
    }
}

- (HYMallGoodCommentInfo *)modelWithPath:(NSIndexPath *)path
{
    if (self.commentsList.count > path.row-1)
    {
        return [self.commentsList objectAtIndex:path.row-1];
    }
    return nil;
}

#pragma mark - scroll View delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //加载更多
    float scrollOffset = scrollView.contentOffset.y;
    float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (scrollOffset >= maximumOffset)
    {
        [self loadMoreData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
- (void)commentCell:(HYCommentCell *)cell withInfo:(HYMallGoodCommentInfo *)info didClickImageAtIndex:(NSInteger)idx
{
    DebugNSLog(@"click idx : %ld", idx);
    NSMutableArray *photos = [[NSMutableArray alloc] init];
	NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    
    for (NSDictionary *p in info.pics)
    {
        NSString *imageStr = [p objectForKey:@"image"];
        NSString *thumbStr = [p objectForKey:@"thumb"];
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imageStr]]];
        [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:thumbStr]]];
    }
    
    self.photoBrows = photos;
    self.thumbBrows = thumbs;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.wantsFullScreenLayout = YES;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    [browser setCurrentPhotoIndex:idx];
    [self.navigationController pushViewController:browser animated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.photoBrows.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return [self.photoBrows objectAtIndex:index];
}

#pragma mark setter/getter
- (HYNullView *)nullView
{
    if (!_nullView)
    {
        CGRect frame = self.view.frame;
        frame.origin = CGPointZero;
        
        _nullView = [[HYNullView alloc] initWithFrame:frame];
        _nullView.needTouch = YES;
        [_nullView addTarget:self
                      action:@selector(getCommentsList)
            forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nullView];
    }
    
    return _nullView;
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
