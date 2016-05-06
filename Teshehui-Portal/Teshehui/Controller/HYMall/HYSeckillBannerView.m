//
//  HYSeckillBannerView.m
//  Teshehui
//
//  Created by 成才 向 on 15/12/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYSeckillBannerView.h"
#import "HYSeckillBannerItemView.h"
#import "Masonry.h"

@implementation HYSeckillBannerView
{
    NSMutableArray *_itemViews;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
//        self.backgroundColor = [UIColor colorWithWhite:.01 alpha:1];
    }
    return self;
}

/**
 *  @brief  设具体秒杀时间段
 *
 *  @param items
 */
- (void)setItems:(NSArray *)items
{
    if (_items != items)
    {
        _items = items;
        
        self.backgroundColor = [UIColor colorWithWhite:.01 alpha:1];
        
        [_itemViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _itemViews = [NSMutableArray array];
        // 只取前三
        if (items.count > 3) {
            items = [items subarrayWithRange:NSMakeRange(0, 3)];
        }
        
        /// 布局说明
        /// 最多三个, 均分宽度, 每两项中间有2像素宽度
        
        CGFloat x = 0;
        CGFloat space = 2;
        CGFloat width = (self.frame.size.width - (items.count-1)*space) / items.count;
        for (HYSeckillActivityModel* item in items)
        {
            CGRect frame = CGRectMake(x, 0, width, self.frame.size.height);
            HYSeckillBannerItemView *itemView = [[HYSeckillBannerItemView alloc] initWithFrame:frame];
            itemView.activity = item;
            itemView.tag = [items indexOfObject:item] + 1;
            [itemView addTarget:self
                         action:@selector(itemClick:)
               forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:itemView];
            [_itemViews addObject:itemView];
            x += width + space;
        }
    }
}

- (void)itemClick:(HYSeckillBannerItemView *)itemView
{
    [self setSelectedIdx:[_itemViews indexOfObject:itemView]];
    
    if (self.didSelectItemAtIndex) {
        self.didSelectItemAtIndex(itemView.tag-1);
    }
}

- (void)setSelectedIdx:(NSInteger)selectedIdx
{
    _selectedIdx = selectedIdx;
    
    for (int i = 0; i < _itemViews.count; i++) {
        HYSeckillBannerItemView *item = [_itemViews objectAtIndex:i];
        if (selectedIdx == i) {
            item.selected = YES;
        }
        else {
            item.selected = NO;
        }
    }
}

- (void)setCurrentItem:(HYSeckillActivityModel *)curActivity
{
    NSMutableArray *items = [_items mutableCopy];
    [items replaceObjectAtIndex:_selectedIdx withObject:curActivity];
    [self setItems:items];
    [self setSelectedIdx:_selectedIdx];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
