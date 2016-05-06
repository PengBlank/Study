//
//  HYMallMailHotRecommendCell.m
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallMainHotRecommendCell.h"
#import "UIImageView+WebCache.h"
#import "HYMallHomeItem.h"

@interface HYMallMainHotRecommendCell ()
{
    UIImageView *_leftView;
    UIImageView *_rightView;
}
@end

@implementation HYMallMainHotRecommendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        CGRect frame = [[UIScreen mainScreen] bounds];
        
        self.hiddenLine = YES;
        _leftView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0, frame.size.width/2-3, TFScalePoint(82))];
        [self.contentView addSubview:_leftView];
        
        _rightView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2+1, 0, frame.size.width/2-3, TFScalePoint(82))];
        [self.contentView addSubview:_rightView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(didClickCheckDetail:)];
        [self addGestureRecognizer:tap];
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

#pragma mark - private methods
- (void)didClickCheckDetail:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(checkProductDetail:board:)])
    {
        CGPoint touchPoint = [sender locationInView: self];
        
        int index = (int)touchPoint.x/(int)(self.frame.size.width/2);
        
        if (index < [self.hotScale count])
        {
            HYMallHomeItem *item = [self.hotScale objectAtIndex:index];
            [self.delegate checkBannerItem:item withBoard:nil];
        }
    }
}

#pragma mark setter/getter
- (void)setHotScale:(NSArray *)hotScale
{
    if (hotScale != _hotScale)
    {
        _hotScale = hotScale;
        
        for (int i=0; i<2&&i<[hotScale count]; i++)
        {
            HYMallHomeItem *item = [hotScale objectAtIndex:i];
            if (i == 0)
            {
                [_leftView sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                          placeholderImage:nil];
            }
            else
            {
                [_rightView sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                           placeholderImage:nil];
            }
        }
    }
}

@end
