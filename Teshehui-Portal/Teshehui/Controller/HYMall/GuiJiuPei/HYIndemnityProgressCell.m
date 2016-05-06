//
//  HYIndemnityProgressCell.m
//  Teshehui
//
//  Created by Fei Wang on 15-3-31.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYIndemnityProgressCell.h"
#import "UIImage+Addition.h"

@implementation HYIndemnityProgressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.textLabel.numberOfLines = 10;
        self.textLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(29, 0, 1, 12)];
        _topLine.backgroundColor = [UIColor colorWithWhite:0.82 alpha:1.0];
        [self.contentView addSubview:_topLine];
        
        _buttomLine = [[UIView alloc] initWithFrame:CGRectMake(29, 30, 1, 20)];
        _buttomLine.backgroundColor = [UIColor colorWithWhite:0.82 alpha:1.0];
        [self.contentView addSubview:_buttomLine];
        
        self.separatorLeftInset = 40;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = [self.progress.content sizeWithFont:[UIFont systemFontOfSize:14]
                                 constrainedToSize:CGSizeMake(TFScalePoint(280), 200)];
    
    self.textLabel.frame = CGRectMake(44, 11, size.width+4, size.height+2);
    self.detailTextLabel.frame = CGRectMake(44, size.height+20, 220, 20);
    
    self.imageView.frame = CGRectMake(22, 14, 15, 15);
    
    _buttomLine.frame = CGRectMake(29, 31, 1, self.frame.size.height-31);
}

#pragma mark setter/getter
- (void)setProgress:(HYMallGuijiupeiOrderLogItem *)progress
{
    if (progress != _progress)
    {
        _progress = progress;
        
        self.textLabel.text = progress.content;
        self.detailTextLabel.text = progress.createTime;
        self.imageView.image = [UIImage imageWithNamedAutoLayout:@"g_icon_2"];
    }
}

- (void)setIsFrist:(BOOL)isFrist
{
    if (isFrist != _isFrist)
    {
        _isFrist = isFrist;
        
        [_topLine setHidden:isFrist];
        
        self.textLabel.textColor = isFrist ? [UIColor colorWithRed:218.0/255.0
                                                             green:0
                                                              blue:0
                                                             alpha:1.0]:
                                            [UIColor colorWithWhite:0.5
                                                              alpha:1.0];
        
        NSString *imageName = isFrist ? @"g_icon_1" : @"g_icon_2";
        self.imageView.image = [UIImage imageWithNamedAutoLayout:imageName];
    }
}

@end
