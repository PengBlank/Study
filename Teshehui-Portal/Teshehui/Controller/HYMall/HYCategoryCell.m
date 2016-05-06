//
//  HYCategoryCell.m
//  Teshehui
//
//  Created by RayXiang on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCategoryCell.h"
#import "UIImageView+WebCache.h"

@interface HYCategoryCell ()

@property (nonatomic, strong) UIImageView *cateImgView;
@property (nonatomic, strong) IBOutlet UILabel *cateNameLab;
@property (nonatomic, strong) UILabel *cateDetailLab;
@property (nonatomic, strong) UIImageView *indicatorImgView;
//@property (nonatomic, strong) UIView *sImgV;
@property (nonatomic, strong) UIImageView *arrowView;

@end

@implementation HYCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //三角，自动上下居中
        UIImage *indicator = [UIImage imageNamed:@"cate_indicat_down.png"];
        CGFloat y = CGRectGetHeight(self.frame)/2 - indicator.size.height/2;
        UIImageView *arrView1 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenRect.size.width-indicator.size.width/2-35, y, indicator.size.width, indicator.size.height)];
        arrView1.image = indicator;
        arrView1.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:arrView1];
        self.indicatorImgView = arrView1;
        
        //图
        CGFloat x = 30;
        y = 15;
        CGFloat w = 50;
        CGFloat h = 50;
        UIImageView *cateImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [self addSubview:cateImgView];
        self.cateImgView = cateImgView;
        
        //名
        x += w + 20;
        y = 20;
        w = 180;
        h = 20;
        UILabel *cateNameLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        cateNameLab.backgroundColor = [UIColor clearColor];
        cateNameLab.font = [UIFont systemFontOfSize:16.0];
        //cateNameLab.text = @"超级数码";
        [self addSubview:cateNameLab];
        self.cateNameLab = cateNameLab;
        
        //详情
        y += h + 5;
        UILabel *cateDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        cateDetailLab.backgroundColor = [UIColor clearColor];
        cateDetailLab.font = [UIFont systemFontOfSize:12.0];
        //cateDetailLab.text = @"热门品牌|潮流数码";
        cateDetailLab.textColor = [UIColor grayColor];
        [self addSubview:cateDetailLab];
        self.cateDetailLab = cateDetailLab;
        
        UIImage *arrow = [UIImage imageNamed:@"cate_sub_arrow.png"];
        UIImageView *arrView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenRect.size.width-arrow.size.width/2-35, CGRectGetHeight(self.frame)-arrow.size.height, arrow.size.width, arrow.size.height)];
        arrView.image = arrow;
        arrView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:arrView];
        self.arrowView = arrView;
    }
    return self;
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorLeftInset = 0;
}

#pragma mark - 横线
//- (UIImageView *)lineView
//{
//    if (!_lineView)
//    {
//        CGFloat _separatorLeftInset = 10;
//        CGFloat w = CGRectGetWidth(self.frame) - 2 * _separatorLeftInset;
//        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(_separatorLeftInset, 0, w, 1.0)];
//        _lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
//                                                                                        topCapHeight:0];
//        _lineView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
//        //[self addSubview:_lineView];
//        [self insertSubview:_lineView belowSubview:_arrowView];
//    }
//    
//    return _lineView;
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGRect frame = self.lineView.frame;
//    frame.origin.y = CGRectGetHeight(self.frame) - 1;
//    _lineView.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected)
    {
        [UIView animateWithDuration:.3 animations:^
        {
            self.backgroundColor = [UIColor whiteColor];
        }];
    }
    else
    {
        [UIView animateWithDuration:.3 animations:^{
            self.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        }];
    }
}

- (void)setWithCategory:(HYMallCategoryInfo *)category
{
    self.cateNameLab.text = category.cate_name;
//    self.cateDetailLab.text = category.brief;
//    NSURL *URL = [NSURL URLWithString:category.thumbnail_tetragonal];
//    [self.cateImgView sd_setImageWithURL:URL];
//    NSString *desc = category.brief;
//    CGFloat maxHeight = CGRectGetHeight(self.frame) - CGRectGetMaxY(_cateNameLab.frame) - 5;
//    CGSize size = [desc sizeWithFont:_cateDetailLab.font
//                   constrainedToSize:CGSizeMake(CGRectGetWidth(_cateDetailLab.frame), maxHeight)];
//    CGRect frame = _cateDetailLab.frame;
//    frame.size = size;
//    _cateDetailLab.frame = frame;
//    _cateDetailLab.text = desc;
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
