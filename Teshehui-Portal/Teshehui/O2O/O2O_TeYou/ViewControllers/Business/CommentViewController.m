//
//  CommentViewController.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CommentViewController.h"
#import "PostCommentViewController.h"

#import "DefineConfig.h"

#import "CommentCell.h"

#import "MJExtension.h"
#import "METoast.h"
#import "Masonry.h"

#import "CommentInfo.h"
#import "HYUserInfo.h"
#import "PraiseRequest.h"
#import "CommentListRequest.h"
#import "CheckUserCommentRequest.h"

#import "MWPhotoBrowser.h"
#import "SVPullToRefresh.h"
#import "DLStarRatingControl.h"

#import "UIImage+Common.h"
#import "UIView+Common.h"
#import "UIColor+expanded.h"
#import "UIColor+hexColor.h"
#import "UIView+Frame.h"
@interface CommentViewController ()<DLStarRatingDelegate,CommentCellDeleagate,MWPhotoBrowserDelegate>
{
    CommentListRequest  *_commnetRequest;
    CheckUserCommentRequest *_checkRequest;
    PraiseRequest       *_praiseRequest;
    NSMutableArray      *_dataSource;
    NSMutableArray      *_photos;
    NSInteger           _currentIndex;
    NSInteger           _SegmentedIndex;
    UISegmentedControl  *_segmentedControl;
    
}
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexColor:@"f0f0f0" alpha:1];
    
    [self loadNavTitleView];
    _baseTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = UIColorFromRGB(245, 245, 245);
        [self.view addSubview:tableView];
        tableView;
    });
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self loadHeadView];
    
    _currentIndex = 1;
    _SegmentedIndex = 0;
    _dataSource = [[NSMutableArray alloc] init];
    [self loadData];
    WS(weakSelf);
    [self.baseTableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.isNext = YES;
        [weakSelf loadData];
    }];
}

- (void)dealloc{
    
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
    [HYLoadHubView dismiss];
    [_commnetRequest cancel];
    _commnetRequest = nil;
    
    [_praiseRequest cancel];
    _praiseRequest = nil;
    
    _baseTableView.delegate = nil;
    _baseTableView.dataSource = nil;
}

#pragma mark-- 加载视图
- (void)loadNavTitleView{
    
    NSArray *segArray = [[NSArray alloc] initWithObjects:@"全部评论",@"晒图", nil];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segArray];
    [_segmentedControl setFrame:CGRectMake(self.view.centerX - g_fitFloat(@[@(150),@(150),@(165)])/2, 26, g_fitFloat(@[@(150),@(150),@(165)]), 30)];
    _segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    _segmentedControl.tintColor = [UIColor colorWithHexString:@"0xb80000"];
    [_segmentedControl addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentedControl;
}

- (void)loadHeadView{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    aView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreen_Width - 15, 45)];
    [titleLabel setText:@"总体评价"];
    [titleLabel setBackgroundColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    titleLabel.userInteractionEnabled = YES;
    [aView addSubview:titleLabel];
    
    DLStarRatingControl *customNumberOfStars = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(80, 0, 100,45) andStars:5 isFractional:YES];
    customNumberOfStars.delegate = self;
    customNumberOfStars.userInteractionEnabled = NO;
    customNumberOfStars.backgroundColor = [UIColor clearColor];
    customNumberOfStars.rating = _businessInfo.AverageStars;
    [aView addSubview:customNumberOfStars];
    
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 50, 50)];
    [scoreLabel setText:[NSString stringWithFormat:@"%.1f",_businessInfo.AverageStars]];
    [scoreLabel setBackgroundColor:[UIColor clearColor]];
    [scoreLabel setFont:[UIFont systemFontOfSize:13]];
    [aView addSubview:scoreLabel];

    self.baseTableView.tableHeaderView = aView;
    
}

