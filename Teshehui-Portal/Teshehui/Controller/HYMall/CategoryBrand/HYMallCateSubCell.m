//
//  HYMallCateSubCell.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/21.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallCateSubCell.h"
#import "HYMallCateSubCellContentView.h"
#import "HYCateSubCellBtn.h"

@implementation HYMallCateSubCell
{
    NSMutableArray *_subBtns;
    
    __strong HYMallCateSubCellContentView *_subContent;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setCateInfo:(HYMallCategoryInfo *)cateInfo
{
    if (_cateInfo != cateInfo)
    {
        _cateInfo = cateInfo;
        
        if (!_subBtns) {
            _subBtns = [NSMutableArray array];
        }
        if (cateInfo.subcategories.count > _subBtns.count)
        {
            int count = (int) (cateInfo.subcategories.count-_subBtns.count);
            for (int i = 0; i < count; i++) {
                [self createBtn];
            }
        }
        for (int i = 0; i < _subBtns.count; i++) {
            UIButton *btn = _subBtns[i];
            btn.hidden = YES;
        }
    }
    
    CGFloat width = self.frame.size.width / 3.0;
    CGFloat height = 38;
    CGFloat x = 0;
    CGFloat y = 0;
    for (int i = 0; i < cateInfo.subcategories.count; i++)
    {
        HYMallCategoryInfo *cate = cateInfo.subcategories[i];
        UIButton *btn = _subBtns[i];
        btn.tag = i;
        btn.hidden = NO;
        
        if (_cateInfo.expandIdx > -1) {
            btn.frame = CGRectMake(x, i >= (_cateInfo.expandIdx/3+1)*3?y + _cateInfo.cachedHeight2 :  y, width, height);
        }
        else {
            btn.frame = CGRectMake(x, y, width, height);
        }
        [btn setTitle:cate.cate_name forState:UIControlStateNormal];
        
        x += width;
        if (i % 3 == 2) {
            y += height;
            x = 0;
        }
    }
    
    if (_cateInfo.expandIdx > -1)
    {
        if (!_subContent) {
            _subContent = [[HYMallCateSubCellContentView alloc] init];
            _subContent.frame = CGRectMake(0,
                                           (_cateInfo.expandIdx+2)/3*38,
                                           self.frame.size.width,
                                           0);
            _subContent.backgroundColor = [UIColor colorWithWhite:.88 alpha:1];
            [self.contentView addSubview:_subContent];
        }
        _subContent.cateInfo = [_cateInfo.subcategories objectAtIndex:_cateInfo.expandIdx];
        [self.contentView bringSubviewToFront:_subContent];
        _subContent.frame = CGRectMake(0,
                                       (_cateInfo.expandIdx/3+1)*38,
                                       self.frame.size.width,
                                       _cateInfo.cachedHeight2);
        _subContent.topArrowPosition = _cateInfo.expandIdx % 3;
    }
    else
    {
        [_subContent removeFromSuperview];
        _subContent = nil;
    }
    
    for (int i = 0; i < _subBtns.count; i++) {
        UIButton *btn = _subBtns[i];
        if (i == _cateInfo.expandIdx)
        {
            btn.selected = YES;
            btn.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
        }
        else
        {
            btn.selected = NO;
            btn.imageView.transform = CGAffineTransformIdentity;
        }
    }
}

- (void)createBtn
{
    HYCateSubCellBtn *btn = [[HYCateSubCellBtn alloc] initWithFrame:CGRectZero];
    [btn setTitleColor:[UIColor colorWithWhite:.2 alpha:1] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:58/255.0 blue:85/255.0 alpha:1] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"mall_cate_arrow"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"mall_cate_arrow1"] forState:UIControlStateSelected];
    [self.contentView addSubview:btn];
    [_subBtns addObject:btn];
}

- (void)btnAction:(UIButton *)btn
{
    
    if (btn.tag < self.cateInfo.subcategories.count) {
        if (self.cateInfo.expandIdx == btn.tag)
        {
            _cateInfo.expandIdx = -1;
            _cateInfo.cachedHeight2 = 0;
            [_subContent removeFromSuperview];
            _subContent = nil;
        }
        else
        {
            HYMallCategoryInfo *cate = self.cateInfo.subcategories[btn.tag];
            //  加2算出行数，再加1是因为还要加入全部
            self.cateInfo.cachedHeight2 = (cate.subcategories.count+2+1)/3 * 30;
            self.cateInfo.expandIdx = btn.tag;
            
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kExpandSubCellNotice" object:self];
        
        
//        int row = (int)btn.tag / 3;
//        for (int i = (row+1)*3; i < _cateInfo.subcategories.count; i++)
//        {
//            UIButton *btn = _subBtns[i];
//            [UIView animateKeyframesWithDuration:.3
//                                           delay:0
//                                         options:kNilOptions
//                                      animations:^{
//                btn.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y + 50, btn.frame.size.width, btn.frame.size.height);
//            } completion:nil];
//        }
    }
    
}

@end
