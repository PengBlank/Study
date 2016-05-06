//
//  HYPremoterListHeaderView.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPremoterListHeaderView.h"
#import "HYSelectField.h"

@implementation HYPremoterListHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self creatWithPad];
        } else {
            [self createWithPhone];
        }
    }
    return self;
}

- (void)creatWithPad
{
    CGFloat x = 20;
    CGFloat y = 5;
    CGFloat fw = 130;
    CGFloat w = 0;
    CGFloat h = 30;
    
    NSString *str = @"创建时间";
    UILabel *premoterLab = [self getKeyLabel];
    CGSize size = [str sizeWithFont:premoterLab.font];
    w = size.width;
    premoterLab.frame = CGRectMake(x, y, w, h);
    premoterLab.text = @"操作员";
    [self addSubview:premoterLab];
    
    x += w;
    UITextField *promoterField = [self getField];
    promoterField.frame = CGRectMake(x, y, fw, h);
    promoterField.autocorrectionType = UITextAutocorrectionTypeNo;
    promoterField.returnKeyType = UIReturnKeyGo;
    promoterField.clearButtonMode = UITextFieldViewModeWhileEditing;
    promoterField.placeholder = @"请输入操作员";
    [self addSubview:promoterField];
    self.promoterField = promoterField;
    
    x += fw + 30;
    UILabel *inviteCodeLab = [self getKeyLabel];
    inviteCodeLab.frame = CGRectMake(x, y, w, h);
    inviteCodeLab.text = @"邀请码";
    [self addSubview:inviteCodeLab];
    
    x += w;
    UITextField *inviteCodeField = [self getField];
    inviteCodeField.frame = CGRectMake(x, y, fw, h);
    inviteCodeField.autocorrectionType = UITextAutocorrectionTypeNo;
    inviteCodeField.returnKeyType = UIReturnKeyGo;
    inviteCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    inviteCodeField.keyboardType = UIKeyboardTypeNumberPad;
    inviteCodeField.placeholder = @"请输入邀请码";
    [self addSubview:inviteCodeField];
    self.inviCodeField = inviteCodeField;
    
    //下单时间从
    str = @"创建时间";
    UILabel *fromLab = [self getKeyLabel];
    x = CGRectGetMinX(premoterLab.frame);
    y = CGRectGetMaxY(premoterLab.frame) + 3;
    w = CGRectGetWidth(premoterLab.frame);
    fromLab.frame = CGRectMake(x, y, w, h);
    fromLab.text = str;
    [self addSubview:fromLab];
    
    x += w;
    UITextField *fromFld = [self getDateField];
    fromFld.frame = CGRectMake(x, y, fw, h);
    fromFld.textAlignment = NSTextAlignmentCenter;
    fromFld.placeholder = @"选择起始时间";
    [self addSubview:fromFld];
    self.fromDateField = fromFld;
    
    //至
    UILabel *toLab = [self getKeyLabel];
    str = @"至";
    x = CGRectGetMaxX(fromFld.frame);
    size = [str sizeWithFont:toLab.font];
    w = size.width + 20;
    toLab.frame = CGRectMake(x, y, w, h);
    toLab.text = str;
    [self addSubview:toLab];
    
    x += w;
    UITextField *toFld = [self getDateField];
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
    CGFloat fw = 80;
    CGFloat w = 45;
    CGFloat h = 30;
    UIFont *font = [UIFont systemFontOfSize:14.0];
    
    //操作员
    UILabel *snLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    snLab.font = font;
    snLab.text = @"操作员";
    snLab.backgroundColor = [UIColor clearColor];
    [self addSubview:snLab];
    x += w + 3;
    
    HYStrokeField *field = [[HYStrokeField alloc] initWithFrame:CGRectMake(x, y, fw, h)];
    field.font = font;
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //field.placeholder = @"输入订单号";
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.returnKeyType = UIReturnKeyGo;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:field];
    _promoterField = field;
    
    //邀请码
    x += fw + 5;
    UILabel *inviteLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    inviteLab.font = font;
    inviteLab.text = @"邀请码";
    inviteLab.backgroundColor = [UIColor clearColor];
    [self addSubview:inviteLab];
    x += w + 3;
    
    HYStrokeField *inviteField = [[HYStrokeField alloc] initWithFrame:CGRectMake(x, y, fw, h)];
    inviteField.font = font;
    inviteField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //promotersField.placeholder = @"输入操作员";
    inviteField.autocorrectionType = UITextAutocorrectionTypeNo;
    inviteField.returnKeyType = UIReturnKeyGo;
    inviteField.clearButtonMode = UITextFieldViewModeWhileEditing;
    inviteField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:inviteField];
    self.inviCodeField = inviteField;
    
    x = 10;
    y += h + 3;
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
    _promoterField.text = nil;
    _fromDateField.text = nil;
    _toDateField.text = nil;
    _inviCodeField.text = nil;
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
