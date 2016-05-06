//
//  HYMallLogisticsTrackViewController.m
//  Teshehui
//
//  Created by HYZB on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallLogisticsTrackViewController.h"
#import "HYOrderTrackRequest.h"

#import "HYMallLogisticsTrackCell.h"
#import "HYNullView.h"
#import "HYLoadHubView.h"
#import "HYMallExpressItem.h"

@interface HYMallLogisticsTrackViewController ()
{
    HYOrderTrackRequest *_trackReq;
    
    UILabel *_expressLabel;
    UILabel *_expressNOLabel;
    UILabel *_userNameLabel;
    UILabel *_addressLabel;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYNullView *nullView;
@property (nonatomic, strong) HYMallLogisticsInfo *logistics;

@end

@implementation HYMallLogisticsTrackViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_trackReq cancel];
    _trackReq = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"查看物流";
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                           green:237.0/255.0
                                            blue:237.0/255.0
                                           alpha:1.0];
    self.view = view;

    frame.size.height -= 100;
    frame.origin.y += 100;
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    [self.view addSubview:tableview];
	self.tableView = tableview;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 70)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    _expressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,10,230,20)];
    _expressLabel.backgroundColor = [UIColor clearColor];
    _expressLabel.textColor = [UIColor blackColor];
    _expressLabel.font = [UIFont systemFontOfSize:14.0f];
    [headerView addSubview:_expressLabel];
    
    _expressNOLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 42, 230, 16)];
    _expressNOLabel.backgroundColor = [UIColor clearColor];
    _expressNOLabel.textColor = [UIColor blackColor];
    _expressNOLabel.font = [UIFont systemFontOfSize:14.0f];
    [headerView addSubview:_expressNOLabel];
    
//    _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 52,200, 16)];
//    _userNameLabel.backgroundColor = [UIColor clearColor];
//    _userNameLabel.textColor = [UIColor whiteColor];
//    _userNameLabel.font = [UIFont systemFontOfSize:14.0f];
//    [headerView addSubview:_userNameLabel];
//    
//    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, frame.size.width-30, 30)];
//    _addressLabel.backgroundColor = [UIColor clearColor];
//    _addressLabel.textColor = [UIColor whiteColor];
//    _addressLabel.font = [UIFont systemFontOfSize:14.0f];
//    _addressLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    _addressLabel.numberOfLines = 2;
//    [headerView addSubview:_addressLabel];
    
    [self.view addSubview:headerView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self reloadAllTrackInfo];
}

#pragma mark - private methods
- (void)reloadAllTrackInfo
{
    [HYLoadHubView show];
    
    _trackReq = [[HYOrderTrackRequest alloc] init];
    _trackReq.order_code = self.orderCode;
    
    __weak typeof(self) b_self = self;
    [_trackReq sendReuqest:^(id result, NSError *error) {
        
        HYMallLogisticsInfo *logistics = nil;
        if (!error && [result isKindOfClass:[HYOrderTrackResponse class]])
        {
            logistics = [(HYOrderTrackResponse *)result trackInfo];
        }
        
        [b_self updateViewWith:logistics error:error];
    }];
}

- (void)updateViewWith:(HYMallLogisticsInfo *)logistics error:(NSError *)error
{
    [HYLoadHubView dismiss];
  
    _expressLabel.text = [NSString stringWithFormat:@"快递公司: %@",logistics.expressName];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:_expressLabel.text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 5)];
    _expressLabel.attributedText = attrStr;
    
    _expressNOLabel.text = [NSString stringWithFormat:@"快递单号: %@",logistics.expressNo];
    attrStr = [[NSMutableAttributedString alloc]initWithString:_expressNOLabel.text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 5)];
    _expressNOLabel.attributedText = attrStr;
    
    NSString *adds = logistics.address.consignee;
    if (logistics.address.consignee) {
        adds = [NSString stringWithFormat:@"收件人:%@", logistics.address.consignee];
    }
    _userNameLabel.text = adds;
    _addressLabel.text = logistics.address.fullAddress;
    
    if (!logistics || [logistics.trackList count] <= 0)
    {
        self.tableView.hidden = YES;
        self.nullView.hidden = NO;
        
        if (error)
        {
            _nullView.descInfo = error.domain;
        }
        else
        {
            _nullView.descInfo = @"暂无物流追踪记录";
        }
    }
    else
    {
        self.logistics = logistics;
        
        _nullView.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }
}

#pragma mark setter/getter
- (HYNullView *)nullView
{
    if (!_nullView)
    {
        CGRect frame = self.view.frame;
        frame.size.height -= 80;
        frame.origin = CGPointMake(0, 80);
        
        _nullView = [[HYNullView alloc] initWithFrame:frame];
        _nullView.needTouch = NO;
        [self.view addSubview:_nullView];
    }
    
    return _nullView;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.logistics.trackList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *logisticsTrackCellId = @"logisticsTrackCellId";
    HYMallLogisticsTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:logisticsTrackCellId];
    if (!cell)
    {
        cell = [[HYMallLogisticsTrackCell alloc]initWithStyle:UITableViewCellStyleValue1
                                               reuseIdentifier:logisticsTrackCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (indexPath.row < [self.logistics.trackList count])
    {
        HYMallExpressItem *track = [self.logistics.trackList objectAtIndex:indexPath.row];
        [cell setTrackInfo:track];
    }
    
    
    [cell setIsLastInfo:(indexPath.row == 0)];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow -1)
    {
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.row < [self.logistics.trackList count])
    {
        HYMallExpressItem *track = [self.logistics.trackList objectAtIndex:indexPath.row];
        height = track.contentHeight + 40;
    }
    
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
