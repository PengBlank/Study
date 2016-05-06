//
//  HYMallSearchResultHeaderView.m
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallSearchResultHeaderView.h"

@interface HYMallSearchResultHeaderView ()

@property (nonatomic, strong) UILabel *cateLabel;   //当前选择分类

//@property (nonatomic, strong) UIButton *cateBtn;
@property (nonatomic, strong) NSArray *cateBtns;

@property (nonatomic, strong) UIButton *goToMakeWishBtn;
@property (nonatomic, strong) UIImageView *searchResultNoGoodsImgView;

@end

@implementation HYMallSearchResultHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(frame)-1, CGRectGetWidth(frame), 1)];
        v.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
        v.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:v];

    }
    return self;
}

- (void)setConditions:(NSArray *)conditions
{
    if (_conditions != conditions)
    {
        self.cateLabel.hidden = NO;
//        self.cateBtn.hidden = NO;
        [self clearConditionBtns];
        NSString *cateTitle = @"当前选择分类:";
        CGSize size = [cateTitle sizeWithFont:self.cateLabel.font];
        CGRect frame = _cateLabel.frame;
        frame.size.width = size.width;
        _cateLabel.frame = frame;
        _cateLabel.text = cateTitle;
        
        UIFont *font = [UIFont systemFontOfSize:13.0];
        CGFloat or_y = 0;
        CGFloat or_x = CGRectGetMaxX(_cateLabel.frame) + 5;
        NSMutableArray *btns = [NSMutableArray array];
        for (NSString *condition in conditions)
        {
            size = [condition sizeWithFont:font];
            CGRect frame;
            frame.origin.x = or_x;
            if (or_x + frame.size.width >= self.frame.size.width-2)
            {
                or_x = 0;
                or_y += 30 + 5;
            }
            frame.origin.y = or_y;
            frame.size.width = size.width + 20;
            frame.size.height = 30;
            
            or_x += frame.size.width;   //向右移动
            
            UIButton *cateBtn = [[UIButton alloc] initWithFrame:frame];
            UIImage *bg = [UIImage imageNamed:@"search_cate_del_bg"];
            bg = [bg resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
            [cateBtn setBackgroundImage:bg forState:UIControlStateNormal];
            [cateBtn setImage:[UIImage imageNamed:@"search_cate_del"] forState:UIControlStateNormal];
            cateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, size.width+5, 0, 0);
            cateBtn.titleLabel.font = font;
            [cateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
            [cateBtn setTitleColor:[UIColor colorWithWhite:.73 alpha:1] forState:UIControlStateNormal];
            [cateBtn setTitle:condition forState:UIControlStateNormal];
            [cateBtn addTarget:self
                        action:@selector(cateBtnAction:)
              forControlEvents:UIControlEventTouchUpInside];
            cateBtn.tag = 100 + [conditions indexOfObject:condition];
            [self addSubview:cateBtn];
            [btns addObject:cateBtn];
        }
        self.cateBtns = [NSArray arrayWithArray:btns];
        frame = self.frame;
        frame.size.height = or_y + 30 + 5;;
        self.frame = frame;
    }
}

//- (void)setCate:(HYMallCategoryInfo *)cate
//{
//    if (_cate != cate)
//    {
//        _cate = cate;
//        
//        self.cateLabel.hidden = NO;
//        self.cateBtn.hidden = NO;
//        NSString *cateTitle = @"当前选择分类:";
//        CGSize size = [cateTitle sizeWithFont:self.cateLabel.font];
//        CGRect frame = _cateLabel.frame;
//        frame.size.width = size.width;
//        _cateLabel.frame = frame;
//        _cateLabel.text = cateTitle;
//        
//        UIFont *font = [UIFont systemFontOfSize:13.0];
//        size = [cate.cate_name sizeWithFont:font];
//        frame = self.cateBtn.frame;
//        frame.origin.x = CGRectGetMaxX(_cateLabel.frame) + 5;
//        frame.size.width = size.width + 20;
//        [_cateBtn setTitle:cate.cate_name forState:UIControlStateNormal];
//        _cateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, size.width+5, 0, 0);
//        _cateBtn.titleLabel.font = font;
//        self.cateBtn.frame = frame;
//        
//        frame = self.frame;
//        frame.size.height = 40;
//        self.frame = frame;
//    }
//}

- (UILabel *)cateLabel
{
    if (!_cateLabel) {
        UIFont *font = [UIFont systemFontOfSize:14.0];
        _cateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 9, 85, font.lineHeight)];
        _cateLabel.backgroundColor = [UIColor clearColor];
        _cateLabel.textColor = [UIColor colorWithWhite:.73 alpha:1];
        _cateLabel.font = font;
        _cateLabel.numberOfLines = 0;
        //_cateLabel.hidden = YES;
        [self addSubview:_cateLabel];
    }
    return _cateLabel;
}

