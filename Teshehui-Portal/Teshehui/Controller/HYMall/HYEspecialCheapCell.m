//
//  HYEspecialCheapCell.m
//  Teshehui
//
//  Created by Kris on 15/7/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYEspecialCheapCell.h"
#import "HYAdsScrollView.h"
#import "HYMallHomeItem.h"
#import "UIImageView+WebCache.h"

@interface HYEspecialCheapCell ()
{
    HYAdsScrollView *_adsView;
    
    UIImageView *_leftView;
    UIImageView *_middleView;
    UIImageView *_rightView;
    UIImageView *_video;
    
    UILabel *_leftLab;
    UILabel *_middleLab;
    UILabel *_rightLab;
    
    UILabel *_leftPriceLab;
    UILabel *_middlePriceLab;
    UILabel *_rightPriceLab;
}

@end

@implementation HYEspecialCheapCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGRect frame = [[UIScreen mainScreen] bounds];
        CGRect top_h_line_rect = CGRectMake(0, 0, frame.size.width, 1);
        CGRect middle_h_line_rect = CGRectMake(0, 34, frame.size.width, 1);
        CGRect l_v_rect= CGRectMake(1, 35, (frame.size.width-8)/3, (frame.size.width-8)/3);
        CGRect m_v_rect = CGRectMake((frame.size.width-8)/3+3, 35, (frame.size.width-8)/3, (frame.size.width-8)/3);
        CGRect r_v_rect = CGRectMake((frame.size.width-8)/3*2+4, 35, (frame.size.width-8)/3, (frame.size.width-8)/3);
        CGRect v_line1_rect = CGRectMake((frame.size.width-8)/3+2, 35, 1, TFScalePoint(138));
        CGRect v_line2_rect = CGRectMake((frame.size.width-8)/3*2+3, 35, 1, TFScalePoint(138));
        CGRect l_l_rect= CGRectMake(0, (frame.size.width-8)/3+36, (frame.size.width-8)/3, 20);
        CGRect m_l_rect = CGRectMake((frame.size.width-8)/3+1, (frame.size.width-8)/3+36, (frame.size.width-8)/3, 20);
        CGRect r_l_rect = CGRectMake((frame.size.width-8)/3*2+2, (frame.size.width-8)/3+36, (frame.size.width-8)/3, 20);
        
        CGRect lp_l_rect= CGRectMake(0, (frame.size.width-8)/3+50, (frame.size.width-8)/3, 20);
        CGRect mp_l_rect = CGRectMake((frame.size.width-8)/3+1, (frame.size.width-8)/3+50, (frame.size.width-8)/3, 20);
        CGRect rp_l_rect = CGRectMake((frame.size.width-8)/3*2+2, (frame.size.width-8)/3+50, (frame.size.width-8)/3, 20);
        
        UIImageView *_lineView1 = [[UIImageView alloc] initWithFrame:top_h_line_rect];
        _lineView1.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                         topCapHeight:0];
        [self.contentView addSubview:_lineView1];
        
        UIImageView *_lineView2 = [[UIImageView alloc] initWithFrame:middle_h_line_rect];
        _lineView2.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                      topCapHeight:0];
        [self.contentView addSubview:_lineView2];
        
        _leftView = [[UIImageView alloc] initWithFrame:l_v_rect];
        _leftView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_leftView];
        
        UIImageView *lineView1 = [[UIImageView alloc] initWithFrame:v_line1_rect];
        lineView1.image = [[UIImage imageNamed:@"Line_InCell"] stretchableImageWithLeftCapWidth:0
                                                                                   topCapHeight:2];
        [self.contentView addSubview:lineView1];
        
        _middleView = [[UIImageView alloc] initWithFrame:m_v_rect];
        _middleView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_middleView];
        
        UIImageView *lineView2 = [[UIImageView alloc] initWithFrame:v_line2_rect];
        lineView2.image = [[UIImage imageNamed:@"Line_InCell"] stretchableImageWithLeftCapWidth:0
                                                                                   topCapHeight:2];
        [self.contentView addSubview:lineView2];
        
        _rightView = [[UIImageView alloc] initWithFrame:r_v_rect];
        _rightView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_rightView];
        
        _leftLab = [[UILabel alloc] initWithFrame:l_l_rect];
        _leftLab.backgroundColor = [UIColor clearColor];
        _leftLab.font = [UIFont systemFontOfSize:12];
        _leftLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        _leftLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_leftLab];
        
        _middleLab = [[UILabel alloc] initWithFrame:m_l_rect];
        _middleLab.backgroundColor = [UIColor clearColor];
        _middleLab.font = [UIFont systemFontOfSize:12];
        _middleLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        _middleLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_middleLab];
        
        _rightLab = [[UILabel alloc] initWithFrame:r_l_rect];
        _rightLab.backgroundColor = [UIColor clearColor];
        _rightLab.font = [UIFont systemFontOfSize:12];
        _rightLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        _rightLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_rightLab];
        
        _leftPriceLab = [[UILabel alloc] initWithFrame:lp_l_rect];
        _leftPriceLab.backgroundColor = [UIColor clearColor];
        _leftPriceLab.font = [UIFont systemFontOfSize:12];
        _leftPriceLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        _leftPriceLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_leftPriceLab];
        
        _middlePriceLab = [[UILabel alloc] initWithFrame:mp_l_rect];
        _middlePriceLab.backgroundColor = [UIColor clearColor];
        _middlePriceLab.font = [UIFont systemFontOfSize:12];
        _middlePriceLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        _middlePriceLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_middlePriceLab];
        
        _rightPriceLab = [[UILabel alloc] initWithFrame:rp_l_rect];
        _rightPriceLab.backgroundColor = [UIColor clearColor];
        _rightPriceLab.font = [UIFont systemFontOfSize:12];
        _rightPriceLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        _rightPriceLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_rightPriceLab];
        
        _more = [UIButton buttonWithType:UIButtonTypeCustom];
        _more.frame = CGRectMake(ScreenRect.size.width-60, 2, 50, 30);
        [_more.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_more setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_more setImage:[UIImage imageNamed:@"i_more"]
                     forState:UIControlStateNormal];
        [_more setTitle:@"更多"
                     forState:UIControlStateNormal];
        [_more setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
        [_more addTarget:self
                       action:@selector(checkMore)
             forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_more];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(didClickCheckDetail:)];
        [self addGestureRecognizer:tap];
        
        _video = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_video"]];
        [self.contentView addSubview:_video];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font
                                  constrainedToSize:CGSizeMake(180, 20)];
    self.textLabel.frame = CGRectMake(6, 7, size.width+2, 20);
    
    _video.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame)+4, 7, 20, 20);
}

