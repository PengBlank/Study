//
//  HYLuckyHomeViewController.m
//  Teshehui
//
//  Created by HYZB on 15/3/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLuckyHomeViewController.h"
#import "UIImage+Addition.h"

#import "HYLuckyDrawViewController.h"
#import "HYLuckyResultViewController.h"
#import "HYLuckyWinnerViewController.h"
#import "HYLuckyRuleViewController.h"
#import "HYLuckyCardListViewController.h"
#import "HYLuckyPrizeView.h"
#import "HYLoadHubView.h"
#import "HYUserInfo.h"
#import "HYLuckyCheckStatusReq.h"
#import "HYLuckyPrizeReq.h"
#import "HYLuckyListReq.h"

#import "HYRPPasswordRecvViewController.h"
#import "HYRecvRetpacketViewController.h"

@interface HYLuckyHomeViewController ()<HYLuckyDrawViewControllerDelegate>
{
    UIScrollView *_contentView;
    UIImageView *_bgView;
    UIImageView *_bottomView;
    
    HYLuckyCheckStatusReq *_checkStatusReq;
    HYLuckyPrizeReq *_loadPrizeReq;
    HYLuckyListReq *_loadLuckyListReq;
}

@property (nonatomic, assign) NSInteger luckyCount;
@property (nonatomic, assign) NSInteger useLuckyCount;

@property (nonatomic, copy) NSString *alertMsg;
@property (nonatomic, strong) HYLuckyStatusInfo *currLuckyResult;
@property (nonatomic, strong) NSArray *prizesList;
@property (nonatomic, strong) HYLuckyInfo *curLukcy;

@property (nonatomic, strong) UIButton *myCardBtn;  //刷新显示

@end

@implementation HYLuckyHomeViewController

- (void)dealloc
{
    [_checkStatusReq cancel];
    _checkStatusReq = nil;
    
    [_loadPrizeReq cancel];
    _loadPrizeReq = nil;
    
    [_loadLuckyListReq cancel];
    _loadLuckyListReq = nil;
    
    [HYLoadHubView dismiss];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _luckyCount = 1;
    }
    
    return self;
}

- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self loadPrize];
    [self checkCurrentLuckyStatus];
    [self loadLuckyList:nil];
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

#pragma mark private methods
- (void)initView
{
    self.title = @"抓一票大的";
    
    _contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _contentView.contentSize = CGSizeMake(TFScalePoint(320), TFScalePoint(985));
    _contentView.backgroundColor = [UIColor colorWithRed:6.0/255.0
                                                   green:28.0/255.0
                                                    blue:70.0/255.0
                                                   alpha:1.0];
    [self.view addSubview:_contentView];
    
    _bgView = [[UIImageView alloc] initWithFrame:TFRectMake(0, 0, 320, 247)];
    _bgView.image = [UIImage imageWithNamedAutoLayout:@"kj_i_top"];
    [_contentView addSubview:_bgView];
    
    _bottomView = [[UIImageView alloc] initWithFrame:TFRectMake(0, 416, 320, 100)];
    _bottomView.image = [UIImage imageWithNamedAutoLayout:@"kj_i_bottom"];
    [_contentView addSubview:_bottomView];
    
    UIButton *myCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [myCardBtn setFrame:TFRectMake(19, 120, 113, 81)];
    [myCardBtn setImage:[UIImage imageWithNamedAutoLayout:@"kj_i2"]
               forState:UIControlStateNormal];
    [myCardBtn addTarget:self
                  action:@selector(checkMyCardAction:)
        forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:myCardBtn];
    _myCardBtn = myCardBtn;
    
    UIButton *gameRuleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [gameRuleBtn setFrame:TFRectMake(179, 120, 113, 81)];
    [gameRuleBtn setImage:[UIImage imageWithNamedAutoLayout:@"kj_i3"]
               forState:UIControlStateNormal];
    [gameRuleBtn addTarget:self
                    action:@selector(checkGameRule:)
        forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:gameRuleBtn];
    
    UIButton *checkOtherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkOtherBtn setFrame:TFRectMake(19, 230, 113, 81)];
    [checkOtherBtn setImage:[UIImage imageWithNamedAutoLayout:@"kj_i5"]
                 forState:UIControlStateNormal];
    [checkOtherBtn addTarget:self
                    action:@selector(checkOtherPlayer:)
          forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:checkOtherBtn];
    
    UIButton *winnerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [winnerBtn setFrame:TFRectMake(179, 230, 113, 81)];
    [winnerBtn setImage:[UIImage imageWithNamedAutoLayout:@"kj_i4"]
                   forState:UIControlStateNormal];
    [winnerBtn addTarget:self
                      action:@selector(checkWinner:)
            forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:winnerBtn];
    
    UIImageView *centerView = [[UIImageView alloc] initWithFrame:TFRectMake(0, 350, 320, 66)];
    centerView.image = [UIImage imageWithNamedAutoLayout:@"kj_i_bt"];
    [_contentView addSubview:centerView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:14.0];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"*本活动与苹果公司无关";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.frame)-10, 30)];
    label.frame = CGRectMake((_bottomView.frame.size.width- size.width-10)/2,
                             _bottomView.frame.size.height-20,
                             size.width,
                             size.height);
    label.textColor = [UIColor whiteColor];
    [_bottomView addSubview:label];
}

