//
//  HYMallHomeHeaderView.m
//  Teshehui
//
//  Created by HYZB on 15/1/21.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeHeaderView.h"
#import "HYMallHomeItem.h"
#import "HYMallStoreInfo.h"
#import "UIImage+Addition.h"
#import "HYMallChannelItem.h"

@implementation HYMallHomeHeaderView

- (void)dealloc
{
    _adsView.delegate = nil;
    _adsView.dataSource = nil;
    [_adsView cleanTimer];
    _adsView = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _supportCarInsurance = YES;
        
//        CGRect adsRect = TFRectMake(0, 0, 320, 150);
        CGRect adsRect = self.bounds;
        _adsView = [[HYAdsScrollView alloc] initWithFrame:adsRect
                                          linePageControl:NO];
        _adsView.delegate = self;
        _adsView.dataSource = self;
        _adsView.autoScroll = YES;
        [self addSubview:_adsView];
    }
    
    return self;
}

- (void)setChannelBoard:(HYMallChannelBoard *)channelBoard
{
    if (_channelBoard != channelBoard) {
        _channelBoard = channelBoard;
        [self setAdsData:channelBoard.channelBannerList];
    }
}

- (void)setAdsData:(NSArray *)adsData
{
    if (adsData != _adsData)
    {
        _adsData = adsData;
        [_adsView reloadData];
    }
}

#pragma mark setter/getter
- (void)setSupportCarInsurance:(BOOL)supportCarInsurance
{
    if (supportCarInsurance != _supportCarInsurance)
    {
        _supportCarInsurance = supportCarInsurance;
        
        if (supportCarInsurance)
        {
            [_lastBtn setImage:[UIImage imageWithNamedAutoLayout:@"icon_car"]
                      forState:UIControlStateNormal];
            [_lastBtn setImage:[UIImage imageWithNamedAutoLayout:@"icon_car_on"]
                      forState:UIControlStateHighlighted];
            _lastBtn.tag = CarInsurance;
            _lastLab.text = @"阳光车险";
        }
        else
        {
            [_lastBtn setImage:[UIImage imageWithNamedAutoLayout:@"i_sh"]
                       forState:UIControlStateNormal];
            [_lastBtn setImage:[UIImage imageWithNamedAutoLayout:@"i_sh_on"]
                       forState:UIControlStateHighlighted];
            _lastBtn.tag = QRScanInfo;
            
            _lastLab.text = @"附近商户";
        }
    }
}

#pragma mark - HYAdsScrollViewDataSource
- (NSArray *)adsContents
{
    NSArray *adsList = nil;
    if ([self.adsData count] > 0)
    {
        NSMutableArray *muTempArray = [[NSMutableArray alloc] initWithCapacity:[self.adsData count]];
        for (id item in self.adsData)
        {
            if ([item isKindOfClass:[HYMallHomeItem class]])
            {
                HYMallHomeItem *homeItem = (HYMallHomeItem *)item;
                if (homeItem.pictureUrl)
                {
                    [muTempArray addObject:homeItem.pictureUrl];
                }
            }
            if ([item isKindOfClass:[HYMallChannelItem class]])
            {
                HYMallChannelItem *channelItem = (HYMallChannelItem *)item;
                if (channelItem.image)
                {
                    [muTempArray addObject:channelItem.image];
                }
                
            }
        }
        
        adsList = [muTempArray copy];
    }
    
    return adsList;
}

#pragma mark - HYAdsScrollViewDelegate
- (void)didClickAdsIndex:(NSInteger)index
{
    if (index < [self.adsData count])
    {
        [self.delegate didClickWithBoardType:self.boardType itemAtIndex:index];
    }
}

@end
