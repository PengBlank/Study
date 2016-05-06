//
//  HYMasterTableViewCell.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-8.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYMasterTableViewCell.h"

@interface HYMasterTableViewCell ()

@property (nonatomic, strong) UIImageView *indicatorImg;

@end

@implementation HYMasterTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_contentLabel];
        
        self.indicatorImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_right"]];
        CGPoint center = CGPointMake(CGRectGetWidth(self.frame)-20, CGRectGetHeight(self.frame)/2);
        self.indicatorImg.center = center;
        self.indicatorImg.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:self.indicatorImg];
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0/255.0 green:172/255.0 blue:238/255.0 alpha:1];
        
        self.icon = [[UIImageView alloc] init];
        [self.contentView addSubview:_icon];
        
        self.separatorLeftInset = 6;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame;
    frame = CGRectMake(27, 0, CGRectGetWidth(self.frame)-40, CGRectGetHeight(self.frame));
    _contentLabel.frame = frame;
    
    frame = _icon.frame;
    frame.size = _icon.image.size;
    frame.origin.x = 6;
    frame.origin.y = CGRectGetHeight(self.frame) / 2 - frame.size.height/2;
    _icon.frame = frame;
    
    [self setIsExpandable:self.isExpandable];
    [self setIsExpanded:self.isExpanded];
}

- (void)setIsExpanded:(BOOL)isExpanded
{
    [super setIsExpanded:isExpanded];
    [UIView animateWithDuration:.5 animations:^{
        if (isExpanded)
        {
            self.indicatorImg.transform = CGAffineTransformMakeRotation(M_PI/2);
        } else {
            self.indicatorImg.transform = CGAffineTransformIdentity;
        }
    }];
//    if (isExpanded)
//    {
//        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:172/255.0 blue:238/255.0 alpha:1];
//    }
//    else
//    {
//        self.backgroundColor = [UIColor clearColor];
//    }
}

- (void)setIsExpandable:(BOOL)isExpandable
{
    [super setIsExpandable:isExpandable];
    if (isExpandable)
    {
        self.indicatorImg.hidden = NO;
    } else {
        self.indicatorImg.hidden = YES;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [UIView animateWithDuration:.3 animations:^
    {
        if (selected)
        {
            self.backgroundColor = [UIColor colorWithRed:0/255.0 green:172/255.0 blue:238/255.0 alpha:1];
        }
        else
        {
            self.backgroundColor = [UIColor clearColor];
        }
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
