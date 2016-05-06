//
//  HYMallHomeFashionTileCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeFashionTileCell.h"
#import "Masonry.h"
#import "HYMallHomeItem.h"
#import "UIButton+WebCache.h"
#import "HYUmengMobClick.h"

@interface HYMallHomeFashionTileCell ()

//UI Buttons
//爆力解决法!
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;
@property (nonatomic, strong) UIButton *button5;

@end

@implementation HYMallHomeFashionTileCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat xsep1 = frame.size.width*0.4;
        CGFloat xsep2 = frame.size.width*0.7;
        CGFloat ysep = frame.size.height/2;
        
        //竖线
        UIImageView *lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(xsep1, 0, .5, frame.size.height)];
//        lineView1.image = [[UIImage imageNamed:@"Line_InCell"] stretchableImageWithLeftCapWidth:0
//                                                                                   topCapHeight:2];
        lineView1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:lineView1];
        
        UIImageView *lineView2 = [[UIImageView alloc] initWithFrame:CGRectMake(xsep2, 0, .5, frame.size.height)];
//        lineView2.image = [[UIImage imageNamed:@"Line_InCell"] stretchableImageWithLeftCapWidth:0
//                                                                                   topCapHeight:2];
        lineView2.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:lineView2];
        
        //横线
        UIImageView *lineView3 = [[UIImageView alloc] initWithFrame:CGRectMake(xsep1, ysep, frame.size.width*0.6, .5)];
//        lineView3.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:0
//                                                                                     topCapHeight:2];
        lineView3.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:lineView3];
        
        UIImageView *lineView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, .5)];
//        lineView4.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:0
//                                                                                     topCapHeight:2];
        lineView4.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:lineView4];
        
        self.button1 = [self createButton];
        self.button1.frame = CGRectMake(0, 0, xsep1, frame.size.height-1);
        self.button1.tag = 1;
        
        self.button2 = [self createButton];
        self.button2.frame = CGRectMake(xsep1+1, 0, xsep2-xsep1-1, ysep);
        self.button2.tag = 2;
        
        self.button3 = [self createButton];
        self.button3.frame = CGRectMake(xsep2+1, 0, self.frame.size.width-xsep2, ysep);
        self.button3.tag = 3;
        
        self.button4 = [self createButton];
        self.button4.frame = CGRectMake(xsep1+1, ysep, xsep2-xsep1-1, ysep);
        self.button4.tag = 4;
        
        self.button5 = [self createButton];
        self.button5.frame = CGRectMake(xsep2+1, ysep, self.frame.size.width-xsep2, ysep);
        self.button5.tag = 5;
    }
    return self;
}

- (UIButton *)createButton
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.tag = 1;
    [btn addTarget:self
                  action:@selector(checkItemDetail:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    return btn;
}

#pragma mark - private methods
- (void)checkItemDetail:(UIButton *)sender
{
    [HYUmengMobClick homePageFashionStreetClickedWithNumber:(int)sender.tag];
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
//    }
//}

- (void)setItems:(NSArray<HYMallHomeItem *> *)items
{
    if (_items != items)
    {
        _items = items;
        for (int i=0; i<5&&i<[items count]; i++)
        {
            HYMallHomeItem *item = [self.items objectAtIndex:i];
            
            if (i == 0)
            {
                [_button1 sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                                     forState:UIControlStateNormal];
            }
            else if (i == 1)
            {
                [_button2 sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                                    forState:UIControlStateNormal];
            }
            else if (i == 2)
            {
                [_button3 sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                                    forState:UIControlStateNormal];
            }
            else if (i == 3)
            {
                [_button4 sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                                    forState:UIControlStateNormal];
            }
            else if (i == 4)
            {
                [_button5 sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                                    forState:UIControlStateNormal];
            }
        }
    }
}

@end
