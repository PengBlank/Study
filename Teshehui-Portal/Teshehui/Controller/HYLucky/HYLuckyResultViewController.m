//
//  HYLuckyResultViewController.m
//  Teshehui
//
//  Created by HYZB on 15/3/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLuckyResultViewController.h"
#import "UIImage+Addition.h"
#import "NSDate+Addition.h"
#import "UIImageView+WebCache.h"
#import "HYLuckyCheckOtherReq.h"
#import "HYUserInfo.h"

@interface HYLuckyResultViewController ()
{
    UIImageView *_bgView;
    UIImageView *_cardsBgView;
    UIImageView *_timeBgView;
    UIImageView *_timeView;
    
    UILabel *_createTimeLab;
    
    HYLuckyCheckOtherReq *_checkReq;
}

@property (nonatomic, strong) NSMutableArray *cardsSet;

@end

@implementation HYLuckyResultViewController

- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:rect];
    
    if (rect.size.height < 504)
    {
        view.contentSize = CGSizeMake(320, 504);
    }
    else
    {
        view.contentSize = rect.size;
    }
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    [self updateView];
    
    [self loadCardData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_checkReq cancel];
    _checkReq = nil;
    
    [HYLoadHubView dismiss];
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
- (void)loadCardData
{
    [HYLoadHubView show];
    
    _checkReq = [[HYLuckyCheckOtherReq alloc] init];
    _checkReq.version = kLotteryVersion;
    _checkReq.actType = @"getUserCards";
    _checkReq.lotteryCode = kLotteryCode;
    _checkReq.lotteryTypeCode = kLotteryTypeCode;
    _checkReq.ifSort = 0;
    _checkReq.page = 1;
    _checkReq.pageCount = 10;
    _checkReq.queryAll = @"1";
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    _checkReq.queryTime = [NSString stringWithFormat:@"%lf", (time*1000)];
    _checkReq.userId = [HYUserInfo getUserInfo].userId;
    
    __weak typeof(self) bself = self;
    [_checkReq sendReuqest:^(id result, NSError *error) {
        HYLuckyCheckOtherResp *resp = (HYLuckyCheckOtherResp *)result;
        [bself updateViewWithCheckResult:resp
                                   error:error];
    }];
}

- (void)updateViewWithCheckResult:(HYLuckyCheckOtherResp *)result
                            error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    if (!error)
    {
        self.selectCards = [result.items lastObject];
        [self updateView];
    }
}

- (void)initView
{
    self.title = @"抓一把好牌";
    
    if (!_bgView)
    {
        CGSize size = [(UIScrollView *)self.view contentSize];
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        _bgView.image = [UIImage imageWithNamedAutoLayout:@"lucky_bg_2"];
        [self.view addSubview:_bgView];
    }
    
    if (!_cardsBgView)
    {
        _cardsBgView = [[UIImageView alloc] initWithFrame:TFRectMake(20, 32, 280, 104)];
        _cardsBgView.image = [UIImage imageWithNamedAutoLayout:@"kj_pz2"];
        [self.view addSubview:_cardsBgView];
    }
    
    if (!_timeBgView)
    {
        _timeBgView = [[UIImageView alloc] initWithFrame:TFRectMake(0, 330, 320, 185)];
        _timeBgView.image = [UIImage imageWithNamedAutoLayout:@"kj_f03"];
        [self.view addSubview:_timeBgView];
    }

    if (!_timeView)
    {
        _timeView = [[UIImageView alloc] initWithFrame:TFRectMake(100, 10, 100, 70)];
        [_timeBgView addSubview:_timeView];
    }
    
    
    _createTimeLab = [[UILabel alloc] initWithFrame:TFRectMake(40, 269, 240, 22)];
    _createTimeLab.backgroundColor = [UIColor clearColor];
    _createTimeLab.font = [UIFont boldSystemFontOfSize:16];
    _createTimeLab.textAlignment = NSTextAlignmentCenter;
    _createTimeLab.textColor = [UIColor whiteColor];
    [self.view addSubview:_createTimeLab];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.selectCards.takeCardTime.longLongValue/1000];
    _createTimeLab.text = [NSString stringWithFormat:@"抓牌时间 %@", [date hoursDescription]];
    
    self.cardsSet = [[NSMutableArray alloc] init];
    
    for (HYLuckyCards *card in self.selectCards.cards)
    {
        NSString *str = [NSString stringWithFormat:@"%d", card.count];
        if (![self.cardsSet containsObject:str])
        {
            [self.cardsSet addObject:str];
        }
    }
    
    float offset = 200.0/51.0;
    int selectIndex = 0;
    for (int i=0; i<52; i++)
    {
        if ([self.cardsSet containsObject:[NSString stringWithFormat:@"%d", (i)]])
        {
            UIImageView *card = [[UIImageView alloc] initWithFrame:TFRectMake(20+selectIndex*56, 160, 53, 79)];
            NSString *name = [self.cardsSet objectAtIndex:selectIndex];
            card.image = [UIImage imageNamed:name];
            [self.view addSubview:card];
            selectIndex++;
        }
        else
        {
            UIImageView *card = [[UIImageView alloc] initWithFrame:TFRectMake(236-i*offset, 45, 48, 74)];
            card.image = [UIImage imageWithNamedAutoLayout:@"kj_small"];
            [self.view addSubview:card];
        }
    }
}

