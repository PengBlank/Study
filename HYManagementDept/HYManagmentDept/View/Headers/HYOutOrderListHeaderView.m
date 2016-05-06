//
//  HYOutOrderListHeaderView.m
//  HYManagmentDept
//
//  Created by Ray on 14-12-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYOutOrderListHeaderView.h"
#import "HYStrokeField.h"
#import "HYSelectField.h"

@implementation HYOutOrderListHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [self createAtPad];
        }
        else
        {
            [self createAtPhone];
        }
    }
    return self;
}

- (void)createAtPad
{
    CGFloat x = 20;
    CGFloat y = 5;
    CGFloat fw = 130;
    CGFloat w = 0;
    CGFloat h = 30;
    
    //订单号
    UILabel *keyLab = [self getKeyLabel];
    NSString *str = @"下单时间从";
    CGSize size = [str sizeWithFont:keyLab.font];
    w = size.width;
    keyLab.frame = CGRectMake(x, y, w, h);
    keyLab.text = @"订单号";
    [self addSubview:keyLab];
    
    x += size.width;
    UITextField *field = [self getField];
    field.frame = CGRectMake(x, y, fw, h);
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.returnKeyType = UIReturnKeyGo;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.placeholder = @"请输入订单号";
    [self addSubview:field];
    _orderSnField = field;
    
    //下单时间从
    UILabel *fromLab = [self getKeyLabel];
    x = CGRectGetMinX(keyLab.frame);
    y = CGRectGetMaxY(keyLab.frame) + 3;
    fromLab.frame = CGRectMake(x, y, w, h);
    fromLab.text = str;
    [self addSubview:fromLab];
    
    x += size.width;
    UITextField *fromFld = [self getDateField];
    fromFld.frame = CGRectMake(x, y, fw, h);
    fromFld.textAlignment = NSTextAlignmentCenter;
    fromFld.placeholder = @"选择起始时间";
    [self addSubview:fromFld];
    self.fromDateField = fromFld;
    
    
    y = CGRectGetMaxY(keyLab.frame) + 3;
    UILabel *toLab = [self getKeyLabel];
    str = @"至";
    x = CGRectGetMaxX(fromFld.frame);
    toLab.frame = CGRectMake(x, y, w, h);
    toLab.text = str;
    [self addSubview:toLab];
    
    x += size.width;
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

- (void)createAtPhone
{
    CGFloat x = 10;
    CGFloat y = 5;
    CGFloat fw = 80;
    CGFloat w = 45;
    CGFloat h = 30;
    UIFont *font = [UIFont systemFontOfSize:14.0];
    
    //订单号
    UILabel *snLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    snLab.font = font;
    snLab.text = @"订单号";
    snLab.backgroundColor = [UIColor clearColor];
    [self addSubview:snLab];
    x += w + 3;
    
    HYStrokeField *field = [[HYStrokeField alloc] initWithFrame:CGRectMake(x, y, fw, h)];
    field.font = font;
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.returnKeyType = UIReturnKeyGo;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    //field.placeholder = @"输入订单号";
    [self addSubview:field];
    _orderSnField = field;
    
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

- (void)drawRect:(CGRect)rect
{
    
}
- (void)clear
{
    _fromDateField.text = nil;
    _toDateField.text = nil;
    _orderSnField.text = nil;
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
