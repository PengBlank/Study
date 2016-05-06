//
//  HYMallHomeBrandBoostCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeBrandBoostCell.h"
#import "HYMallHomeBrandView.h"
#import "HYMallHomeItem.h"
#import "HYUmengMobClick.h"

@interface HYMallHomeBrandBoostCell ()
<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scroll;

@end

@implementation HYMallHomeBrandBoostCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scroll.scrollsToTop = NO;
        self.scroll.delegate = self;
        [self.contentView addSubview:self.scroll];
        
        UIImageView *lineView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, .5)];
//        lineView4.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:0
//                                                                                     topCapHeight:2];
        lineView4.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:lineView4];
        
        
    }
    return self;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetk = scrollView.contentOffset.x;
    if (offsetk + scrollView.frame.size.width > scrollView.contentSize.width + 40
        && _items.count >= 10)
    {
        if ([self.delegate respondsToSelector:@selector(brandBoostWillCheckMore)]) {
            [self.delegate brandBoostWillCheckMore];
        }
    }
}

//- (void)setBoard:(HYMallHomeBoard *)board
//{
//    if (_board != board) {
//        _board = board;
//        [self setItems:board.programPOList];
//    }
//}

- (void)setItems:(NSArray *)items
{
    if (_items != items)
    {
        _items = items;
        for (UIView *sub in self.scroll.subviews)
        {
            [sub removeFromSuperview];
        }
        
        CGFloat x = 8;
        CGFloat width = 100;
        int i = 0;
        for (HYMallHomeItem *item in items)
        {
            HYMallHomeBrandView *productView = [[HYMallHomeBrandView alloc] initWithFrame:CGRectMake(x, 0, width, self.frame.size.height)];
            productView.item = item;
            productView.nTag = i;
            [productView addTarget:self
                            action:@selector(productAction:)
                  forControlEvents:UIControlEventTouchUpInside];
            [self.scroll addSubview:productView];
            x += width + 15;
            i++;
        }
        self.scroll.contentSize = CGSizeMake(x, self.frame.size.height);
        
        if (items.count >= 10)
        {
            UILabel *more = [[UILabel alloc] initWithFrame:CGRectMake(x, self.frame.size.height/2-22, 100, 44)];
            more.textColor = [UIColor colorWithWhite:.73 alpha:1];
            more.text = @"<";
            more.font = [UIFont systemFontOfSize:14.0];
            [more sizeToFit];
            [self.scroll addSubview:more];
            
            UILabel *more2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(more.frame)+10, 0, 50, self.frame.size.height)];
            more2.textColor = [UIColor colorWithWhite:.73 alpha:1];
            more2.numberOfLines = 0;
            more2.text = @"滑\n动\n查\n看\n更\n多";
            more2.font = [UIFont systemFontOfSize:14.0];
            [self.scroll addSubview:more2];
        }
    }
}

- (void)productAction:(id)sender
{
    if ([sender isKindOfClass:[HYMallHomeBrandView class]])
    {
        HYMallHomeBrandView *brandView = (HYMallHomeBrandView *)sender;
        [HYUmengMobClick homePagePublicityBrandClickedWithNumber:brandView.nTag];
        if (brandView.item) {
            [self.delegate didClickWithBoardType:self.boardType itemAtIndex:brandView.nTag];
        }
    }
}

@end
