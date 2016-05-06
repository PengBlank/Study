//
//  HYLuckyCardCell.m
//  Teshehui
//
//  Created by HYZB on 15/3/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLuckyCardCell.h"
#import "UIImage+Addition.h"
#import "NSDate+Addition.h"

@interface HYLuckyCardCell ()
{
    UIImageView *_card1View;
    UIImageView *_card2View;
    UIImageView *_card3View;
    UIImageView *_card4View;
    UIImageView *_card5View;
    UIImageView *_lineView;
    
    UILabel *_nameInfoLab;
    UILabel *_cardTypeLab;
    UILabel *_timeLab;
}
@end

@implementation HYLuckyCardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        _card1View = [[UIImageView alloc] initWithFrame:TFRectMake(10, 11, 24, 38)];
        _card1View.image = [UIImage imageNamed:@"1"];
        [self.contentView addSubview:_card1View];
        
        _card2View = [[UIImageView alloc] initWithFrame:TFRectMake(38, 11, 24, 38)];
        _card2View.image = [UIImage imageNamed:@"1"];
        [self.contentView addSubview:_card2View];
        
        _card3View = [[UIImageView alloc] initWithFrame:TFRectMake(66, 11, 24, 38)];
        _card3View.image = [UIImage imageNamed:@"1"];
        [self.contentView addSubview:_card3View];
        
        _card4View = [[UIImageView alloc] initWithFrame:TFRectMake(94, 11, 24, 38)];
        _card4View.image = [UIImage imageNamed:@"1"];
        [self.contentView addSubview:_card4View];
        
        _card5View = [[UIImageView alloc] initWithFrame:TFRectMake(122, 11, 24, 38)];
        _card5View.image = [UIImage imageNamed:@"1"];
        [self.contentView addSubview:_card5View];
        
        _nameInfoLab = [[UILabel alloc] initWithFrame:TFRectMake(150, 8, 154, 20)];
        _nameInfoLab.textColor = [UIColor whiteColor];
        _nameInfoLab.backgroundColor = [UIColor clearColor];
        _nameInfoLab.font = [UIFont systemFontOfSize:14];
        _nameInfoLab.text = @"张三* 8*** 8888";
        [self addSubview:_nameInfoLab];
        
        _timeLab = [[UILabel alloc] initWithFrame:TFRectMake(150, 30, 160, 20)];
        _timeLab.textColor = [UIColor whiteColor];
        _timeLab.backgroundColor = [UIColor clearColor];
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.text = @"00:00:00";
        [self addSubview:_timeLab];
        
        _lineView = [[UIImageView alloc] initWithFrame:TFRectMake(15, 56.5, 230, 3.5)];
        _lineView.image = [UIImage imageWithNamedAutoLayout:@"kj_tm_line"];
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark setter/getter
- (void)setCardInfo:(HYLuckyStatusInfo *)cardInfo
{
    if (cardInfo != _cardInfo)
    {
        _cardInfo = cardInfo;
        
        if ([cardInfo.cards count] >= 5)
        {
            HYLuckyCards *c1 = _cardInfo.cards[0];
            _card1View.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", c1.count]];
            HYLuckyCards *c2 = _cardInfo.cards[1];
            _card2View.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", c2.count]];
            HYLuckyCards *c3 = _cardInfo.cards[2];
            _card3View.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", c3.count]];
            HYLuckyCards *c4 = _cardInfo.cards[3];
            _card4View.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", c4.count]];
            HYLuckyCards *c5 = _cardInfo.cards[4];
            _card5View.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", c5.count]];
        }
        
        NSString *str = cardInfo.userRealName ? cardInfo.userRealName : cardInfo.userName;
        
        NSMutableString *name = [[NSMutableString alloc] initWithString:str];
        
        if (cardInfo.userMembershipNum)
        {
            [name appendFormat:@"  %@",cardInfo.userMembershipNum];
        }
        
        _nameInfoLab.text = name;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:cardInfo.takeCardTime.longLongValue/1000];
        _timeLab.text = [date hoursDescription];
        
        switch (cardInfo.cardRules.intValue)
        {
            case 0:
//                _cardTypeLab.text = 
                break;
                
            default:
                break;
        }
        
        /*
          0:散牌；1:1对；2:两对；3:三条；4:顺子；5:同花；6:葫芦；7:四条；8:同花顺
         */
    }
}

@end
