//
//  HYLuckyDrawViewController.m
//  Teshehui
//
//  Created by HYZB on 15/3/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLuckyDrawViewController.h"
#import "UIImage+Addition.h"
#import <AudioToolbox/AudioToolbox.h>
#import "HYLuckySendCardsReq.h"
#import "HYUserInfo.h"
#import "NSDate+Addition.h"
#import "METoast.h"

@interface HYLuckyDrawViewController ()<UIAlertViewDelegate>
{
    HYLuckySendCardsReq *_selectReq;
    UIImageView *_bgView;
    UIImageView *_cardsBgView;
    UIImageView *_timeBgView;
    UIImageView *_timeView;
    
    UILabel *_createTimeLab;
    
    int _index;
    SystemSoundID sound;
}

@property (nonatomic, strong) NSMutableArray *animationViews;
@property (nonatomic, strong) NSMutableArray *selectViews;
@property (nonatomic, strong) NSMutableArray *timeLabs;
@property (nonatomic, strong) NSMutableArray *cardsSet;

@end

@implementation HYLuckyDrawViewController

- (void)dealloc
{
    
}

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
    [self sendCards];
    
    [self performSelector:@selector(selectCards)
               withObject:nil
               afterDelay:1.4];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_selectReq cancel];
    _selectReq = nil;
    
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

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark private methods
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
        _timeView = [[UIImageView alloc] initWithFrame:TFRectMake(51, 18, 201, 69)];
        _timeView.image = [UIImage imageWithNamedAutoLayout:@"kj_f05"];
        [_timeBgView addSubview:_timeView];
    }
    
    _createTimeLab = [[UILabel alloc] initWithFrame:TFRectMake(40, 269, 240, 22)];
    _createTimeLab.backgroundColor = [UIColor clearColor];
    _createTimeLab.font = [UIFont boldSystemFontOfSize:16];
    _createTimeLab.textAlignment = NSTextAlignmentCenter;
    _createTimeLab.textColor = [UIColor whiteColor];
    [self.view addSubview:_createTimeLab];
    
    if (!_timeLabs)
    {
        _timeLabs = [[NSMutableArray alloc] init];
    }
    
    for (int i=0; i<6; i++)
    {
        UILabel *timeLab = [[UILabel alloc] initWithFrame:TFRectMake(54+i*33, 55, 30, 22)];
        timeLab.backgroundColor = [UIColor clearColor];
        timeLab.font = [UIFont boldSystemFontOfSize:13];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.textColor = [UIColor whiteColor];
        timeLab.tag = i;
        [_timeLabs addObject:timeLab];
        [_timeBgView addSubview:timeLab];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(self.curLukcy.lotteryTime.longLongValue/1000)];
    NSArray *times = [date timeFullSection];
    
    for (int i=0; i<[times count]; i++)
    {
        if (i < [self.timeLabs count])
        {
            UILabel *l = self.timeLabs[i];
            l.text = times[i];
        }
    }
}

- (void)sendCards
{
    [HYLoadHubView show];
    
    if (!_animationViews)
    {
        _animationViews = [[NSMutableArray alloc] init];
    }
    
    for (int i=0; i<52; i++)
    {
        UIImageView *card = [[UIImageView alloc] initWithFrame:TFRectMake(38, 45, 48, 74)];
        card.image = [UIImage imageWithNamedAutoLayout:@"kj_small"];
        card.tag = 51-i;    //image的tag是51-0
        [_animationViews addObject:card];
        [self.view addSubview:card];
    }
    
    for(UIView *myview in _animationViews)
        [self performSelector:@selector(aniForsendcards:)
                   withObject:myview
                   afterDelay:0.5];
}

-(void)aniForsendcards:(UIView *)myview//出牌动画
{
    float offset = 200.0/51.0;

    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:.9f];
    [UIView setAnimationRepeatAutoreverses:NO];
    myview.frame = TFRectMake(236-myview.tag*offset, 45, 48, 74);
    
    [UIView setAnimationTransition:UIViewAnimationTransitionNone
                           forView:myview
                             cache:YES];
    [UIView commitAnimations];
}

- (void)selectCards
{
    HYUserInfo *user = [HYUserInfo getUserInfo];
    _selectReq = [[HYLuckySendCardsReq alloc] init];
    _selectReq.userId = user.userId;
    _selectReq.version = kLotteryVersion;
    _selectReq.actType = @"dealUserCard";
    _selectReq.lotteryCode = kLotteryCode;
    _selectReq.lotteryTypeCode = kLotteryTypeCode;
    _selectReq.cardCount = 5;
    
    __weak typeof(self) bself = self;
    [_selectReq sendReuqest:^(id result, NSError *error) {
        HYLuckySendCardsResp *resp = (HYLuckySendCardsResp *)result;
        [bself updateWithCardsInfo:resp
                             error:error];
    }];
    
    /*
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    while ([tempArr count] < 5)
    {
        int index = rand()%52;
        HYLuckyCards *card = [[HYLuckyCards alloc] init];
        card.count = index;
        [tempArr addObject:card];
    }
    
    [self showSelectCards:tempArr];
     */
}

