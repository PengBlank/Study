//
//  HYSummaryTableViewCell.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-12.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYSummaryTableViewCell.h"
#import "HYSummaryCellBgView.h"

@implementation HYSummaryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgView = [[HYSummaryCellBgView alloc] initWithFrame:self.bounds];
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_bgView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectedBackgroundView = [[UIView alloc] init];
        _canClick = NO;
        
        _font_size = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 22 : 16.0;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.bgView = [[HYSummaryCellBgView alloc] initWithFrame:self.bounds];
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_bgView];
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectedBackgroundView = [[UIView alloc] init];
        _canClick = NO;
    }
    return self;
}

- (void)setNumberOfRow:(NSInteger)numberOfRow
{
    _numberOfRow = numberOfRow;
    _bgView.numberOfRow = numberOfRow;
    
}

- (UILabel *)labelAtIndex:(NSInteger)idx
{
    UILabel *label = (UILabel *)[self.contentView viewWithTag:1000 + idx];
    if (!label)
    {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:_font_size];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        label.tag = 1000 + idx;
        [self.contentView addSubview:label];
    }
    return label;
}

- (UILabel *)subLabelAtIndex:(NSInteger)idx
{
    UILabel *label = (UILabel *)[self.contentView viewWithTag:2000 + idx];
    if (!label)
    {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:_font_size];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.tag = 2000 + idx;
        [self.contentView addSubview:label];
    }
    return label;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *subview in self.contentView.subviews)
    {
        NSInteger tag = subview.tag;
        
        if (tag >= 1000 && tag < 2000)
        {
            UILabel *label = (UILabel *)subview;
            CGFloat x = 20 + 10;
            CGFloat w = CGRectGetWidth(self.frame)-2*x;
            CGFloat h = CGRectGetHeight(self.frame) / _numberOfRow;
            CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(w, h)];
            CGFloat row = tag - 1000;
            CGFloat y = h * row;
            label.frame = CGRectMake(x, y, size.width, h);
        } else if (tag >= 2000)
        {
            UILabel *label = (UILabel *)subview;
            [label sizeToFit];
            
            CGFloat row = tag - 2000;
            
            CGFloat w = label.frame.size.width;
            CGFloat x = CGRectGetWidth(self.frame) - 20 - 10 - w;
            CGFloat h = CGRectGetHeight(self.frame) / _numberOfRow;
            CGFloat y = h * row;
            label.frame = CGRectMake(x, y, w, h);
        }
    }
    if (_canClick)
    {
        UIImage *img = [UIImage imageNamed:@"ico_arrow_list.png"];
        UIImageView *imgv = [[UIImageView alloc] initWithImage:img];
        imgv.frame = CGRectMake(CGRectGetWidth(self.frame)-40, CGRectGetMidY(self.bounds)-10.5, 14, 21);
        imgv.tag = 3304;
        [self.contentView addSubview:imgv];
    }
    else
    {
        UIView *imgv = [self.contentView viewWithTag:3304];
        if (imgv) {
            [imgv removeFromSuperview];
        }
    }
}

//- (void)setCanClick:(BOOL)canClick
//{
//    if (_canClick != canClick)
//    {
//        _canClick = canClick;
//        if (_canClick)
//        {
//            UIImage *img = [UIImage imageNamed:@"ico_arrow_list.png"];
//            UIImageView *imgv = [[UIImageView alloc] initWithImage:img];
//            imgv.frame = CGRectMake(40, 0, 15, 10);
//            imgv.tag = 3304;
//            [self.contentView addSubview:imgv];
//        }
//        else
//        {
//            UIView *imgv = [self.contentView viewWithTag:3304];
//            if (imgv) {
//                [imgv removeFromSuperview];
//            }
//        }
//    }
//}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    for (UIView *subview in self.contentView.subviews)
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel *)subview;
            label.text = nil;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (self.selectionStyle != UITableViewCellSelectionStyleNone)
    {
        if (selected) {
            _bgView.styleColor = [UIColor grayColor];
        }
        else
        {
            _bgView.styleColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
        }
    }
    
    // Configure the view for the selected state
}

//- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
//{
//    if (accessoryType == UITableViewCellAccessoryDisclosureIndicator)
//    {
//        UIImage *img = [UIImage imageNamed:@"ico_arrow_list.png"];
//        UIImageView *imgv = [[UIImageView alloc] initWithImage:img];
//        imgv.frame = CGRectMake(40, 0, 15, 10);
//        imgv.tag = 3304;
//        [self.contentView addSubview:imgv];
//    }
//    else
//    {
//        UIView *imgv = [self.contentView viewWithTag:3304];
//        if (imgv) {
//            [imgv removeFromSuperview];
//        }
//        [super setAccessoryType:accessoryType];
//    }
//}

@end
