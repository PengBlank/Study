//
//  HYMallCateSubCellContentView.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/21.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallCateSubCellContentView.h"
#import "UIControl+BlocksKit.h"

@implementation HYMallCateSubCellContentView
{
    NSMutableArray *_btns;
    UIImageView *_topArrow;
}
- (void)setCateInfo:(HYMallCategoryInfo *)cateInfo
{
    if (_cateInfo != cateInfo) {
        _cateInfo = cateInfo;
        [_btns makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (!_btns) {
            _btns = [NSMutableArray array];
        }
        
        float x = 0;
        float y = 0;
        float width = self.frame.size.width / 3.0;
        float height = 30;
        
        HYMallCategoryInfo *allcate = [cateInfo copy];
        allcate.cate_name = @"全部";
        NSArray *array = @[allcate];
        array = [array arrayByAddingObjectsFromArray:cateInfo.subcategories];
        for (int i = 0; i < array.count; i++) {
            UIButton *btn = [self makeBtn];
            [_btns addObject:btn];
            [self addSubview:btn];
            btn.frame = CGRectMake(x, y, width, height);
            btn.tag = i;
            
            HYMallCategoryInfo *cate = [array objectAtIndex:i];
            [btn setTitle:cate.cate_name forState:UIControlStateNormal];
            
            x += width;
            if (i % 3 == 2) {
                y += height;
                x = 0;
            }
        }
        _topArrowPosition = -1;
    }
}

- (UIButton *)makeBtn
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    return btn;
}


- (void)btnAction:(UIButton *)btn
{
    if (btn.tag == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kDidClickCate" object:self.cateInfo];
    }
    else
    {
        if (btn.tag < self.cateInfo.subcategories.count+1) {
            HYMallCategoryInfo *cate = [self.cateInfo.subcategories objectAtIndex:btn.tag-1];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kDidClickCate" object:cate];
        }
    }
}

- (void)setTopArrowPosition:(int)topArrowPosition
{
    if (_topArrowPosition != topArrowPosition) {
        _topArrowPosition = topArrowPosition;
        
        if (!_topArrow) {
            _topArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mall_cate_array2"]];
            [self addSubview:_topArrow];
        }
        float space = self.frame.size.width/6;
        _topArrow.frame = CGRectMake(space*2*topArrowPosition + space, -CGRectGetHeight(_topArrow.frame), _topArrow.frame.size.width, _topArrow.frame.size.height);
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
