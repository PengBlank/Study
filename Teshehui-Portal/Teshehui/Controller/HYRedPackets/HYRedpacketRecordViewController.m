//
//  HYRedpacketRecordViewController.m
//  Teshehui
//
//  Created by HYZB on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRedpacketRecordViewController.h"
#import "HYRPRecordCell.h"
#import "HYRPRecordHeaderView.h"
#import "HYTableViewFooterView.h"
#import "HYRedpacketNullView.h"
#import "HYRecvRetpacketViewController.h"
#import "HYRedpacketDetailViewController.h"
#import "HYRPRecvDetailViewController.h"
#import "HYRPRecvFailedResultViewController.h"

#import "HYGetRedpacketListReq.h"
#import "HYGetRedpacketSendListReq.h"

@interface HYRedpacketRecordViewController ()
<
HYRPRecordHeaderViewDelegate
>
{
    HYGetRedpacketListReq *_getRecvReq;
    HYGetRedpacketSendListReq *_getSendReq;
    
    NSInteger _pageNumber;
    BOOL _isLoading;
    BOOL _isShowSend;
    BOOL _hasMore;
}

@property (nonatomic, strong) NSMutableArray *recvList;
@property (nonatomic, strong) NSMutableArray *sendList;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYRPRecordHeaderView *headerView;
@property (nonatomic, strong) UIView *loadMoreView;
@property (nonatomic, strong) HYRedpacketNullView *nullView;

@property (nonatomic, assign) NSInteger recvCount;
@property (nonatomic, assign) NSInteger recvPoint;
@property (nonatomic, assign) NSInteger sendCount;
@property (nonatomic, assign) NSInteger sendPoint;

/// 最下方的提示语
@property (nonatomic, strong) UILabel *tagLabel;

@end

@implementation HYRedpacketRecordViewController

- (void)dealloc
{
    [_getRecvReq cancel];
    _getRecvReq = nil;
    
    [_getSendReq cancel];
    _getSendReq = nil;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:254.0/255.0
                                           green:246.0/255.0
                                            blue:228.0/255.0
                                           alpha:1.0];
    self.view = view;
    
    frame.origin.x = TFScalePoint(18);
    frame.origin.y = 0;
    frame.size.width -= TFScalePoint(36);
    frame.size.height -= TFScalePoint(18);
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    [self.view addSubview:tableview];
    tableview.tableHeaderView = self.headerView;
    self.tableView = tableview;
    
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(frame), CGRectGetWidth(self.view.frame), TFScalePoint(18))];
    tagLabel.backgroundColor = [UIColor clearColor];
    tagLabel.textColor = [UIColor grayColor];
    tagLabel.text = @"收到的红包将存入您的现金券账户，可以商城购物使用。";
    tagLabel.font = [UIFont systemFontOfSize:11.0];
    tagLabel.textAlignment = NSTextAlignmentCenter;
    tagLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:tagLabel];
    self.tagLabel = tagLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"现金券红包";
    [self updateView];
    [self reloadRecordData];
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

#pragma mark setter/getter
- (UIView *)loadMoreView
{
    if (!_loadMoreView)
    {
        _loadMoreView = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0,
                                                                                0,
                                                                                self.view.frame.size.width,
                                                                                48)];
    }
    
    return _loadMoreView;
}

- (HYRedpacketNullView *)nullView
{
    if (!_nullView)
    {
        _nullView = [[HYRedpacketNullView alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          self.view.frame.size.width,
                                                                          108)];
    }
    
    return _nullView;
}

- (HYRPRecordHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[HYRPRecordHeaderView alloc] initWithFrame:TFRectMake(0, 0, 280, 237)];
        _headerView.delegate = self;
    }
    
    return _headerView;
}

#pragma mark private methods
- (void)updateView
{
    self.headerView.totalDescLab.text = @"收到现金券";
    self.headerView.countDescLab.text = @"收到红包";
    self.headerView.totalLab.text = @"0";
    self.headerView.countLab.text = @"0";
    self.tableView.tableFooterView = self.nullView;
}

