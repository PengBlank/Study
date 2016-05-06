//
//  HYLuckyWinnerCell.m
//  Teshehui
//
//  Created by HYZB on 15/3/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLuckyWinnerCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Addition.h"
#import "NSDate+Addition.h"

@interface HYLuckyWinnerCell ()
{
    UIImageView *_card1View;
    UIImageView *_card2View;
    UIImageView *_card3View;
    UIImageView *_card4View;
    UIImageView *_card5View;
    UIImageView *_prizeView;
    UIImageView *_ratingView;
    UIImageView *_lineView;
    
    UILabel *_nameLab;
    UILabel *_prizeLab;
    UILabel *_timeLab;
}

@end

@implementation HYLuckyWinnerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        _ratingView = [[UIImageView alloc] initWithFrame:TFRectMake(20, 10, 42, 14)];
        [self.contentView addSubview:_ratingView];
        
        _prizeLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(65, 10, 190, 14)];
        _prizeLab.textColor = [UIColor whiteColor];
        _prizeLab.backgroundColor = [UIColor clearColor];
        _prizeLab.font = [UIFont boldSystemFontOfSize:12];
        _prizeLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self addSubview:_prizeLab];
        
        _timeLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(20, 30, 80, 20)];
        _timeLab.textColor = [UIColor whiteColor];
        _timeLab.backgroundColor = [UIColor clearColor];
        _timeLab.font = [UIFont boldSystemFontOfSize:11];
        [self addSubview:_timeLab];
        
        _nameLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(96, 30, 144, 20)];
        _nameLab.textColor = [UIColor whiteColor];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.font = [UIFont systemFontOfSize:11];
        [self addSubview:_nameLab];
        
        _card1View = [[UIImageView alloc] initWithFrame:TFRectMake(20, 56, 24, 38)];
        [self.contentView addSubview:_card1View];
        
        _card2View = [[UIImageView alloc] initWithFrame:TFRectMake(48, 56, 24, 38)];
        [self.contentView addSubview:_card2View];
        
        _card3View = [[UIImageView alloc] initWithFrame:TFRectMake(76, 56, 24, 38)];
        [self.contentView addSubview:_card3View];
        
        _card4View = [[UIImageView alloc] initWithFrame:TFRectMake(104, 56, 24, 38)];
        [self.contentView addSubview:_card4View];
        
        _card5View = [[UIImageView alloc] initWithFrame:TFRectMake(132, 56, 24, 38)];
        [self.contentView addSubview:_card5View];

        _prizeView = [[UIImageView alloc] initWithFrame:TFRectMake(180, 40, 60, 60)];
        _prizeView.contentMode = UIViewContentModeScaleAspectFit,
        [self.contentView addSubview:_prizeView];
        
        _lineView = [[UIImageView alloc] initWithFrame:TFRectMake(15, 102.5, 230, 3.5)];
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
        _nameLab.text = name;
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:cardInfo.takeCardTime.longLongValue/1000];
        _timeLab.text = [date hoursDescription];
        
        if (cardInfo.prizes)
        {
            _prizeLab.text = cardInfo.prizes.prizeName;
            [_prizeView sd_setImageWithURL:[NSURL URLWithString:cardInfo.prizes.prizeImage]
                          placeholderImage:[UIImage imageNamed:@"url_image_loading"]];
            
            switch (cardInfo.prizes.prizeGrade.intValue)
            {
                case 1:
                    _ratingView.image = [UIImage imageNamed:@"kj_title7"];
                    break;
                case 2:
                    _ratingView.image = [UIImage imageNamed:@"kj_title8"];
                    break;
                case 3:
                    _ratingView.image = [UIImage imageNamed:@"kj_title9"];
                    break;
                case 4:
                    _ratingView.image = [UIImage imageNamed:@"kj_title10"];
                    break;
                case 5:
                    _ratingView.image = [UIImage imageNamed:@"kj_title11"];
                    break;
                case 6:
                    _ratingView.image = [UIImage imageNamed:@"kj_title12"];
                    break;
                default:
                    break;
            }
        }
        else
        {
            _prizeLab.text = nil;
            _prizeView.image = nil;
            _ratingView.image = nil;
        }
    }
}

@end
