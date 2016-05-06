//
//  HYCategorySubCell.m
//  Teshehui
//
//  Created by RayXiang on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCategorySubCell.h"
#import "HYCategorySubContentView.h"

@interface HYCategorySubCell ()
{
}
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) HYCategorySubContentView *contentCateView;

@end

@implementation HYCategorySubCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //self.backgroundColor = [UIColor lightGrayColor];
        self.contentCateView = [[HYCategorySubContentView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _contentCateView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _contentCateView.delegate = self;
        [self.contentView addSubview:_contentCateView];
    }
    return self;
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
//        [self addSubview:_lineView];
//    }
//    
//    return _lineView;
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setCategory:(HYMallCategoryInfo *)category
{
    if (_category != category) {
        _category = category;
        self.nameLab.text = category.cate_name;
        if (category.subcategories.count > 0) {
            [self.contentCateView setItems:category.subcategories];
        }else{
            [_contentCateView setItems:[NSArray arrayWithObject:category]];
        }
        
        [_contentCateView setNeedsDisplay];
    }
}


- (void)contentViewDidSelectAtIndex:(NSInteger)idx
{
    NSArray *cates = _category.subcategories;
    if (cates.count == 0) {
        cates = [NSArray arrayWithObject:_category];
    }
    if (cates.count > idx)
    {
        HYMallCategoryInfo *select = [cates objectAtIndex:idx];
        if ([self.delegate respondsToSelector:@selector(didSelectSubCategory:atIndex:)])
        {
            [self.delegate didSelectSubCategory:select atIndex:idx];
        }
    }
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