- (void)loadRecordData
{
    if (!_isLoading)
    {
        _isLoading = YES;
        
        [HYLoadHubView show];
        
        if (_isShowSend)
        {
            _getSendReq = [[HYGetRedpacketSendListReq alloc] init];
            _getSendReq.page = _pageNumber;
            _getSendReq.num_per_page = 10;
            
            __weak typeof(self) bself = self;
            [_getSendReq sendReuqest:^(id result, NSError *error) {
                [bself updateViewWithGetResult:(HYGetRedpacketListResp *)result
                                         error:error];
            }];
        }
        else
        {
            _getRecvReq = [[HYGetRedpacketListReq alloc] init];
            _getRecvReq.page = _pageNumber;
            _getRecvReq.num_per_page = 10;
            
            __weak typeof(self) bself = self;
            [_getRecvReq sendReuqest:^(id result, NSError *error) {
                [bself updateViewWithGetResult:(HYGetRedpacketListResp *)result
                                         error:error];
            }];
        }
    }
}

- (void)reloadRecordData
{
    _pageNumber = 1;
    
    if (!_isShowSend)
    {
        self.recvList = [[NSMutableArray alloc] init];
    }
    else
    {
        self.sendList = [[NSMutableArray alloc] init];
    }
    
    [self loadRecordData];
}

//- (BOOL)hasMore
//{
//    return ((_isShowSend&&_sendHasMore) || (!_isShowSend&&_recvHasMore));
//}

- (void)loadMoreData
{
    if (_hasMore && !_isLoading)
    {
        _pageNumber++;
        [self loadRecordData];
    }
}