- (void)updatePrizeViews
{
    for (UIView *v in _contentView.subviews)
    {
        if ([v isKindOfClass:[HYLuckyPrizeView class]])
        {
            [v removeFromSuperview];
        }
    }
    
    int i = 0;
    CGFloat org_y = 0;
    for (HYLuckyPrize *prize in self.prizesList)
    {
        org_y = 440+i/2*145;
        CGRect frame = TFRectMake(18+i%2*150, org_y, 135, 148);
        HYLuckyPrizeView *v = [[HYLuckyPrizeView alloc] initWithFrame:frame];
        v.prize = prize;
        [_contentView addSubview:v];
        i++;
    }
    
    CGFloat heigh = TFScalePoint(org_y+250);
    if (heigh < self.view.frame.size.height)
    {
        heigh = self.view.frame.size.height;
    }
    
    _contentView.contentSize = CGSizeMake(TFScalePoint(320), TFScalePoint(heigh));
    _bottomView.frame = TFRectMake(0, heigh-100, 320, 100);
}

- (void)loadPrize
{
    [HYLoadHubView show];
    
    _loadPrizeReq = [[HYLuckyPrizeReq alloc] init];
    _loadPrizeReq.version = kLotteryVersion;
    _loadPrizeReq.actType = @"findLotteyPrizes";
    _loadPrizeReq.lotteryCode = kLotteryCode;
    _loadPrizeReq.page = @"1";
    _loadPrizeReq.pageSize = @"10";
    
    __weak typeof(self) bself = self;
    [_loadPrizeReq sendReuqest:^(id result, NSError *error) {
        [bself updatePrizeWithResult:(HYLuckyPrizeResp *)result
                               error:error];
    }];
}

- (void)updatePrizeWithResult:(HYLuckyPrizeResp *)resp
                        error:(NSError *)error
{
    [HYLoadHubView dismiss];
    self.prizesList = resp.prizeList;
    [self updatePrizeViews];
}

- (void)checkCurrentLuckyStatus
{
    [_checkStatusReq cancel];
    _checkStatusReq = nil;
    
    [HYLoadHubView show];
    
    HYUserInfo *user = [HYUserInfo getUserInfo];
    
    _checkStatusReq = [[HYLuckyCheckStatusReq alloc] init];
    _checkStatusReq.userId = user.userId;
    _checkStatusReq.version = kLotteryVersion;
    _checkStatusReq.actType = @"userLotteryRule";
    _checkStatusReq.lotteryCode = kLotteryCode;
    _checkStatusReq.lotteryTypeCode = kLotteryTypeCode;
    
    __weak typeof(self) bself = self;
    [_checkStatusReq sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        
        if (!error)
        {
            HYLuckyCheckStatusResp *resp = (HYLuckyCheckStatusResp *)result;
            bself.luckyCount = resp.lotteryNumber.integerValue;
            bself.useLuckyCount = resp.usedNumber.integerValue;
            bself.currLuckyResult = [resp.userCardList lastObject];
            bself.alertMsg = resp.alertMsg;
            [bself checkMyCardImage];
        }
    }];
}

