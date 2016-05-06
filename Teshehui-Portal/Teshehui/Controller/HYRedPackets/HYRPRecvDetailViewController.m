//
//  HYRPRecvDetailViewController.m
//  Teshehui
//
//  Created by HYZB on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRPRecvDetailViewController.h"
#import "HYRPRecvDetailCell.h"
#import "UIImage+Addition.h"
#import "HYUserInfo.h"
#import "HYRPCodeGenerateViewController.h"
#import "HYRedPacketNormalSendViewController.h"

#import "HYGetRedpacketDetailReq.h"
#import "HYLuckPacketCreateViewController.h"

@interface HYRPRecvDetailViewController ()
{
    HYGetRedpacketDetailReq *_getDetailReq;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSArray *recvList;

@end

@implementation HYRPRecvDetailViewController

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
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 18, 0);
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
        
        //发的红包
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
        
//        if (self.isLuck)
//        {
//            CGFloat org_x = descLab.frame.origin.x+size.width+4;
//            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(org_x,
//                                                                                  TFScalePoint(14),
//                                                                                  TFScalePoint(17),
//                                                                                  TFScalePoint(17))];
//            iconView.image = [UIImage imageNamed:@"t_check_lin"];
//            [_headerView addSubview:iconView];
//        }
        
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
        
        if (self.isShowSend)
        {
            UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.view.frame)-18, CGRectGetWidth(self.view.frame)-20, 18)];
            tagLabel.backgroundColor = [UIColor clearColor];
            tagLabel.textColor = [UIColor grayColor];
            tagLabel.text = @"未被领取的红包将在48小时后返还到您的现金券账户！";
            tagLabel.font = [UIFont systemFontOfSize:11.0];
            tagLabel.textAlignment = NSTextAlignmentCenter;
            tagLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [self.view addSubview:tagLabel];
        }
            /*
            if (_packetDetail.status == RPStatusExpired)
            {
                UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 80)];
                foot.backgroundColor = [UIColor clearColor];
                
                UIImage *btn = [[UIImage imageNamed:@"redpacket_index_btn.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 22)];
                UIImage *btn_d = [[UIImage imageNamed:@"redpacket_index_btn_d.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 22)];
                UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, CGRectGetWidth(foot.frame)-30, 40)];
                [shareBtn setBackgroundImage:btn forState:UIControlStateNormal];
                [shareBtn setBackgroundImage:btn_d forState:UIControlStateHighlighted];
                [shareBtn setTitle:@"已过期" forState:UIControlStateNormal];
                [shareBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:247/255.0 blue:107/255.0 alpha:1] forState:UIControlStateNormal];
                shareBtn.titleLabel.font = [UIFont boldSystemFontOfSize:24.0];
                shareBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                //[shareBtn addTarget:self action:@selector(continueShare) forControlEvents:UIControlEventTouchUpInside];
                shareBtn.enabled = NO;
                [foot addSubview:shareBtn];
                
                self.tableView.tableFooterView = foot;
            }
            else if (_packetDetail.luck_quantuty_used < _packetDetail.luck_quantity) //没领完
            {
                /// 不再继续分享
                 UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 80)];
                 foot.backgroundColor = [UIColor clearColor];
                 
                 UIImage *btn = [[UIImage imageNamed:@"redpacket_index_btn.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 22)];
                 UIImage *btn_d = [[UIImage imageNamed:@"redpacket_index_btn_d.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 22)];
                 UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, CGRectGetWidth(foot.frame)-30, 40)];
                 [shareBtn setBackgroundImage:btn forState:UIControlStateNormal];
                 [shareBtn setBackgroundImage:btn_d forState:UIControlStateHighlighted];
                 [shareBtn setTitle:@"继续分享" forState:UIControlStateNormal];
                 [shareBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:247/255.0 blue:107/255.0 alpha:1] forState:UIControlStateNormal];
                 shareBtn.titleLabel.font = [UIFont boldSystemFontOfSize:24.0];
                 shareBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                 [shareBtn addTarget:self action:@selector(continueShare) forControlEvents:UIControlEventTouchUpInside];
                 [foot addSubview:shareBtn];
                 
                 self.tableView.tableFooterView = foot;
            }
        }
        else    //收到的，只可能是特令红包
        {
            /// 不再有回赠
            UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 80)];
            foot.backgroundColor = [UIColor clearColor];
            
            UIImage *btn = [[UIImage imageNamed:@"redpacket_index_btn.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 22)];
            UIImage *btn_d = [[UIImage imageNamed:@"redpacket_index_btn_d.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 22)];
            UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, CGRectGetWidth(foot.frame)-30, 40)];
            [shareBtn setBackgroundImage:btn forState:UIControlStateNormal];
            [shareBtn setBackgroundImage:btn_d forState:UIControlStateHighlighted];
            [shareBtn setTitle:@"回赠一个" forState:UIControlStateNormal];
            [shareBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:247/255.0 blue:107/255.0 alpha:1] forState:UIControlStateNormal];
            shareBtn.titleLabel.font = [UIFont boldSystemFontOfSize:24.0];
            shareBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [shareBtn addTarget:self action:@selector(returnRedpacket:) forControlEvents:UIControlEventTouchUpInside];
            [foot addSubview:shareBtn];
            
            self.tableView.tableFooterView = foot;
        }
        */
            
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
    HYLuckPacketCreateViewController *vc = [[HYLuckPacketCreateViewController alloc] initWithNibName:@"HYLuckPacketCreateViewController" bundle:nil];
    vc.randomLucky = NO;
    vc.title = @"发红包";
    [self.navigationController pushViewController:vc animated:YES];
    /**
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
     */
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
    
    if (self.isLuck)
    {
        cell.statusLab.hidden = YES;
    }
    else
    {
        cell.statusLab.hidden = NO;
        if (self.recvList.count > 0)
        {
            HYRedpacketRecv *recv = [self.recvList objectAtIndex:0];
            NSString *str = nil;
            if (recv.status == RPStatusExpired)
            {
                str = @"已过期";
            }
            else if (recv.status == RPStatusReceived)
            {
                str = @"已领取";
            }
            else if (recv.status == RPStatusUnrecivie)
            {
                str = @"未领取";
            }
            cell.statusLab.text = str;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    head.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:251/255.0 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width/2, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0];
    
    if (self.packetDetail)
    {
        NSString *display = [NSString stringWithFormat:@"已领取%ld/%ld", self.packetDetail.luck_quantuty_used, self.packetDetail.luck_quantity];
        label.text = display;
    }
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectZero];
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [UIFont systemFontOfSize:14.0];
    if (self.packetDetail) {
        NSString *display = [NSString stringWithFormat:@"共%ld/%d现金券", self.packetDetail.luck_amount_used, self.packetDetail.total_amount];
        label2.text = display;
        [label2 sizeToFit];
        label2.frame = CGRectMake(head.frame.size.width-15-label2.frame.size.width,
                                  head.frame.size.height/2-label2.frame.size.height/2,
                                  label2.frame.size.width,
                                  label2.frame.size.height);
    }
    
    [head addSubview:label2];
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
    CGFloat height = _isLuck ? 55 : 75;
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