- (void)updateViewWithGetResult:(HYGetRedpacketListResp *)resp
                          error:(NSError *)error
{
    _isLoading = NO;
    [HYLoadHubView dismiss];
    _hasMore = resp.packetList.count > 0;
    
    
    if (!error)
    {
        if (!_isShowSend)
        {
            [self.recvList addObjectsFromArray:resp.packetList];
            
            if ([self.recvList count] > 0)
            {
                self.tableView.tableFooterView = nil;
                self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
            }
            else
            {
                self.nullView.descLab.text = @"你还没收到过红包哦,\n 赶快通知小伙伴么一起玩现金券红包吧";
                self.tableView.tableFooterView = self.nullView;
                self.tableView.contentInset = UIEdgeInsetsMake(10, 0, _nullView.frame.size.height, 0);
            }
            
            self.recvCount = resp.total_quantity;
            self.recvPoint = resp.total_points;
        }
        else
        {
            [self.sendList addObjectsFromArray:resp.packetList];
            if ([self.sendList count] > 0)
            {
                self.tableView.tableFooterView = nil;
                self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
            }
            else
            {
                self.nullView.descLab.text = @"你还没发过红包哦，赶快去发一个吧";
                self.tableView.tableFooterView = self.nullView;
                self.tableView.contentInset = UIEdgeInsetsMake(10, 0, _nullView.frame.size.height, 0);
            }
            
            self.sendCount = resp.total_quantity;
            self.sendPoint = resp.total_points;
        }
        
        [self updateHeaderView];
        [self.tableView reloadData];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - HYRPRecordHeaderViewDelegate
- (void)didSwitchRedpacketRecordType:(BOOL)isRecv
{
    _isShowSend = !isRecv;
    //[self.tableView reloadData];
    [self updateHeaderView];
    
    if (_isShowSend && _isLoading)
    {
        [_getSendReq cancel];
        _getSendReq = nil;
        _isLoading = NO;
    }
    else
    {
        [_getRecvReq cancel];
        _getRecvReq = nil;
        _isLoading = NO;
    }
    [self reloadRecordData];
}

- (void)updateHeaderView
{
    if (!_isShowSend)
    {
        self.headerView.countDescLab.text = @"收到红包";
        self.headerView.totalDescLab.text = @"收到现金券";
        
        self.headerView.totalLab.text = [NSString stringWithFormat:@"%ld", self.recvPoint];
        self.headerView.countLab.text = [NSString stringWithFormat:@"%ld", self.recvCount];
        
        self.tagLabel.text = @"收到的红包将存入您的现金券账户，可以商城购物使用。";
    }
    else
    {
        self.headerView.countDescLab.text = @"发出红包";
        self.headerView.totalDescLab.text = @"发出现金券";
        
        self.headerView.totalLab.text = [NSString stringWithFormat:@"%ld", self.sendPoint];
        self.headerView.countLab.text = [NSString stringWithFormat:@"%ld", self.sendCount];
        
        self.tagLabel.text = @"未被领取的红包将在48小时后返还到您的现金券账户！";
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isShowSend)
    {
        return [self.sendList count];
    }
    
    return [self.recvList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *orderStatusCellId = @"orderStatusCellId";
    HYRPRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:orderStatusCellId];
    if (!cell)
    {
        cell = [[HYRPRecordCell alloc]initWithStyle:UITableViewCellStyleValue1
                                     reuseIdentifier:orderStatusCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setIsSend:_isShowSend];
    
    HYRedpacketInfo *i = [self packetAtIndex:indexPath.row];
    [cell setRedpacket:i];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isShowSend)
    {
//        HYRedpacketInfo *packet = [self packetAtIndex:indexPath.row];
//        if (packet.status == RPStatusExpired || packet.is_luck)
//        {
//            return 75;
//        }
//        else
//        {
//            return 60;
//        }
        return 75;
    }
    return 75;
}

- (HYRedpacketInfo *)packetAtIndex:(NSInteger)idx
{
    if (_isShowSend)
    {
        if (idx < _sendList.count)
        {
            return [self.sendList objectAtIndex:idx];
        }
    }
    else
    {
        if (idx < _recvList.count)
        {
            return [_recvList objectAtIndex:idx];
        }
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *tempArr = self.recvList;
    if (_isShowSend)
    {
        tempArr = self.sendList;
    }
    
    if (indexPath.row < [tempArr count])
    {
        HYRedpacketInfo *rp = [tempArr objectAtIndex:indexPath.row];
        if (_isShowSend)    //发出的
        {
            HYRPRecvDetailViewController *vc = [[HYRPRecvDetailViewController alloc] init];
            //vc.redpacket = rp;
            vc.redpacketCode = rp.code;
            vc.isLuck = rp.is_luck;
            vc.isShowSend = _isShowSend;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
        else    //收到的
        {
            
            if (rp.status == RPStatusUnrecivie) //未领取的红包，使用老版本的领红包界面
            {
                HYRecvRetpacketViewController *vc = [[HYRecvRetpacketViewController alloc] init];
                vc.redpacket = rp;
                vc.redpacketRecvCallback = ^(BOOL success)
                {
                    [self reloadRecordData];
                };
                [self.navigationController pushViewController:vc
                                                     animated:YES];
            }
            else
            {
                HYRPRecvDetailViewController *vc = [[HYRPRecvDetailViewController alloc] init];
                //vc.redpacket = rp;
                vc.redpacketCode = rp.code;
                vc.isLuck = rp.is_luck;
                vc.isShowSend = _isShowSend;
                [self.navigationController pushViewController:vc
                                                     animated:YES];
            }
           /*
            if (rp.is_luck)
            {
                HYRPRecvDetailViewController *vc = [[HYRPRecvDetailViewController alloc] init];
                vc.redpacketCode = rp.code;
                vc.isLuck = rp.is_luck;
                vc.isShowSend = _isShowSend;
                [self.navigationController pushViewController:vc
                                                     animated:YES];
            }
            else    //普通红包
            {
                if (rp.status == RPStatusUnrecivie)
                {
                    
                }
                else if (rp.status == RPStatusReceived)
                {
                    HYRedpacketDetailViewController *vc = [[HYRedpacketDetailViewController alloc] initWithNibName:@"HYRedpacketDetailViewController" bundle:nil];
                    vc.redpacket = rp;
                    [self.navigationController pushViewController:vc
                                                         animated:YES];
                }
                else if(rp.status == RPStatusExpired)   //过期的普通红包
                {
                    HYRPRecvFailedResultViewController *vc = [[HYRPRecvFailedResultViewController alloc] initWithNibName:@"HYRPRecvFailedResultViewController" bundle:nil];
                    vc.redpacket = rp;
                    vc.redpacket.recv_status = RPRecvExpired;
                    [self.navigationController pushViewController:vc
                                                           animated:YES];
                }
            }*/
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //加载更多
    if (scrollView.contentSize.height >= scrollView.frame.size.height)
    {
        float scrollOffset = scrollView.contentOffset.y;
        float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (scrollOffset >= maximumOffset)
        {
            [self loadMoreData];
        }
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
    lineCell.separatorLeftInset = 0.0f;
}

@end