- (void)checkMore
{
    if ([self.delegate respondsToSelector:@selector(checkMoreSpecialCheap)])
    {
        [self.delegate checkMoreSpecialCheap];
    }
}

#pragma mark setter/getter
- (void)setTitle:(NSString *)title
{
    if (title != _title)
    {
        _title = title;
        self.textLabel.text = title;
        self.textLabel.font = [UIFont systemFontOfSize:14];
    }
}

- (void)setItems:(NSArray *)items
{
    if (items != _items)
    {
        _items = items;
        
        _leftView.image = nil;
        _leftPriceLab.text = nil;
        _leftLab.text = nil;
        
        _middleView.image = nil;
        _middlePriceLab.text = nil;
        _middleLab.text = nil;
        _rightView.image = nil;
        _rightPriceLab.text = nil;
        _rightLab.text = nil;
        
        for (int i=0; i<3&&i<[items count]; i++)
        {
            HYMallHomeItem *item = [items objectAtIndex:i];
            switch (i)
            {
                case 0:
                    [_leftView sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                                 placeholderImage:nil];
                    _leftLab.text = item.name;
                    if (item.price)
                    {
                        _leftPriceLab.text = [NSString stringWithFormat:@"¥%d+%d现金券", [item.price intValue], [item.points intValue]];
                    }
                    break;
                case 1:
                    [_middleView sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                                   placeholderImage:nil];
                    _middleLab.text = item.name;
                    if (item.price)
                    {
                        _middlePriceLab.text = [NSString stringWithFormat:@"¥%d+%d现金券", [item.price intValue], [item.points intValue]];
                    }
                    break;
                case 2:
                    [_rightView sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                                  placeholderImage:nil];
                    _rightLab.text = item.name;
                    if (item.price)
                    {
                        _rightPriceLab.text = [NSString stringWithFormat:@"¥%d+%d现金券", [item.price intValue], [item.points intValue]];
                    }
                    break;
                default:
                    break;
            }
        }
    }
}

- (void)didClickCheckDetail:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(checkProductDetail:)])
    {
        CGPoint touchPoint = [sender locationInView: self];
        
        if (touchPoint.y > _more.frame.size.height)
        {
            CGRect frame = [[UIScreen mainScreen] bounds];
            
            int index = (int)touchPoint.x/(int)(frame.size.width/3);
            
            if (index < [self.items count])
            {
                HYMallHomeItem *item = [self.items objectAtIndex:index];
                [self.delegate checkProductDetail:item];
            }
        }
    }
}

#pragma mark private methods
- (void)checkMore:(UIButton *)sender
{
  if ([self.delegate respondsToSelector:@selector(checkMoreSpecialCheap)])
    {
        [self.delegate checkMoreSpecialCheap];
    }
}
@end
