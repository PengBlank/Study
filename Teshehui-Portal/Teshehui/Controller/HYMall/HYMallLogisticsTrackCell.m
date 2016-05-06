//
//  HYMallLogisticsTrackCell.m
//  Teshehui
//
//  Created by HYZB on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallLogisticsTrackCell.h"

@implementation HYMallLogisticsTrackCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.textLabel.numberOfLines = 2;
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(30, 8, self.frame.size.width-40, self.trackInfo.contentHeight+2);
    self.detailTextLabel.frame = CGRectMake(self.frame.size.width-150, self.trackInfo.contentHeight+10, 140, 16);
    
    if (self.isLastInfo)
    {
        self.textLabel.textColor = [UIColor colorWithRed:37.0/255.0
                                                   green:163.0/255.0
                                                    blue:79.0/255.0
                                                   alpha:1.0];
        self.detailTextLabel.textColor = [UIColor colorWithRed:37.0/255.0
                                                         green:163.0/255.0
                                                          blue:79.0/255.0
                                                         alpha:1.0];
    }
    else
    {
        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        self.detailTextLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    }
}

#pragma mark setter/getter
- (void)setTrackInfo:(HYMallExpressItem *)trackInfo
{
    if (trackInfo != _trackInfo)
    {
        _trackInfo = trackInfo;
        
        self.textLabel.text = trackInfo.context;
        self.detailTextLabel.text = trackInfo.time;
    }
}

- (void)setIsLastInfo:(BOOL)isLastInfo
{
    if (isLastInfo != _isLastInfo)
    {
        _isLastInfo = isLastInfo;
        
        [self setNeedsLayout];
    }
}

@end