- (void)updateView
{
    if (self.luckyInfo.lotteryStatus.intValue==0)  //已开奖
    {
        if (self.selectCards.prizes)
        {
            _timeBgView.image = [UIImage imageWithNamedAutoLayout:@"kj_ok"];
            _timeView.frame = TFRectMake(100, 10, 100, 70);
            [_timeView sd_setImageWithURL:[NSURL URLWithString:self.selectCards.prizes.prizeImage]
                         placeholderImage:[UIImage imageNamed:@"url_image_loading"]];
            
            for (UIView *l in _timeBgView.subviews)
            {
                if ([l isKindOfClass:[UILabel class]])
                {
                    [l removeFromSuperview];
                }
            }
            
            UILabel *nameLab = [[UILabel alloc] initWithFrame:TFRectMake(60, 84, 180, 33)];
            nameLab.backgroundColor = [UIColor clearColor];
            nameLab.font = [UIFont boldSystemFontOfSize:TFScalePoint(13)];
            nameLab.textAlignment = NSTextAlignmentCenter;
            nameLab.textColor = [UIColor whiteColor];
            nameLab.numberOfLines = 2;
            nameLab.text = [NSString stringWithFormat:@"%@", self.selectCards.prizes.prizeName];
            [_timeBgView addSubview:nameLab];
        }
        else
        {
            _timeBgView.image = [UIImage imageWithNamedAutoLayout:@"kj_f03"];
            _timeView.frame = TFRectMake(70, 20, 173, 65);
            _timeView.image = [UIImage imageWithNamedAutoLayout:@"kj_m1"];
        }
    }
    else
    {
        _timeBgView.image = [UIImage imageWithNamedAutoLayout:@"kj_f03"];
        _timeView.frame = TFRectMake(51, 18, 201, 69);
        _timeView.image = [UIImage imageWithNamedAutoLayout:@"kj_f05"];
        
        for (UIView *l in _timeBgView.subviews)
        {
            if ([l isKindOfClass:[UILabel class]])
            {
                [l removeFromSuperview];
            }
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.luckyInfo.lotteryTime.longLongValue/1000];
        NSArray *times = [date timeFullSection];
        for (int i=0; i<[times count]; i++)
        {
            UILabel *timeLab = [[UILabel alloc] initWithFrame:TFRectMake(52+i*34, 55, 32, 22)];
            timeLab.backgroundColor = [UIColor clearColor];
            timeLab.font = [UIFont boldSystemFontOfSize:13];
            timeLab.textAlignment = NSTextAlignmentCenter;
            timeLab.textColor = [UIColor whiteColor];
            timeLab.text = times[i];
            timeLab.tag = i;
            [_timeBgView addSubview:timeLab];
        }
    }
}
@end
