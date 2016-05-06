//
//  HYChannelSpecialCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYChannelSpecialCell.h"
#import "iCarousel.h"
#import "UIImageView+WebCache.h"

@interface HYChannelSpecialCell ()
<iCarouselDataSource,
iCarouselDelegate>
@property (nonatomic, strong) iCarousel *contentScroll;

@end

@implementation HYChannelSpecialCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.separatorLeftInset = 0;
        self.contentScroll = [[iCarousel alloc] initWithFrame:self.bounds];
        self.contentScroll.pagingEnabled = YES;
        self.contentScroll.dataSource = self;
        self.contentScroll.delegate = self;
        self.contentScroll.type = iCarouselTypeCustom;
        [self.contentView addSubview:self.contentScroll];
        self.clipsToBounds = YES;
    }
    return self;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _items.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view
{
    CGFloat width = self.frame.size.width / 3;
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, self.frame.size.height)];
    img.backgroundColor = [UIColor redColor];
    if (index < _items.count)
    {
        HYMallChannelItem *item = [_items objectAtIndex:index];
        if ([item isKindOfClass:[HYMallChannelItem class]])
        {
            NSURL *url = [NSURL URLWithString:item.image];
            [img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading"]];
        }
    }
    return img;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
//    if (option == iCarouselOptionSpacing)
//    {
//        return 1.8;
////        DebugNSLog(@"%f", value);
//    }
//    if (option == iCarouselOptionVisibleItems)
//    {
//        DebugNSLog(@"%f", value);
//        return 3;
//    }
//    if (option == iCarouselOptionArc)
//    {
//        return M_PI_4;
//    }
    if (option == iCarouselOptionWrap)
    {
        return 1;
    }
    return value;
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    CGFloat x = offset * carousel.itemWidth;
    transform = CATransform3DTranslate(transform, x, 0, 0);
    if (offset != 0)
    {
        transform = CATransform3DScale(transform, .8, .8, 0);
    }
    return transform;
}

- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index
{
    return YES;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(checkBannerItem:withBoard:)])
    {
        if (index < [self.items count])
        {
            HYMallChannelItem *item = [self.items objectAtIndex:index];
            [self.delegate checkBannerItem:item withBoard:self.channelBoard];
        }
    }
}

//- (void)checkItemDetail:(UIButton *)sender
//{
//    if ([self.delegate respondsToSelector:@selector(checkProductDetail:)])
//    {
//        if ((sender.tag-1) < [self.items count])
//        {
//            HYMallChannelItem *item = [self.items objectAtIndex:(sender.tag-1)];
//            [self.delegate checkProductDetail:item];
//        }
//    }
//}


//- (CGFloat)carouselItemWidth:(iCarousel *)carousel
//{
//    return self.frame.size.width/2.5;
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentScroll.frame = self.bounds;
//    self.contentScroll.itemWidth = self.frame.size.width/3;
}

- (void)setChannelBoard:(HYMallChannelBoard *)channelBoard
{
    if (_channelBoard != channelBoard) {
        _channelBoard = channelBoard;
        [self setItems:channelBoard.channelBannerList];
    }
}

- (void)setItems:(NSArray *)items
{
    if (_items != items)
    {
        _items = items;
        
        if (items.count > 0)
        {
            [self.contentScroll setCurrentItemIndex:0];
        }
        [self.contentScroll reloadData];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
