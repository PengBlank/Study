//
//  HYCardListHeaderView.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-29.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYCardListHeaderView.h"
#import "HYSelectField.h"
#import "UIImage+ResizableUtil.h"

@implementation HYCardListHeaderView

- (id)initWithFrame:(CGRect)frame organType:(OrganType)organType
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.organType = organType;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self createWithPad];
        } else {
            [self createWithPhone];
        }
    }
    return self;
}

- (void)createWithPad
{
    CGFloat x = 20;
    CGFloat y = 5;
    CGFloat fw = 130;
    CGFloat w = 0;
    CGFloat h = 30;
    
    //订单号
    UILabel *keyLab = [self getKeyLabel];
    NSString *str = @"会员卡号";
    CGSize size = [str sizeWithFont:keyLab.font];
    w = size.width;
    keyLab.frame = CGRectMake(x, y, w, h);
    keyLab.text = str;
    [self addSubview:keyLab];
    
    x += size.width;
    HYStrokeField *field = [self getField];
    field.frame = CGRectMake(x, y, fw, h);
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.returnKeyType = UIReturnKeyGo;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.keyboardType = UIKeyboardTypeNumberPad;
    field.placeholder = @"请输入会员卡号";
    [self addSubview:field];
    _cardNumField = field;
    
    if (_organType == OrganTypeAgency) {
        //操作员
        x += fw + 30;
        y = CGRectGetMinY(keyLab.frame);
        UILabel *proLab = [self getKeyLabel];
        proLab.frame = CGRectMake(x, y, w, h);
        proLab.text = @"操作员";
        [self addSubview:proLab];
        
        x += size.width;
        HYStrokeField *proFld = [self getField];
        proFld.frame = CGRectMake(x, y, fw, h);
        proFld.autocorrectionType = UITextAutocorrectionTypeNo;
        proFld.returnKeyType = UIReturnKeyGo;
        proFld.clearButtonMode = UITextFieldViewModeWhileEditing;
        proFld.placeholder = @"请输入操作员名称";
        [self addSubview:proFld];
        self.premoterField = proFld;
    }
    
    //激活状态
    x += fw + 20;
    UILabel *statLab = [self getKeyLabel];
    str = @"激活状态";
    statLab.frame = CGRectMake(x, y, w, h);
    statLab.text = str;
    [self addSubview:statLab];
    
    x += w + 5;
    UIImage *bg = [UIImage imageNamed:@"order_list_select"];
    bg = [bg utilResizableImageWithCapInsets:UIEdgeInsetsMake(5, 3, 5, 23)];
    UIButton *statBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 100 , h)];
    [statBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [statBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [statBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [statBtn setBackgroundImage:bg forState:UIControlStateNormal];
    statBtn.titleLabel.font = statLab.font;
    [self addSubview:statBtn];
    self.statBtn = statBtn;
    
    //下单时间从
    str = @"激活时间";
    UILabel *fromLab = [self getKeyLabel];
    x = CGRectGetMinX(keyLab.frame);
    y = CGRectGetMaxY(keyLab.frame) + 3;
    w = CGRectGetWidth(keyLab.frame);
    fromLab.frame = CGRectMake(x, y, w, h);
    fromLab.text = str;
    [self addSubview:fromLab];
    
    x += w;
    HYSelectField *fromFld = [[HYSelectField alloc] initWithFrame:CGRectZero];
    fromFld.font = [UIFont systemFontOfSize:16.0];
    fromFld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    fromFld.frame = CGRectMake(x, y, fw, h);
    fromFld.textAlignment = NSTextAlignmentCenter;
    fromFld.placeholder = @"选择起始时间";
    [self addSubview:fromFld];
    self.fromDateField = fromFld;
    
    //至
    UILabel *toLab = [self getKeyLabel];
    str = @"至";
    x = CGRectGetMaxX(fromFld.frame);
    w = CGRectGetWidth(keyLab.frame);
    toLab.frame = CGRectMake(x, y, w, h);
    toLab.text = str;
    [self addSubview:toLab];
    
    x += size.width;
    HYSelectField *toFld = [[HYSelectField alloc] initWithFrame:CGRectZero];
    toFld.font = [UIFont systemFontOfSize:16.0];
    toFld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    toFld.frame = CGRectMake(x, y, fw, h);
    toFld.textAlignment = NSTextAlignmentCenter;
    toFld.placeholder = @"选择结束时间";
    [self addSubview:toFld];
    self.toDateField = toFld;
    
    x += fw + 30;
    w = 70;
    //查询和全部按钮
    UIButton *queryBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [self configureBtn:queryBtn];
    [queryBtn setTitle:@"查询" forState:UIControlStateNormal];
    [queryBtn addTarget:self action:@selector(queryBtnAction:)
       forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:queryBtn];
    
    x += w + 20;
    UIButton *allBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [self configureBtn:allBtn];
    [allBtn setTitle:@"全部" forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(allBtnAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:allBtn];
}

- (void)createWithPhone
{
    CGFloat x = 10;
    CGFloat y = 5;
    CGFloat fw = 100;
    CGFloat w = 50;
    CGFloat h = 30;
    UIFont *font = [UIFont systemFontOfSize:12.0];
    
    HYStrokeField *field = [[HYStrokeField alloc] initWithFrame:CGRectMake(x, y, fw, h)];
    field.font = font;
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field.placeholder = @"输入会员卡号";
    field.textAlignment = NSTextAlignmentCenter;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.returnKeyType = UIReturnKeyGo;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:field];
    _cardNumField = field;
    x += fw + 5;
    
    //操作员
    if (_organType == OrganTypeAgency)
    {
//        UILabel *promoterLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 40, h)];
//        promoterLab.font = font;
//        promoterLab.text = @"操作员";
//        promoterLab.backgroundColor = [UIColor clearColor];
//        [self addSubview:promoterLab];
//        x += 40 + 3;
        
        HYStrokeField *promotersField = [[HYStrokeField alloc] initWithFrame:CGRectMake(x, y, fw, h)];
        promotersField.font = font;
        promotersField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        promotersField.placeholder = @"输入操作员名称";
        promotersField.textAlignment = NSTextAlignmentCenter;
        promotersField.autocorrectionType = UITextAutocorrectionTypeNo;
        promotersField.returnKeyType = UIReturnKeyGo;
        promotersField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:promotersField];
        self.premoterField = promotersField;
        x += fw + 5;
    }
    
//    UILabel *activeLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
//    activeLab.font = font;
//    activeLab.text = @"激活状态";
//    activeLab.backgroundColor = [UIColor clearColor];
//    [self addSubview:activeLab];
//    x += w + 3;
    
    UIImage *bg = [UIImage imageNamed:@"order_list_select"];
    bg = [bg utilResizableImageWithCapInsets:UIEdgeInsetsMake(5, 3, 5, 23)];
    UIButton *statBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 70 , h)];
    [statBtn setTitle:@"激活状态" forState:UIControlStateNormal];
    [statBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [statBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [statBtn setBackgroundImage:bg forState:UIControlStateNormal];
    statBtn.titleLabel.font = font;
    [self addSubview:statBtn];
    self.statBtn = statBtn;
    
    x = 10;
    y += h + 3;
    fw = 80;
    HYSelectField *fromFld = [[HYSelectField alloc] initWithFrame:CGRectMake(x, y, fw, h)];
    fromFld.font = font;
    fromFld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    fromFld.textAlignment = NSTextAlignmentCenter;
    fromFld.placeholder = @"起始时间";
    [self addSubview:fromFld];
    self.fromDateField = fromFld;
    
    x += 2+fw;
    UILabel *toLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 17, h)];
    toLab.font = font;
    toLab.backgroundColor = [UIColor clearColor];
    toLab.text = @"至";
    [self addSubview:toLab];
    
    //至
    x += 2 + 17;
    HYSelectField *toFld = [[HYSelectField alloc] initWithFrame:CGRectMake(x, y, fw, h)];
    toFld.font = font;
    toFld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    toFld.placeholder = @"结束时间";
    toFld.textAlignment = NSTextAlignmentCenter;
    [self addSubview:toFld];
    self.toDateField = toFld;
    
    x += fw + 10;
    w = 50;
    //查询和全部按钮
    UIButton *queryBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [self configureBtn:queryBtn];
    [queryBtn setTitle:@"查询" forState:UIControlStateNormal];
    [queryBtn addTarget:self action:@selector(queryBtnAction:)
       forControlEvents:UIControlEventTouchUpInside];
    queryBtn.titleLabel.font = font;
    [self addSubview:queryBtn];
    
    x += w + 10;
    UIButton *allBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [self configureBtn:allBtn];
    [allBtn setTitle:@"全部" forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(allBtnAction:)
     forControlEvents:UIControlEventTouchUpInside];
    allBtn.titleLabel.font = font;
    [self addSubview:allBtn];
}

- (void)queryBtnAction:(UIButton *)btn
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(headViewDidClickedQueryBtn:)])
    {
        [self.delegate headViewDidClickedQueryBtn:self];
    }
}

- (void)allBtnAction:(UIButton *)btn
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(headViewDidClickedAllBtn:)])
    {
        [self.delegate headViewDidClickedAllBtn:self];
    }
}

- (void)clear
{
    _fromDateField.text = nil;
    _toDateField.text = nil;
    _cardNumField.text = nil;
    _premoterField.text = nil;
    [_statBtn setTitle:@"激活状态" forState:UIControlStateNormal];
    [_statBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
