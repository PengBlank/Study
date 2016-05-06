//
//  HYMallHomeFashionScrollCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeFashionScrollCell.h"
#import "HYMallHomeFashionView.h"
#import "HYMallHomeItem.h"
#import "HYUmengMobClick.h"

@interface HYMallHomeFashionScrollCell ()

@property (nonatomic, strong) UIScrollView *contentScroll;

@end

@implementation HYMallHomeFashionScrollCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        UIScrollView *content = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:content];
        content.scrollsToTop = NO;
        self.contentScroll = content;
        
        UIImageView *lineView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, .5)];
//        lineView3.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:0
//                                                                                     topCapHeight:2];
        lineView3.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:lineView3];
    }
    return self;
}

- (void)setItems:(NSArray<HYMallHomeItem *> *)items
{
    if (_items != items)
    {
        _items = items;
        
        for (UIView *view in self.contentScroll.subviews)
        {
            [view removeFromSuperview];
        }
        
        CGFloat x = 12;
        CGFloat y = 8;
        CGFloat width = 0.36 * self.frame.size.width;
        CGFloat height = self.frame.size.height - 2*y;
        for (HYMallHomeItem *item in items)
        {
            HYMallHomeFashionView *view = [[HYMallHomeFashionView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            view.category = item.name;
            view.imgName = item.pictureUrl;
            view.tag = [items indexOfObject:item] + 1;
            [view addTarget:self action:@selector(productCheck:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentScroll addSubview:view];
            x += 8 + width;
        }
        
        x += 12;
        self.contentScroll.contentSize = CGSizeMake(x, self.frame.size.height);
    }
}

//- (void)setBoard:(HYMallHomeBoard *)board
//{
//    if (_board != board) {
//        _board = board;
//        [self setItems:board.programPOList];
//    }
//}

- (void)productCheck:(UIControl*)sender
{
//    DebugNSLog(@"check!");
    
    [HYUmengMobClick homePageFashionStreetScrollClickedWithNumber:(int)sender.tag];
    if ((sender.tag-1) < [self.items count])
    {
        [self.delegate didClickWithBoardType:self.boardType itemAtIndex:sender.tag-1];
    }
}

@end
