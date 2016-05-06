//
//  HotCityCell.m
//  Teshehui
//
//  Created by apple_administrator on 15/10/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HotCityCell.h"
#import "UIColor+expanded.h"
#import "UIImage+Common.h"
#import "DefineConfig.h"
@implementation HotCityCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
    }
    return self;
}

- (void)bindData:(NSMutableArray *)hotCityArray{
    
    NSInteger row = (hotCityArray.count / 3 + (hotCityArray.count % 3 == 0 ? 0 : 1));
    CGFloat cellHeight = row * 44;
    
    int rowMargin = (cellHeight - (30 * row)) / (row + 1);
    int width = (kScreen_Width - 20 - rowMargin) / 3 - (rowMargin * (4/3));
    
    for (int i = 0; i < hotCityArray.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(rowMargin +  (i % 3) * width + (i % 3)*rowMargin , rowMargin + (i / 3) * 30 + (i / 3) * rowMargin, width, 30)];
        [btn setTitle:hotCityArray[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        btn.adjustsImageWhenHighlighted = YES;
        [btn setTitleColor:[UIColor colorWithHexString:@"0x424242"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xf2f2f2"]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];

        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
    }
}

- (void)btnAction:(UIButton *)btn{
    if (_hotCityClick) {
        _hotCityClick(btn);
    }
}


@end
