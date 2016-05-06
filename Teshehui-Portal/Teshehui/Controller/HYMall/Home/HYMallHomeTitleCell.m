//
//  HYMallHomeTitleCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeTitleCell.h"
#import "Masonry.h"

@implementation HYMallHomeTitleCell

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
//    lineView1.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
//                                                                                     topCapHeight:0];
    lineView1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.contentView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(.5);
    }];
    
    
    UIImageView *lineView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 34, self.frame.size.width, 1)];
//    lineView2.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
//                                                                                  topCapHeight:0];
    lineView2.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.contentView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(.5);
    }];
}

- (void)setShowMore:(BOOL)showMore
{
    self.moreLabel.hidden = !showMore;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.moreLabel.hidden = YES;
}

@end