#pragma mark -- 数据请求
- (void)loadData{
 
    if (!_isNext) {
         [HYLoadHubView show];
    }
    
    [_commnetRequest cancel];
    _commnetRequest = nil;
   
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    _commnetRequest = [[CommentListRequest alloc] init];
    _commnetRequest.interfaceURL = [NSString stringWithFormat:@"%@/Merchants/Comments",BASEURL];
    _commnetRequest.httpMethod = @"GET";
    _commnetRequest.MerId = self.businessInfo.MerId;
    
    _commnetRequest.PageIndex   = _currentIndex;
    _commnetRequest.PageSize    = kDefaultPageSize;
    _commnetRequest.Type        = _SegmentedIndex;
    _commnetRequest.UserId      = userInfo.userId;
    
    WS(weakSelf);
    [_commnetRequest sendReuqest:^(id result, NSError *error)
     {
         NSArray  *objArray = nil;
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"Result"] intValue];
             if (code == 1) { //状态值为1 代表请求成功  其他喂失败
                 NSArray *DateArray = objDic[@"Data"];
                 
                 [CommentInfo setupObjectClassInArray:^NSDictionary *{
                     return @{@"pics" : @"CommentPhotoInfo"};
                 }];
                 
                 objArray  = [CommentInfo objectArrayWithKeyValuesArray:DateArray];
             }else{
                 [METoast toastWithMessage:@"获取评论信息失败"];
             }
         }else{
             [METoast toastWithMessage:@"获取评论信息失败"];
         }
         [weakSelf updateBusinessListData:objArray error:error];
         
     }];
}

//商家列表数据绑定
- (void)updateBusinessListData:(NSArray *)objArray error:(NSError *)error{
    
    
    [self.baseTableView.infiniteScrollingView stopAnimating];
    
    if (!_isNext) {
        [_dataSource removeAllObjects];
    }
    [_dataSource addObjectsFromArray:objArray];
    _currentIndex += 1;
    
    if (objArray.count < kDefaultPageSize) {
        [self.baseTableView setShowsInfiniteScrolling:NO];
        
    }else{
        [self.baseTableView setShowsInfiniteScrolling:YES];
    }
    
    WS(weakSelf);
    if (!_isNext) {
        [HYLoadHubView dismiss];
        [self.view configBlankPage:EaseBlankPageTypeNoCommentDate hasData:objArray.count > 0 hasError:error reloadButtonBlock:^(id sender) {
            [weakSelf loadData];
        }];
    }
    [self.baseTableView reloadData];
}

- (void)sendUserPraise:(CommentInfo *)commentInfo{

    [HYLoadHubView show];
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    
    [_praiseRequest cancel];
    _praiseRequest = nil;
    
    _praiseRequest = [[PraiseRequest alloc] init];
    _praiseRequest.interfaceURL = [NSString stringWithFormat:@"%@/Merchants/FavoritComment",BASEURL];
    //_praiseRequest.interfaceURL = [NSString stringWithFormat:@"%@",@"http://192.168.0.220:809/Merchants/FavoritComment"];
    _praiseRequest.httpMethod   = @"GET";
    _praiseRequest.CommentId    = commentInfo.com_id;
    _praiseRequest.UserId      = userInfo.userId;

    WS(weakSelf);
    [_praiseRequest sendReuqest:^(id result, NSError *error)
     {
        [HYLoadHubView dismiss];
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"Result"] intValue];
             if (code == 1) { //状态值为1 代表请求成功  其他喂失败
                 commentInfo.is_favorite = 0;
                 commentInfo.likes += 1;
                 [weakSelf.baseTableView reloadData];
              }else{
                 [METoast toastWithMessage:@"点赞失败"];
             }
         }else{
             [METoast toastWithMessage:@"点赞失败"];
         }
     }];

}

#pragma mark--tableView 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = (CommentCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return g_fitFloat(@[@6,@7,@8]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"CommentCell";
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    WS(weakSelf);
      [cell setPraisedBlock:^(CommentInfo *cInfo,UIButton *btn) {
          [btn setTitle:[NSString stringWithFormat:@"%@",@""] forState:UIControlStateNormal];
          [weakSelf sendUserPraise:cInfo];
      }];
    
    [cell bindDataWithCommentView:_dataSource[indexPath.section]];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}


#pragma mark--UISegmentedControlClick
- (void)segmentedAction:(UISegmentedControl *)seg{
    
    _SegmentedIndex = seg.selectedSegmentIndex;
    self.isNext = NO;
    _currentIndex = 1;
    [self.baseTableView setShowsInfiniteScrolling:YES];
    [_dataSource removeAllObjects];
    [self loadData];
}

#pragma mark--评分控件代理
-(void)newRating:(DLStarRatingControl *)control :(CGFloat)rating{

}

#pragma mark--CommentCellDeleagate
- (void)commentImageClick:(CommentInfo *)commentInfo index:(NSInteger)index{
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;

    for (CommentPhotoInfo *cpInfo in commentInfo.pics)
    {
        NSString *p = cpInfo.Url;
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:p]]];
    }
    
    _photos = photos;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.wantsFullScreenLayout = YES;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:YES];

}

#pragma mark - MWPhotoBrowserDelegate

#pragma mark 照片浏览器代理
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
