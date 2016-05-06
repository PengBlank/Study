//
//  HYRPOtherListViewController.m
//  Teshehui
//
//  Created by apple on 15/3/15.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRPOtherListViewController.h"
#import "HYRPRecvDetailViewController.h"
#import "HYRPRecvDetailCell.h"
#import "UIImage+Addition.h"
#import "HYUserInfo.h"
#import "HYRPCodeGenerateViewController.h"
#import "HYRedPacketNormalSendViewController.h"
#import "HYGetRedpacketDetailReq.h"

@interface HYRPOtherListViewController ()
{
    HYGetRedpacketDetailReq *_getDetailReq;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSArray *recvList;
@end

@implementation HYRPOtherListViewController

- (void)dealloc
{
    [_getDetailReq cancel];
    _getDetailReq = nil;
    
    [HYLoadHubView dismiss];
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    //    view.backgroundColor = [UIColor colorWithRed:254.0/255.0
    //                                           green:246.0/255.0
    //                                            blue:228.0/255.0
    //                                           alpha:1.0];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    [self.view addSubview:tableview];
    self.tableView = tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"现金券红包";
    [self loadRedpacketDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark setter/getter
- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:TFRectMake(0, 0, 320, 164)];
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:TFRectMake(0, 0, 320, 164)];
        bgView.image = [UIImage imageNamed:@"t_check_top"];
        [_headerView addSubview:bgView];
        
        UILabel *descLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(60,
                                                                             TFScalePoint(14),
                                                                             200,
                                                                             20)];
        descLab.textColor = [UIColor blackColor];
        descLab.backgroundColor = [UIColor clearColor];
        descLab.textAlignment = NSTextAlignmentCenter;
        descLab.font = [UIFont systemFontOfSize:18];
        
        NSString *displayName = self.packetDetail.title;
        NSString *nameStr = [NSString stringWithFormat:@"%@", displayName];
        NSMutableAttributedString *nameAttr = [[NSMutableAttributedString alloc] initWithString:nameStr];
        [nameAttr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithRed:253.0/255.0
                                               green:236.0/255.0
                                                blue:53.0/255.0
                                               alpha:1.0]
                         range:NSMakeRange(0, displayName.length)];
        descLab.attributedText = nameAttr;
        
        CGSize size = [nameStr sizeWithFont:descLab.font constrainedToSize:descLab.frame.size];
        
        CGRect frame = descLab.frame;
        frame.size.width = size.width+4;
        frame.origin.x = (_headerView.frame.size.width-(size.width+4))/2;
        descLab.frame = frame;
        
        [_headerView addSubview:descLab];
        
        //特令标记
        CGFloat org_x = descLab.frame.origin.x+size.width+4;
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(org_x,
                                                                              TFScalePoint(14),
                                                                              TFScalePoint(17),
                                                                              TFScalePoint(17))];
        iconView.image = [UIImage imageWithNamedAutoLayout:@"t_check_lin"];
        [_headerView addSubview:iconView];
        
        UILabel *pointLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(60,
                                                                              TFScalePoint(50),
                                                                              200,
                                                                              40)];
        pointLab.textColor = [UIColor blackColor];
        pointLab.backgroundColor = [UIColor clearColor];
        pointLab.textAlignment = NSTextAlignmentCenter;
        pointLab.font = [UIFont boldSystemFontOfSize:34];
        pointLab.text = [NSString stringWithFormat:@"%d现金券", self.packetDetail.total_amount];
        [_headerView addSubview:pointLab];
    }
    
    return _headerView;
}

#pragma mark private methods
- (void)loadRedpacketDetail
{
    [HYLoadHubView show];
    _getDetailReq = [[HYGetRedpacketDetailReq alloc] init];
    _getDetailReq.code = self.redpacketCode;
    
    __weak typeof(self) bself = self;
    [_getDetailReq sendReuqest:^(id result, NSError *error) {
        [bself updateGetRedDetailResult:(HYGetRedpacketDetailResp *)result
                                  error:error];
    }];
}

- (void)updateGetRedDetailResult:(HYGetRedpacketDetailResp *)resp error:(NSError *)error
{
    [HYLoadHubView dismiss];
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        self.recvList = resp.recvList;
        self.packetDetail = resp.redpacket;
        self.tableView.tableHeaderView = self.headerView;
        
        [self.tableView reloadData];
    }
}

- (void)continueShare
{
    HYRPCodeGenerateViewController *vc = [[HYRPCodeGenerateViewController alloc] init];
    vc.packetInfo = self.packetDetail;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)sendAnother
{
    HYRedpacketRecv *recv = nil;
    if (self.recvList.count > 0)
    {
        recv = [self.recvList objectAtIndex:0];
    }
    HYRedPacketNormalSendViewController *vc = [[HYRedPacketNormalSendViewController alloc] initWithNibName:@"HYRedPacketNormalSendViewController" bundle:nil];
    vc.mob_phone = recv.phone_mob;
    vc.name = recv.title;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)returnRedpacket:(UIButton *)btn
{
    HYRedPacketNormalSendViewController *vc = [[HYRedPacketNormalSendViewController alloc] initWithNibName:@"HYRedPacketNormalSendViewController" bundle:nil];
    vc.name = self.packetDetail.send_user_name;
    vc.mob_phone = self.packetDetail.phone_mob;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recvList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *orderStatusCellId = @"orderStatusCellId";
    HYRPRecvDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:orderStatusCellId];
    if (!cell)
    {
        cell = [[HYRPRecvDetailCell alloc]initWithStyle:UITableViewCellStyleValue1
                                        reuseIdentifier:orderStatusCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row < [self.recvList count])
    {
        HYRedpacketRecv *i = [self.recvList objectAtIndex:indexPath.row];
        [cell setRecv:i];
    }
    
    cell.statusLab.hidden = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    head.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:251/255.0 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 290, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0];
    
    if (self.packetDetail)
    {
        NSString *display = [NSString stringWithFormat:@"共%ld个红包, 已领取%ld个", self.packetDetail.luck_quantity, self.packetDetail.luck_quantuty_used];
        label.text = display;
    }
    
    
    [head addSubview:label];
    
    return head;
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
    CGFloat height = 55;
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