- (void)loadLuckyList:(void (^)(void))refreshCallback
{
    [_loadLuckyListReq cancel];
    _loadLuckyListReq = nil;
    if (refreshCallback)
    {
        [HYLoadHubView show];
    }
    _loadLuckyListReq = [[HYLuckyListReq alloc] init];
    _loadLuckyListReq.version = kLotteryVersion;
    _loadLuckyListReq.lotteryCode = kLotteryCode;
    _loadLuckyListReq.lotteryTypeCode = kLotteryTypeCode;
    _loadLuckyListReq.actType = @"findLotteries";
    _loadLuckyListReq.lotteryStatus = @"1";
    _loadLuckyListReq.page = @"1";
    _loadLuckyListReq.pageSize = @"10";
    
    __weak typeof(self) bself = self;
    [_loadLuckyListReq sendReuqest:^(id result, NSError *error)
    {
        if (refreshCallback)
        {
            [HYLoadHubView dismiss];
        }
        if (!error)
        {
            bself.curLukcy = [[(HYLuckyListResp *)result luckyList] lastObject];
            if (refreshCallback)
            {
                refreshCallback();
            }
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:error.domain
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

- (void)checkMyCardAction:(id)sender
{
    __weak typeof(self) b_self = self;
    [self loadLuckyList:^(void)
    {
        [b_self checkMyCard];
    }];
}

- (void)checkMyCard
{
    if ((self.luckyCount-self.useLuckyCount) > 0)
    {
        HYLuckyDrawViewController *vc = [[HYLuckyDrawViewController alloc] init];
        vc.curLukcy = self.curLukcy;
        vc.delegate = self;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
    else if (self.currLuckyResult)
    {
        HYLuckyResultViewController *vc = [[HYLuckyResultViewController alloc] init];
        vc.selectCards = self.currLuckyResult;
        vc.luckyInfo = self.curLukcy;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:self.alertMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)checkGameRule:(id)sender
{
    HYLuckyRuleViewController *vc = [[HYLuckyRuleViewController alloc] init];
    vc.lukcy = self.curLukcy;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)checkOtherPlayer:(id)sender
{
    HYLuckyCardListViewController *vc = [[HYLuckyCardListViewController alloc] init];
    vc.mineCards = self.currLuckyResult;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)checkWinner:(id)sender
{
    HYLuckyWinnerViewController *vc = [[HYLuckyWinnerViewController alloc] init];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

#pragma mark - HYLuckyDrawViewControllerDelegate
- (void)didRecvCard:(HYLuckyStatusInfo *)lucky
{
    self.currLuckyResult = lucky;
    self.useLuckyCount++;
    [self checkMyCardImage];
}

- (void)didUpdateLuckyStatus
{
    [self checkCurrentLuckyStatus];
}

- (void)checkMyCardImage
{
    if (self.luckyCount > self.useLuckyCount)
    {
        [_myCardBtn setImage:[UIImage imageWithNamedAutoLayout:@"kj_i2"]
                   forState:UIControlStateNormal];
    }
    else if (self.currLuckyResult)
    {
        [_myCardBtn setImage:[UIImage imageWithNamedAutoLayout:@"kj_i2b"]
                    forState:UIControlStateNormal];
    }
    else
    {
        [_myCardBtn setImage:[UIImage imageWithNamedAutoLayout:@"kj_i2"]
                    forState:UIControlStateNormal];
    }
}

@end
