//
//  HYRPRecordCell.m
//  Teshehui
//
//  Created by HYZB on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRPRecordCell.h"
#import "UIImage+Addition.h"

@interface HYRPRecordCell ()
{
    UILabel *_pointLab;
    UILabel *_timeLab;
    UILabel *_countLab;
    
    UIButton *_actionBtn;
    UIImageView *_exprieIcon;
}
@end

@implementation HYRPRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        self.textLabel.font = [UIFont systemFontOfSize:14];
        
        _actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 80, 5, 80, 27)];
        _actionBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_actionBtn setBackgroundImage:[[UIImage imageNamed:@"t_jilu_chai"] stretchableImageWithLeftCapWidth:16 topCapHeight:0] forState:UIControlStateNormal];
        [_actionBtn setTitleColor:[UIColor colorWithRed:253.0/255.0
                                                 green:236.0/255.0
                                                  blue:53.0/255.0
                                                  alpha:1.0]
                         forState:UIControlStateNormal];
        _actionBtn.userInteractionEnabled = NO;
        [_actionBtn setTitle:@"拆红包" forState:UIControlStateNormal];
        _actionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_actionBtn];
        
        _pointLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-100, 5, 100, 25)];
        _pointLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _pointLab.backgroundColor = [UIColor clearColor];
        _pointLab.textAlignment = NSTextAlignmentRight;
        _pointLab.font = [UIFont systemFontOfSize:16];
        _pointLab.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_pointLab];
        
        _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 160, 33, 160, 20)];
        _timeLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _timeLab.backgroundColor = [UIColor clearColor];
        _timeLab.textAlignment = NSTextAlignmentRight;
        _timeLab.font = [UIFont systemFontOfSize:16];
        _timeLab.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_timeLab];
        
        _countLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 100, 55, 100, 20)];
        _countLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _countLab.backgroundColor = [UIColor clearColor];
        _countLab.textAlignment = NSTextAlignmentRight;
        _countLab.font = [UIFont systemFontOfSize:16];
        _countLab.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_countLab];
        
        _exprieIcon = [[UIImageView alloc] initWithFrame:CGRectMake(80,
                                                                    6,
                                                                    66,
                                                                    66)];
        _exprieIcon.image = [UIImage imageNamed:@"redpacket_expire"];
        [self.contentView addSubview:_exprieIcon];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame)-100, 16)];
    self.textLabel.frame = CGRectMake(0, 14, size.width, size.height);
    _pointLab.frame = CGRectMake(CGRectGetWidth(self.frame)-100, 5, 100, 25);
//    _luckIcon.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame), CGRectGetMinY(self.textLabel.frame), 17, 17);
}

#pragma mark setter/getter
- (void)setRedpacket:(HYRedpacketInfo *)redpacket
{
    //if (redpacket != _redpacket)
    {
        _redpacket = redpacket;

        
        
        
        if (self.isSend)
        {
            [_actionBtn setHidden:YES];
            _pointLab.hidden = NO;
            
            if (redpacket.is_luck)
            {
                self.textLabel.text = @"拼手气红包";
            }
            else
            {
                self.textLabel.text = @"普通红包";
                self.imageView.image = nil;
            }
            
            _pointLab.text = [NSString stringWithFormat:@"%d现金券", redpacket.total_amount];
            _timeLab.text = redpacket.created;
            
            _countLab.text = [NSString stringWithFormat:@"%ld/%ld个", redpacket.luck_quantuty_used,redpacket.luck_quantity];
            
            if (redpacket.luck_quantuty_used < redpacket.luck_quantity &&
                redpacket.status == RPStatusExpired)
            {
                _exprieIcon.hidden = NO;
            }
            else
            {
                _exprieIcon.hidden = YES;
            }
        }
        else
        {
            
            if (redpacket.status == RPStatusExpired) {
                _exprieIcon.hidden = NO;
            }
            else {
                _exprieIcon.hidden = YES;
            }
            
            self.textLabel.text = redpacket.title;
            
            if (redpacket.is_luck)  //这里果哥说，特令红包在我的接收里面无法判断是否已领完，所以只判断是否过期
            {
                if (redpacket.status == RPStatusExpired)
                {
                    [_actionBtn setHidden:YES];
                    _pointLab.hidden = NO;
                    _pointLab.text = [NSString stringWithFormat:@"%d现金券", redpacket.total_amount];
                    _countLab.text = @"已过期";
                }
                else
                {
                    [_actionBtn setHidden:YES];
                    _pointLab.hidden = NO;
                    _pointLab.text = [NSString stringWithFormat:@"%d现金券", redpacket.total_amount];
                    _countLab.text = @"已领取";
                }
            }   //普通红包分三种情况
            else
            {
                //前两种显示现金券数，隐藏领取按钮，未领取状态则显示领取按钮
                if (redpacket.status == RPStatusReceived)
                {
                    [_actionBtn setHidden:YES];
                    _pointLab.hidden = NO;
                    _pointLab.text = [NSString stringWithFormat:@"%d现金券", redpacket.total_amount];
                    _countLab.text = @"已领取";
                }
                else if(redpacket.status == RPStatusExpired) //已过期
                {
                    [_actionBtn setHidden:YES];
                    _pointLab.hidden = NO;
                    _pointLab.text = [NSString stringWithFormat:@"%d现金券", redpacket.total_amount];
                    _countLab.text = @"已过期";
                }
                else if (redpacket.status == RPStatusUnrecivie)
                {
                    _pointLab.hidden = YES;
                    [_actionBtn setHidden:NO];
                    _countLab.text = @"未领取";
                }
            }
            
            _timeLab.text = redpacket.created;
        }
    }
}


@end
