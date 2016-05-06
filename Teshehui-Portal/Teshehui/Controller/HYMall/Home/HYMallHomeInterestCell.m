//
//  HYMallHomeInterestCell.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/26.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallHomeInterestCell.h"
#import "HYImageButton.h"
#import "HYMallHomeItem.h"
#import "UIButton+WebCache.h"

@interface HYInterestBtn : UIButton

@end

@implementation HYInterestBtn

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = CGSizeMake(TFScalePoint(35), TFScalePoint(35));
    self.imageView.frame = CGRectMake(self.frame.size.width/2-size.width/2, TFScalePoint(5), size.width, size.height);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+TFScalePoint(5), self.frame.size.width, self.titleLabel.font.lineHeight);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end

@implementation HYMallHomeInterestCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5)];
        line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setItems:(NSArray *)items
{
    if (items != _items) {
        
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        _items = items;
        float x = 0;
        float y = 0;
        float width = self.frame.size.width / 5;
        float height = self.frame.size.height / 2;
        
        for (HYMallHomeItem *item in items)
        {
            HYInterestBtn *btn = [[HYInterestBtn alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [btn setTitle:item.name forState:UIControlStateNormal];
            [btn sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                           forState:UIControlStateNormal
                   placeholderImage:[UIImage imageNamed:@"logo_loading"]];
            
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.imageView.layer.cornerRadius = btn.imageView.frame.size.height/2;
            [btn addTarget:self action:@selector(itemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btn.tag = [items indexOfObject:item];
            [self.contentView addSubview:btn];
            
            x += width;
            if ([items indexOfObject:item] % 5 == 4) {
                x = 0;
                y += height;
            }
        }
        
        HYInterestBtn *btn = [[HYInterestBtn alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [btn setTitle:@"重新定制" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_home_custombtn"] forState:UIControlStateNormal];
        btn.tag = 1024;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(itemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
}

- (void)itemBtnAction:(UIButton *)btn
{
    if (btn.tag < self.items.count) {
        [self.delegate didClickWithBoardType:self.boardType itemAtIndex:btn.tag];
    }
    if (btn.tag == 1024) {
        if (self.checkAllTags) {
            self.checkAllTags();
        }
    }
}

@end
