//
//  HYAddCommentsLevelCell.m
//  Teshehui
//
//  Created by RayXiang on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAddCommentsLevelCell.h"

@implementation HYAddCommentsLevelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat y = 10;
        CGFloat x = 20;
        CGFloat line = 25.0;
        
        UIFont *font = [UIFont systemFontOfSize:14.0];
        
        
        NSArray *strs = @[@"描述相符", @"服务态度", @"发货速度"];
        for (int i = 0; i < 3; i++)
        {
            CGFloat x_ = x;
            NSString *str = [strs objectAtIndex:i];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x_, y, 60, line)];
            label.backgroundColor = [UIColor clearColor];
            label.text = str;
            label.font = font;
            [self addSubview:label];
            
            x_ += 60 + 40;
            for (int j = 0; j < 5; j++)
            {
                NSInteger tag = (i+1) * 10 + j;
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x_, y, line, line)];
                [btn setBackgroundImage:[UIImage imageNamed:@"star_n"]
                               forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"star_h"]
                               forState:UIControlStateSelected];
                btn.tag = tag;
                [btn addTarget:self
                        action:@selector(levelBtnAction:)
              forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:btn];
                
                x_ += 25 + 10;
            }
            
            y += line + 12;
        }
        
        y = 119;
        CGFloat w = CGRectGetWidth(ScreenRect) - 2*x;
        UIImageView *lineV = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, 1)];
        lineV.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
        [self addSubview:lineV];
    }
    return self;
}

#pragma mark - private
- (void)levelBtnAction:(UIButton *)btn
{
    NSInteger tag = btn.tag;
    NSInteger i = tag / 10;
    NSInteger j = tag - i * 10;
    for (NSInteger k = 0; k <5; k++)
    {
        NSInteger tag_ = i * 10 + k;
        UIButton *btn = (UIButton *)[self viewWithTag:tag_];
        btn.selected = (k <= j);
    }
    switch (i) {
        case 1:
        {
            if ([self.delegate respondsToSelector:@selector(levelCell:didGetDescriptionLevel:)])
            {
                [self.delegate levelCell:self didGetDescriptionLevel:j+1];
            }
            break;
        }
        case 2:
        {
            if ([self.delegate respondsToSelector:@selector(levelCell:didGetServiceLevel:)])
            {
                [self.delegate levelCell:self didGetServiceLevel:j+1];
            }
            break;
        }
        case 3:
        {
            if ([self.delegate respondsToSelector:@selector(levelCell:didGetDeliverLevel:)])
            {
                [self.delegate levelCell:self didGetDeliverLevel:j+1];
            }
            break;
        }
        default:
            break;
    }
}

- (void)setCommentModel:(HYCommentModel *)commentModel
{
    for (NSInteger i = 1; i < 4; i++)
    {
        NSInteger level = 0;
        if (i == 1) {
            level = commentModel.desctiptionLevel;
        } else if (i == 2) {
            level = commentModel.serviceLevel;
        } else if (i == 3) {
            level = commentModel.deliverLevel;
        }
        level -= 1;
        
        for (NSInteger j = 0; j < 5; j++)
        {
            NSInteger tag = i * 10 + j;
            UIButton *desctipBtn = (UIButton *)[self.contentView viewWithTag:tag];
            if (j <= level)
            {
                desctipBtn.selected = YES;
            }
            else
            {
                desctipBtn.selected = NO;
            }
        }
    }
    
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