//- (UIButton *)cateBtn
//{
//    if (!_cateBtn) {
//        UIButton *cateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, 60, 30)];
//        UIImage *bg = [UIImage imageNamed:@"search_cate_del_bg"];
//        bg = [bg resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
//        [cateBtn setBackgroundImage:bg forState:UIControlStateNormal];
//        [cateBtn setImage:[UIImage imageNamed:@"search_cate_del"] forState:UIControlStateNormal];
//        [cateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
//        [cateBtn setTitleColor:[UIColor colorWithWhite:.73 alpha:1] forState:UIControlStateNormal];
//        [cateBtn addTarget:self
//                    action:@selector(cateBtnAction:)
//          forControlEvents:UIControlEventTouchUpInside];
//        //cateBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
//        _cateBtn = cateBtn;
//        [self addSubview:_cateBtn];
//    }
//    return _cateBtn;
//}

- (void)cateBtnAction:(UIButton*)btn
{
    if (self.delegate && [_delegate respondsToSelector:@selector(clearConditionAtIndex:)])
    {
        [_delegate clearConditionAtIndex:btn.tag-100];
    }
}

- (void)setCateBtnShow:(BOOL)show
{
    for (UIButton *btn in _cateBtns)
    {
        btn.hidden = !show;
    }
}

- (void)clearConditionBtns
{
    for (UIButton *btn in _cateBtns)
    {
        [btn removeFromSuperview];
    }
}

- (void)setCorrectName:(NSString *)correctName withWrongName:(NSString *)wrongName
{
    self.cateLabel.hidden = NO;
    [self setCateBtnShow:NO];
    
    NSString *title = [NSString stringWithFormat:@"亲，你是不是要找%@。仍然搜索:", correctName];
    NSInteger len = title.length;
    title = [title stringByAppendingString:wrongName];
    CGSize size = [title sizeWithFont:self.cateLabel.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame)-30, 80)];
    CGRect frame = _cateLabel.frame;
    frame.size = size;
    _cateLabel.frame = frame;
    frame = self.frame;
    frame.size.height = size.height + 15;
    self.frame = frame;
    if ([self.cateLabel respondsToSelector:@selector(setAttributedText:)])
    {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
        NSRange range = NSMakeRange(len, wrongName.length);
        [attr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithBool:YES] range:range];
        [attr addAttribute:NSUnderlineColorAttributeName value:[UIColor blueColor] range:range];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
        [_cateLabel setAttributedText:attr];
    }
    else
    {
        _cateLabel.text = title;
    }
    
    _cateLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(correctTapAction:)];
    [_cateLabel addGestureRecognizer:tap];
}

- (void)correctTapAction:(UITapGestureRecognizer *)tap
{
    [_cateLabel removeGestureRecognizer:tap];
    if (_delegate && [_delegate respondsToSelector:@selector(reloadWithCorrect)])
    {
        [_delegate reloadWithCorrect];
    }
}

