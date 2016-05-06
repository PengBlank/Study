//
//  HYCommentHeaderCell.m
//  Teshehui
//
//  Created by RayXiang on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCommentHeaderCell.h"
#import "TQStarRatingView.h"

@interface HYCommentHeaderCell ()
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) TQStarRatingView *ratingControl;
@property (nonatomic, strong) UILabel *numberLab;
@end

@implementation HYCommentHeaderCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellStyleDefault;
        
        CGRect frame = CGRectMake(0, 0, ScreenRect.size.width, 45);
        CGFloat x = 15;
        CGFloat w = 75;
        CGFloat h = CGRectGetHeight(frame);
        
        UILabel *ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, w, h)];
        ratingLabel.font = [UIFont systemFontOfSize:18.0];
        ratingLabel.backgroundColor = [UIColor clearColor];
        ratingLabel.textColor = [UIColor redColor];
        ratingLabel.text = @"评价4.8";
        [self.contentView addSubview:ratingLabel];
        self.ratingLabel = ratingLabel;
       
        x = CGRectGetMaxX(ratingLabel.frame) + 5;
        CGFloat y = CGRectGetMidY(ratingLabel.frame) - 15/2;
        w = 80;
        h = 15;
        TQStarRatingView *control = [[TQStarRatingView alloc] initWithStar:[UIImage imageNamed:@"star_n"] hilightedStar:[UIImage imageNamed:@"star_h"] numberOfStar:5 spaceOfStar:1];
        control.enable = NO;
        control.fraction = YES;
        control.rating = 4.5;
        control.frame = CGRectMake(x, y, w, h);
        
        [self.contentView addSubview:control];
        self.ratingControl = control;
        
        w = CGRectGetWidth(frame) - 15 - CGRectGetMaxX(control.frame);
        x = CGRectGetMaxX(control.frame);
        h = 20;
        y = CGRectGetMidY(control.frame) - h/2;
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.textColor = [UIColor grayColor];
        numberLabel.font = [UIFont systemFontOfSize:14.0];
        numberLabel.textAlignment = NSTextAlignmentRight;
        numberLabel.text = @"(共25人评价)";
        [self.contentView addSubview:numberLabel];
        self.numberLab = numberLabel;
        
    }
    return self;
}

- (void)setCommentLevel:(CGFloat)commentLevel
{
    _commentLevel = commentLevel;
    self.ratingControl.rating = commentLevel;
    self.ratingLabel.text = [NSString stringWithFormat:@"评分%.1f", commentLevel];
}

- (void)setCommentNum:(NSInteger)commentNum
{
    _commentNum = commentNum;
    self.numberLab.text = [NSString stringWithFormat:@"(共%ld人评价)", (long)commentNum];
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
