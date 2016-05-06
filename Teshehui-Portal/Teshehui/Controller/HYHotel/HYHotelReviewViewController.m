//
//  HYHotelReviewViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelReviewViewController.h"
#import "HYHotelReviewSummaryCell.h"
#import "HYHotelReviewServiceCell.h"
#import "HYHotelReviewDetailCell.h"
#import "HYTableViewFooterView.h"

#import "HYHotelCommentReuqest.h"
#import "HYHotelCommentResponse.h"


@interface HYHotelReviewViewController ()
{
    HYHotelCommentReuqest *_commRequest;
    NSInteger _pageNumber;
    BOOL _reloading;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYHotelReview *hotelReview;
@property (nonatomic, strong) NSMutableArray *reviewList;

@end

@implementation HYHotelReviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _pageNumber = 1;
        _reloading = NO;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //tableview
    frame.origin.y = 10;
    frame.origin.x = 10;
    frame.size.width = 300;
    frame.size.height -= 10;
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.showsHorizontalScrollIndicator = NO;
    tableview.showsVerticalScrollIndicator = NO;
    
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    tableview.tableFooterView = v;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"hotel_review", nil);
    
    //加载数据
    [self loadReviewData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (!self.view.window)
    {
        [_tableView removeFromSuperview];
        _tableView = nil;
        
        self.view = nil;
    }
}

#pragma mark private methods
- (void)loadReviewData
{
    if (!_reloading)
    {
        _reloading = YES;
        
        if (!_commRequest)
        {
            _commRequest = [[HYHotelCommentReuqest alloc] init];
        }
        
        _commRequest.HotelID = self.hotelInfo.productId;
        _commRequest.page = _pageNumber;
        
        
        __weak typeof(self) b_self = self;
        [_commRequest sendReuqest:^(id result, NSError *error) {
            if ([result isKindOfClass:[HYHotelCommentResponse class]])
            {
                HYHotelCommentResponse *response = (HYHotelCommentResponse *)result;
                b_self.hotelReview = response.hotelReview;
                [b_self updateViewWithNewReview:response.reviewList];
            }
        }];
    }
}

- (void)updateViewWithNewReview:(NSArray *)reviews
{
    _reloading = NO;
    [(HYTableViewFooterView *)self.tableView.tableFooterView stopLoadMore];
    
    if ([reviews count] > 0)
    {
        if (!_reviewList)
        {
            _reviewList = [[NSMutableArray alloc] init];
        }
        
        [_reviewList addObjectsFromArray:reviews];
    }
    
    [self.tableView reloadData];
}

- (void)reloadMoreData
{
    if (!_reloading && !_reloading)
    {
        [(HYTableViewFooterView *)self.tableView.tableFooterView startLoadMore];
        
        if ([self.reviewList count] < self.hotelReview.ratingCount)
        {
            _pageNumber++;
            [self loadReviewData];
        }
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 2;
    if (section == 1)
    {
        count = [self.reviewList count];
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;
    
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        height = 78.0f;
    }
    else if (indexPath.section == 1)
    {
        HYHotelReviewDetail *detail = [self.reviewList objectAtIndex:indexPath.row];
        CGSize size = [detail.Content sizeWithFont:[UIFont systemFontOfSize:12]
                                 constrainedToSize:CGSizeMake(268, MAXFLOAT)
                                     lineBreakMode:NSLineBreakByCharWrapping];
        
        height = size.height+54;
    }

    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,300,10)];
    tempView.backgroundColor=[UIColor clearColor];
    return tempView;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
    if(indexPath.row == totalRow -1){
        //this is the last row in section.
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *reviewSummaryCellId = @"reviewSummaryCellId";
            HYHotelReviewSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:reviewSummaryCellId];
            if (cell == nil)
            {
                cell = [[HYHotelReviewSummaryCell alloc]initWithStyle:UITableViewCellStyleValue1
                                             reuseIdentifier:reviewSummaryCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setHiddenLine:YES];
            }
            
            cell.textLabel.text = [NSString stringWithFormat:@"评分%.1f分", self.hotelReview.RatingAll];
            //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d人点评", self.hotelReview.ratingCount];
            
            return cell;
        }
        else
        {
            static NSString *reviewServiceCellId = @"reviewServiceCellId";
            HYHotelReviewServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:reviewServiceCellId];
            if (cell == nil)
            {
                cell = [[HYHotelReviewServiceCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:reviewServiceCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setHiddenLine:YES];
            }
            
            [cell setHotelReview:self.hotelReview];
            return cell;
        }
    }
    else
    {
        static NSString *reviewDetailCellId = @"reviewDetailCellId";
        HYHotelReviewDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reviewDetailCellId];
        if (cell == nil)
        {
            cell = [[HYHotelReviewDetailCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:reviewDetailCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setHiddenLine:YES];
        }
        
//        [cell setIsBottomCell:(indexPath.row+1==[self.reviewList count])];
        
        if (indexPath.row < [self.reviewList count])
        {
            HYHotelReviewDetail *detail = [self.reviewList objectAtIndex:indexPath.row];
            [cell setHotelReviewDetail:detail];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float scrollOffset = scrollView.contentOffset.y;
    float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (scrollOffset >= maximumOffset && scrollView.contentSize.height >= self.view.frame.size.height)
    {
        [self reloadMoreData];
    }
}


@end