- (void)updateWithCardsInfo:(HYLuckySendCardsResp *)resp
                      error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    if (!error)
    {
        if ([self.delegate respondsToSelector:@selector(didRecvCard:)])
        {
            HYLuckyStatusInfo *lucky = [[HYLuckyStatusInfo alloc] init];
            lucky.takeCardTime = resp.takeCardTime;
            lucky.cards = resp.cardsList;
            [self.delegate didRecvCard:lucky];
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:(resp.takeCardTime.longLongValue/1000)];
        _createTimeLab.text = [NSString stringWithFormat:@"抓牌时间 %@", [date hoursDescription]];
        
        [self showSelectCards:resp.cardsList];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(didUpdateLuckyStatus)])
        {
            [self.delegate didUpdateLuckyStatus];
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:error.domain
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)showSelectCards:(NSArray *)cards
{
    self.cardsSet = [[NSMutableArray alloc] init];
    
    for (HYLuckyCards *card in cards)
    {
        NSString *str = [NSString stringWithFormat:@"%d", card.count];
        if (![self.cardsSet containsObject:str])
        {
            [self.cardsSet addObject:str];
        }
    }
    
    DebugNSLog(@"self.cardsSet %@", self.cardsSet);
    //self.cardsSet = [NSMutableArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", nil];
    //self.cardsSet = [NSMutableArray arrayWithObjects:@"51", @"50", @"49", @"48", @"47", nil];
    
    
    _selectViews = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (UIImageView *myview in self.animationViews)
    {
        if ([self.cardsSet containsObject:[NSString stringWithFormat:@"%ld", (myview.tag)]])
        {
            myview.tag = i;
            myview.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(didTapView:)];
            [myview addGestureRecognizer:tap];
            
            [self.selectViews addObject:myview];
            i++;
        }
    }
    
    _index = 0;
    UIView *v = [self.selectViews objectAtIndex:_index];
    [self performSelector:@selector(selectCardsAnimation:)
               withObject:v
               afterDelay:0.5];
    
    [self playSendSound];
}

- (void)selectCardsAnimation:(UIView *)myview
{
//    [self playSelectSound];
    _index++;
    [UIView beginAnimations:@"animationID1" context:nil];
    [UIView setAnimationDuration:.3f];
    [UIView setAnimationDelegate:self];
    myview.frame = TFRectMake(20+myview.tag*56, 160, 53, 79);
    [UIView setAnimationDidStopSelector:@selector(animationFinished:)];
    [UIView commitAnimations];
}

- (void)animationFinished:(UIView *)myview
{
    if (_index < [self.selectViews count])
    {
        UIView *v = [self.selectViews objectAtIndex:_index];
        [self performSelector:@selector(selectCardsAnimation:)
                   withObject:v];
    }
}

- (void)didTapView:(UIGestureRecognizer *)sender
{
    [self playOpenSound];
    UIImageView *tapView = (UIImageView *)sender.view;
    tapView.userInteractionEnabled = NO;
    
    [UIView beginAnimations:@"flipAnimation" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:tapView
                             cache:YES];
    
    NSString *name = [self.cardsSet objectAtIndex:tapView.tag];
    tapView.image = [UIImage imageNamed:name];//[UIImage imageWithNamedAutoLayout:@"kj_pz2"];
    
    [UIView commitAnimations];
}

- (void)playSendSound
{
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"audio_deal_card"
                                              withExtension:@"wav"];
    if (soundURL) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,&sound);
        
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            sound = 0;
        }
        
        AudioServicesPlaySystemSound(sound);
    }
}

- (void)playOpenSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"audio_out_card" ofType:@"wav"];
    NSURL *soundURL = [NSURL URLWithString:path];
    if (soundURL) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,&sound);
        
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            sound = 0;
        }
        
        AudioServicesPlaySystemSound(sound);
    }
}

- (void)playSelectSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"desk_player_fold" ofType:@"caf"];
    NSURL *soundURL = [NSURL URLWithString:path];
    if (soundURL) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,&sound);
        
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            sound = 0;
        }
        
        AudioServicesPlaySystemSound(sound);
    }
}

@end
