//
//  HYMallHomeTileCollectionCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeTileCollectionCell.h"
#import "HYMallHomeItem.h"
#import "UIButton+WebCache.h"
#import "Masonry.h"
#import "HYUmengMobClick.h"

@interface HYMallHomeTileCollectionCell ()
{
    UIButton *_item1Btn;
    UIButton *_item2Btn;
    UIButton *_item3Btn;
    UIButton *_item4Btn;
}

@property (nonatomic, strong) NSDictionary *tileViews;

@end

@implementation HYMallHomeTileCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
//        float sep
        
        CGFloat sepy = frame.size.height * 0.57;
        float sepy2 = frame.size.height * 0.58;
        float sepx1 = frame.size.width / 3;
        float sepx2 = sepx1 * 2;
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, sepy, frame.size.width, 0.5)];
        lineView1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:lineView1];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, sepy2, frame.size.width, .5)];
        lineView2.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:lineView2];
        
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(sepx1, sepy2, .5, frame.size.height-sepy2)];
        lineView3.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:lineView3];
        
        UIView *lineview4 = [[UIView alloc] initWithFrame:CGRectMake(sepx2, sepy2, 0.5, frame.size.height-sepy2)];
        lineview4.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:lineview4];
        
        UIView *lineview5 = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5)];
        lineview5.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:lineview5];
        
        
        _item1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _item1Btn.frame = CGRectMake(0,
                                     1,
                                     frame.size.width,
                                     sepy-1);
        _item1Btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _item1Btn.tag = 1;
        [_item1Btn addTarget:self
                      action:@selector(checkItemDetail:)
            forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_item1Btn];
        
        _item2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _item2Btn.frame = CGRectMake(0,
                                     sepy2+0.5,
                                     sepx1,
                                     frame.size.height-0.5-(sepy2+0.5));
        _item2Btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _item2Btn.tag = 2;
        [_item2Btn addTarget:self
                      action:@selector(checkItemDetail:)
            forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_item2Btn];
        
        _item3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _item3Btn.frame = CGRectMake(sepx1+0.5,
                                     sepy2+0.5,
                                     sepx2-sepx1-0.5,
                                     frame.size.height-0.5-(sepy2+0.5));
        _item3Btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _item3Btn.tag = 3;
        [_item3Btn addTarget:self
                      action:@selector(checkItemDetail:)
            forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_item3Btn];
        
        _item4Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _item4Btn.frame = CGRectMake(sepx2+0.5,
                                     sepy2+0.5,
                                     frame.size.width-sepx2-0.5,
                                     frame.size.height-0.5-(sepy2+0.5));
        _item4Btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _item4Btn.tag = 4;
        [_item4Btn addTarget:self
                      action:@selector(checkItemDetail:)
            forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_item4Btn];
        
        _tileViews = [[NSDictionary alloc] init];
    }
    return self;
}

#pragma mark - private methods
- (void)checkItemDetail:(UIButton *)sender
{
    [HYUmengMobClick homePagePrimeRateClickedWithNumber:(int)sender.tag];
    
    if ((sender.tag-1) < [self.items count])
    {
        [self.delegate didClickWithBoardType:self.boardType itemAtIndex:sender.tag-1];
    }
}

//- (void)setBoard:(HYMallHomeBoard *)board
//{
//    if (_board != board) {
//        _board = board;
//        [self setItems:board.programPOList];
//        [self setTitle:board.title];
//    }
//}

- (void)setItems:(NSArray *)items
{
    if (items != _items)
    {
        _items = items;
        
        //clean
        
        if ([items count] < 4)
        {
            [_item1Btn setImage:nil
                       forState:UIControlStateNormal];
            [_item2Btn setImage:nil
                       forState:UIControlStateNormal];
            [_item3Btn setImage:nil
                       forState:UIControlStateNormal];
            [_item4Btn setImage:nil
                       forState:UIControlStateNormal];
        }
        
        for (int i=0; i<4&&i<[items count]; i++)
        {
            HYMallHomeItem *item = [self.items objectAtIndex:i];
            
            if (i == 0)
            {
                [_item1Btn sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                                     forState:UIControlStateNormal];
            }
            else if (i == 1)
            {
                [_item2Btn sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                                     forState:UIControlStateNormal];
            }
            else if (i == 2)
            {
                [_item3Btn sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                                     forState:UIControlStateNormal];
            }
            else if (i == 3) {
                [_item4Btn sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                                     forState:UIControlStateNormal];
            }
        }
    }
}


@end
