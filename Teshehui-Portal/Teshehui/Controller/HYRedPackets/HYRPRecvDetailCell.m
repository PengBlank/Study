//
//  HYRPRecvDetailCell.m
//  Teshehui
//
//  Created by HYZB on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRPRecvDetailCell.h"

@interface HYRPRecvDetailCell ()
{
    UILabel *_pointLab;
    UILabel *_timeLab;
    UILabel *_statusLab;
}

@end

@implementation HYRPRecvDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        self.textLabel.font = [UIFont systemFontOfSize:16];
        
        _pointLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 110, 5, 100, 20)];
        _pointLab.textColor = [UIColor redColor];
        _pointLab.backgroundColor = [UIColor clearColor];
        _pointLab.textAlignment = NSTextAlignmentRight;
        _pointLab.font = [UIFont systemFontOfSize:16];
        _pointLab.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_pointLab];
        
        _timeLab = [[UILabel alloc] initWithFrame: CGRectMake(CGRectGetWidth(self.frame) - 170, 30, 160, 20)];
        _timeLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _timeLab.backgroundColor = [UIColor clearColor];
        _timeLab.textAlignment = NSTextAlignmentRight;
        _timeLab.font = [UIFont systemFontOfSize:14];
        _timeLab.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_timeLab];
        
        _statusLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 100, 50, 90, 20)];
        _statusLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _statusLab.backgroundColor = [UIColor clearColor];
        _statusLab.textAlignment = NSTextAlignmentRight;
        _statusLab.font = [UIFont systemFontOfSize:14];
        _statusLab.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_statusLab];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(10, 0, 200, 40);
}

#pragma mark setter/getter
- (void)setRecv:(HYRedpacketRecv *)recv
{
    if (recv != _recv)
    {
        _recv = recv;
        
        self.textLabel.text = recv.title;
        _timeLab.text = recv.get_time;
        _pointLab.text = [NSString stringWithFormat:@"%d现金券", recv.total_amount];
    }
}

@end
