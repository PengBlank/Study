//
//  HYMineInfoCell.m
//  Teshehui
//
//  Created by HYZB on 15/2/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMineInfoCell.h"

@implementation HYMineInfoCell
{
    UILabel *_redCountLab;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.textLabel.font = [UIFont systemFontOfSize:17.0f];
        self.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.textColor = [UIColor colorWithWhite:.9 alpha:1];
        self.hiddenLine = NO;
        
        UIImage *arrIcon = [UIImage imageNamed:@"cell_indicator"];
        UIImageView *arrView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-10 - 7, self.frame.size.height/2 - 6, 7, 12)];
        arrView.image = arrIcon;
        arrView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:arrView];
        _indicator = arrView;
        
        _redPointView = [[UIImageView alloc] initWithFrame:CGRectMake(154, 20, 7, 7)];
        _redPointView.image = [UIImage imageNamed:@"h_icon3"];
        [self.contentView addSubview:_redPointView];
        _redPointView.hidden = YES;
        
        _intent = NO;
    }
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _hasNew = NO;
    _redPointView.hidden = YES;
    _intent = NO;
    _indicator.transform = CGAffineTransformIdentity;
//    _redCountLab.hidden = YES;
    [self setRedCount:0];
}

#pragma mark setter/getter
- (void)setHasNew:(BOOL)hasNew
{
    if (hasNew != _hasNew)
    {
        _hasNew = hasNew;
    }
    [_redPointView setHidden:!hasNew];
}

- (void)setRedCount:(NSInteger)redCount
{
    if (_redCount != redCount)
    {
        _redCount = redCount;
        
        if (redCount == 0)
        {
            _redCountLab.hidden = YES;
        }
        else
        {
            if (!_redCountLab) {
                _redCountLab = [[UILabel alloc] init];
                _redCountLab.backgroundColor = [UIColor redColor];
                _redCountLab.textAlignment = NSTextAlignmentCenter;
                _redCountLab.textColor = [UIColor whiteColor];
                _redCountLab.font = [UIFont systemFontOfSize:12.0];
                [self.contentView addSubview:_redCountLab];
            }
            _redCountLab.text = [NSString stringWithFormat:@"%ld", (long)redCount];
            [_redCountLab sizeToFit];
            [self.textLabel sizeToFit];
            _redCountLab.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame) + 10,
                                            CGRectGetHeight(self.frame)/2-_redCountLab.frame.size.height/2,
                                            MAX(15, _redCountLab.frame.size.width),
                                            _redCountLab.frame.size.height);
            _redCountLab.layer.cornerRadius = _redCountLab.frame.size.height/2;
            _redCountLab.layer.masksToBounds = YES;
            _redCountLab.hidden = NO;
        }
    }
}

- (void)setExpand:(BOOL)expand
{
    if (_expand != expand)
    {
        _expand = expand;
        if (expand)
        {
            _indicator.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
        else
        {
            _indicator.transform = CGAffineTransformIdentity;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_intent)
    {
        CGRect frame = self.imageView.frame;
        CGFloat offset = 20 - frame.size.width/2;
        frame.origin.x += offset;
        self.imageView.frame = frame;
        
        frame = self.textLabel.frame;
        frame.origin.x += offset;
        self.textLabel.frame = frame;
    }
    
    CGRect frame = self.detailTextLabel.frame;
    frame.origin.x -= 10;
    self.detailTextLabel.frame = frame;
}

@end
