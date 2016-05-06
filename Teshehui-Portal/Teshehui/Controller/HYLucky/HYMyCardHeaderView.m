//
//  HYMyCardHeaderView.m
//  Teshehui
//
//  Created by HYZB on 15/3/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMyCardHeaderView.h"
#import "UIImage+Addition.h"
#import "NSDate+Addition.h"

@interface HYMyCardHeaderView ()
{
    UIImageView *_card1View;
    UIImageView *_card2View;
    UIImageView *_card3View;
    UIImageView *_card4View;
    UIImageView *_card5View;
    UIImageView *_lineView;
    
    UILabel *_nameInfoLab;
    UILabel *_timeLab;
}

@end

@implementation HYMyCardHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _card1View = [[UIImageView alloc] initWithFrame:TFRectMake(41, 41, 24, 38)];
        _card1View.image = [UIImage imageNamed:@"kj_small"];
        [self addSubview:_card1View];
        
        _card2View = [[UIImageView alloc] initWithFrame:TFRectMake(69, 41, 24, 38)];
        _card2View.image = [UIImage imageNamed:@"kj_small"];
        [self addSubview:_card2View];
        
        _card3View = [[UIImageView alloc] initWithFrame:TFRectMake(97, 41, 24, 38)];
        _card3View.image = [UIImage imageNamed:@"kj_small"];
        [self addSubview:_card3View];
        
        _card4View = [[UIImageView alloc] initWithFrame:TFRectMake(125, 41, 24, 38)];
        _card4View.image = [UIImage imageNamed:@"kj_small"];
        [self addSubview:_card4View];
        
        _card5View = [[UIImageView alloc] initWithFrame:TFRectMake(153, 41, 24, 38)];
        _card5View.image = [UIImage imageNamed:@"kj_small"];
        [self addSubview:_card5View];
        
        _nameInfoLab = [[UILabel alloc] initWithFrame:TFRectMake(186, 41, 104, 20)];
        _nameInfoLab.textColor = [UIColor whiteColor];
        _nameInfoLab.backgroundColor = [UIColor clearColor];
        _nameInfoLab.textAlignment = NSTextAlignmentLeft;
        _nameInfoLab.font = [UIFont boldSystemFontOfSize:16];
        _nameInfoLab.text = @"我";
        [self addSubview:_nameInfoLab];
        
        _timeLab = [[UILabel alloc] initWithFrame:TFRectMake(186, 64, 104, 20)];
        _timeLab.textColor = [UIColor whiteColor];
        _timeLab.backgroundColor = [UIColor clearColor];
        _timeLab.font = [UIFont systemFontOfSize:14];
        _timeLab.text = @"00:00:00";
        [self addSubview:_timeLab];
    }
    
    return self;
}

#pragma mark setter/getter
- (void)setMineCards:(HYLuckyStatusInfo *)mineCards
{
    if (mineCards != _mineCards)
    {
        _mineCards = mineCards;
        
        if (mineCards)
        {
            if ([mineCards.cards count] >= 5)
            {
                HYLuckyCards *c1 = mineCards.cards[0];
                _card1View.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", c1.count]];
                HYLuckyCards *c2 = mineCards.cards[1];
                _card2View.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", c2.count]];
                HYLuckyCards *c3 = mineCards.cards[2];
                _card3View.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", c3.count]];
                HYLuckyCards *c4 = mineCards.cards[3];
                _card4View.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", c4.count]];
                HYLuckyCards *c5 = mineCards.cards[4];
                _card5View.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", c5.count]];
            }
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:mineCards.takeCardTime.longLongValue/1000];
            _timeLab.text = [date hoursDescription];
        }
        else
        {
            _card1View.image = [UIImage imageNamed:@"kj_small"];
            _card2View.image = [UIImage imageNamed:@"kj_small"];
            _card3View.image = [UIImage imageNamed:@"kj_small"];
            _card4View.image = [UIImage imageNamed:@"kj_small"];
            _card5View.image = [UIImage imageNamed:@"kj_small"];
        }
        
    }
}
@end
