//
//  GetCommentCell.m
//  Teshehui
//
//  Created by macmini5 on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "GetCommentCell.h"
#import "UIColor+hexColor.h"
#import "Masonry.h"
#import "DefineConfig.h"

#define COMMENTLABELFONT 12 // 评论label字体大小
#define TEXTSTRING @"没有评价哦"
// 模拟测试用：
//#define TEXTSTRING @"有时候，我们要固定UILabel的长度，但是显示的内容可能会超过UILabel能显示的最大长度，，有时候，我们要固定UILabel的长度，但是显示的内容可能会超过UILabel能显示的最大长度，，有时候，我们要固定UILabel的长度，但是显示的内容可能会超过UILabel能显示的最大长度，，有时候，我们要固定UILabel的长度，但是显示的内容可能会超过UILabel能显示的最大长度，，有时候，我们要固定UILabel的长度，但是显示的内容可能会超过UILabel能显示的最大长度，，有时候，我们要固定UILabel的长度，但是显示的内容可能会超过UILabel能显示的最大长度，，"

@implementation GetCommentCell
{
    CGFloat _labelHeight;
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return  self;
}

- (void) createUI
{
//    self.backgroundColor = [UIColor yellowColor];
    
    _bgView = [[UIView alloc] init];
    [_bgView setBackgroundColor:[UIColor colorWithHexColor:@"f5f5f5" alpha:1]];
    [self.contentView addSubview:_bgView];
    
    _commentLabel = [[UILabel alloc] init];
    [_commentLabel setNumberOfLines:3];
    [_commentLabel setFont:[UIFont systemFontOfSize:COMMENTLABELFONT]];
    [_commentLabel setTextColor:[UIColor colorWithHexColor:@"343434" alpha:1]];
    [_commentLabel setLineBreakMode:NSLineBreakByTruncatingTail];

    [_bgView addSubview:_commentLabel];
    
    _allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_allButton setTitle:@"查看全部" forState:UIControlStateNormal];
//    [_allButton setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [_allButton setTitleColor:[UIColor colorWithHexColor:@"606060" alpha:1] forState:UIControlStateNormal];
    [[_allButton titleLabel] setFont:[UIFont systemFontOfSize:10]];
    [_allButton addTarget:self action:@selector(annButtonClick) forControlEvents:UIControlEventTouchUpInside];

    [_bgView addSubview:_allButton];
    
    WS(weakSelf);
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(0);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(15);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.bottom.mas_equalTo(_allButton.mas_bottom).offset(5);
    }];
    
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgView.mas_top).offset(10);
        make.left.mas_equalTo(_bgView.mas_left).offset(7);
        make.right.mas_equalTo(_bgView.mas_right).offset(-5);
    }];
    
    [_allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_bgView.mas_right).offset(-7);
        make.top.mas_equalTo(_commentLabel.mas_bottom).offset(0);
    }];
    
}

// 加载UI数据内容
- (void) loadCommentLabelText:(NSString *)textStr
{
    if (textStr == nil)
    {
        textStr = TEXTSTRING;
    }
    NSDictionary *attribute = @{NSFontAttributeName: _commentLabel.font};
    CGFloat labelWidth = kScreen_Width - 40;
    CGRect rect1 = [@"一行文字的高度" boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    CGRect rect2 = [textStr boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    CGFloat width1 = rect1.size.height; // 一行文字的高度
    CGFloat width2 = rect2.size.height;
    // 判断是否超过三行 隐藏查看全部按钮
    if (width1*3 > width2 || width1*3 == width2)
    {
        [self changeUI];
    }
    _commentLabel.text = textStr;
    _labelHeight = rect2.size.height;
    
}
- (void) changeUI
{
    _allButton.hidden = YES;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_commentLabel.mas_bottom).offset(10);
    }];
}

- (void) annButtonClick
{
    if (self.buttonBlock) {
        self.buttonBlock(_labelHeight);
        [_commentLabel setNumberOfLines:0];
        [self changeUI];
    }
}

// 根据文字计算cell的高度
+ (CGFloat)cellHeightWithString:(NSString *)textStr
{
    if (textStr == nil)
    {
        textStr = TEXTSTRING;
    }
    // 注意字体大小 如果_commentLabel 更改 这里也要更改
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:COMMENTLABELFONT]};
    CGFloat labelWidth = kScreen_Width - 40;
    CGRect rect1 = [@"一行文字的高度" boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    CGRect rect2 = [textStr boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    CGFloat width1 = rect1.size.height; // 一行文字的高度
    CGFloat width2 = rect2.size.height;
    // 判断是否超过三行
    if (width1*3 > width2 || width1*3 == width2)
    {
        return width2;
    }
    // 需要加上按钮的高度
    return width1*3 + 20;
}

@end