- (void)setNull
{
    _cateLabel.hidden = NO;
    [self setCateBtnShow:NO];
    NSString *title = [NSString stringWithFormat:@"抱歉，没有找到宝贝，快去告诉我们的小秘书帮你买吧~~~~"];
    _cateLabel.numberOfLines = 2;
    CGSize size = [title sizeWithFont:self.cateLabel.font];
    _cateLabel.frame = CGRectMake(TFScalePoint(100), 20, size.width/2 + 10, size.height*2);
    
    if (!_searchResultNoGoodsImgView) {
        UIImage *img = [UIImage imageNamed:@"searchFail"];
        _searchResultNoGoodsImgView = [[UIImageView alloc] initWithImage:img];
        _searchResultNoGoodsImgView.frame = CGRectMake(CGRectGetMinX(_cateLabel.frame) - 80, 10, img.size.width, img.size.height);
        [self addSubview:_searchResultNoGoodsImgView];
    }
    
    if (!_goToMakeWishBtn) {
        _goToMakeWishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goToMakeWishBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_goToMakeWishBtn setTitle:@"帮我买" forState:UIControlStateNormal];
        [_goToMakeWishBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _goToMakeWishBtn.layer.borderWidth = 1;
        _goToMakeWishBtn.layer.borderColor = [UIColor redColor].CGColor;
        _goToMakeWishBtn.layer.cornerRadius = 5;
        _goToMakeWishBtn.frame = CGRectMake(TFScalePoint(120), CGRectGetMaxY(_cateLabel.frame)+10, 80, 25);
        [_goToMakeWishBtn addTarget:self action:@selector(gotoMakeWishBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_goToMakeWishBtn];
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_goToMakeWishBtn.frame)+10, ScreenRect.size.width, 40)];
    bottomView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self addSubview:bottomView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-30, 10, 60, 20)];
    label.text = @"别人都在买";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor grayColor];
    [bottomView addSubview:label];
    
    UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, CGRectGetMinX(label.frame)-20, 1)];
    leftLineView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    [bottomView addSubview:leftLineView];
    
    UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10, 20, leftLineView.frame.size.width, 1)];
    rightLineView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    [bottomView addSubview:rightLineView];
    
//    CGSize size = [title sizeWithFont:self.cateLabel.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame)-30, 80)];
//    CGRect frame = _cateLabel.frame;
//    frame.size = size;
//    _cateLabel.frame = frame;
//    frame = self.frame;
//    frame.size.height = size.height + 15;
//    self.frame = frame;
    
    
//    NSInteger len = title.length;
//    NSString *research = @"重新搜索";
//    title = [title stringByAppendingString:research];
//    title = [title stringByAppendingString:@"\n别人都在买..."];
//    CGSize size = [title sizeWithFont:self.cateLabel.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame)-30, 80)];
//    CGRect frame = _cateLabel.frame;
//    frame.size = size;
//    _cateLabel.frame = frame;
//    frame = self.frame;
//    frame.size.height = size.height + 15;
//    self.frame = frame;
//    if ([self.cateLabel respondsToSelector:@selector(setAttributedText:)])
//    {
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
//        NSRange range = NSMakeRange(len, research.length);
//        [attr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithBool:YES] range:range];
//        [attr addAttribute:NSUnderlineColorAttributeName value:[UIColor redColor] range:range];
//        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
//        [_cateLabel setAttributedText:attr];
//    }
//    else
//    {
//        _cateLabel.text = title;
//    }
    _cateLabel.text = title;
    self.frame = CGRectMake(0, 0, ScreenRect.size.width, CGRectGetMaxY(bottomView.frame));
}

- (void)setHide
{
    CGRect frame = self.frame;
    frame.size.height = 0;
    self.frame = frame;
    _cate = nil;
}

- (void)gotoMakeWishBtnDidClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(goToMakeWish)]) {
        [self.delegate goToMakeWish];
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
