//
//  HYMallApplyAfterSaleView.m
//  Teshehui
//
//  Created by Kris on 15/10/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallApplyAfterSaleHeaderView.h"
#import "HYQuantityControl.h"
#import "HYMallAfterSaleInfo.h"
#import "SAMTextView.h"
#import "HYUserInfo.h"

@interface HYMallApplyAfterSaleHeaderView ()
<
UITextFieldDelegate,
UITextViewDelegate,
UIGestureRecognizerDelegate
>
{
    BOOL _typeBtnSelected;
    
    BOOL _isCanApplyReturn;
    BOOL _isCanApplyExchange;
    BOOL _isCanApplyLigthReturn;
}

@property (weak, nonatomic) IBOutlet UIButton *thunder;
@property (weak, nonatomic) IBOutlet UIButton *tuihuo;
@property (weak, nonatomic) IBOutlet UIButton *huanhuo;
@property (weak, nonatomic) IBOutlet SAMTextView *problemDescription;
@property (weak, nonatomic) IBOutlet UILabel *textProgressLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong,nonatomic) NSMutableArray *afterSaleBtns;
@property (nonatomic, strong) HYQuantityControl *quantityControl;  //增加数量

@end

@implementation HYMallApplyAfterSaleHeaderView

- (void)setIsChange:(BOOL)isChange
{
    if (_isChange != isChange) {
        _isChange = isChange;
        _thunder.userInteractionEnabled = !isChange;
        _tuihuo.userInteractionEnabled = !isChange;
        _huanhuo.userInteractionEnabled = !isChange;
        _quantityControl.userInteractionEnabled = !isChange;
    }
}

- (void)setSaleInfo:(HYMallAfterSaleInfo *)saleInfo
{
    _saleInfo = saleInfo;
    if (_saleInfo.operationType.integerValue == 1) {
        _tuihuo.selected = YES;
        _thunder.selected = NO;
        _huanhuo.selected = NO;
    }
    else if (_saleInfo.operationType.integerValue == 2) {   //闪
        _thunder.selected = YES;
        _tuihuo.selected = NO;
        _huanhuo.selected = NO;
    }
    else if (_saleInfo.operationType.integerValue == 3) {   //换
        _thunder.selected = NO;
        _tuihuo.selected = NO;
        _huanhuo.selected = YES;
    }
    _quantityControl.quantity = _saleInfo.useDetail.quantity.integerValue;
    _problemDescription.text = _saleInfo.useDetail.remark;
    [self textViewDidChange:_problemDescription];
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (instancetype)initMyNib
{
    NSArray *subViews = [[NSBundle mainBundle]
                         loadNibNamed:@"HYMallApplyAfterSaleHeaderView" owner:nil options:nil];
    if (subViews.count > 0)
    {
        return subViews[0];
    }
    else
    {
        return nil;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self selector:@selector(changeProgress:) name:UITextViewTextDidChangeNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    _bgView.backgroundColor = [UIColor colorWithWhite:.91 alpha:1.0f];
 
    UIImage *type = [[UIImage imageNamed:@"mall_afterSaleType"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage *typeOn = [[UIImage imageNamed:@"mall_afterSaleType_on"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    [_thunder setBackgroundImage:type forState:UIControlStateNormal];
    [_thunder setBackgroundImage:typeOn forState:UIControlStateSelected];
    [_thunder setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_thunder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_thunder setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_thunder addTarget:self action:@selector(beginAfterSale:) forControlEvents:UIControlEventTouchUpInside];
    _thunder.tag = ThunderRefund;
    [self.afterSaleBtns addObject:_thunder];
    
    [_tuihuo setBackgroundImage:type forState:UIControlStateNormal];
    [_tuihuo setBackgroundImage:typeOn forState:UIControlStateSelected];
    [_tuihuo setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_tuihuo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_tuihuo setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_tuihuo addTarget:self action:@selector(beginAfterSale:) forControlEvents:UIControlEventTouchUpInside];
    _tuihuo.tag = NormalRefund;
    [self.afterSaleBtns addObject:_tuihuo];
    
    [_huanhuo setBackgroundImage:type forState:UIControlStateNormal];
    [_huanhuo setBackgroundImage:typeOn forState:UIControlStateSelected];
    [_huanhuo setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_huanhuo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_huanhuo setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_huanhuo addTarget:self action:@selector(beginAfterSale:) forControlEvents:UIControlEventTouchUpInside];
    _huanhuo.tag = Barter;
    [self.afterSaleBtns addObject:_huanhuo];
    
    //申请数量
    _quantityControl = [[HYQuantityControl alloc]
                        initWithFrame:CGRectMake(80, CGRectGetMaxY(_huanhuo.frame)+15, 150, 40)];
    [_quantityControl addTarget:self action:@selector(quantityChange:) forControlEvents:UIControlEventValueChanged];
    _quantityControl.quantity = 1;
    [_quantityControl setEnabledMinus:YES];
    [self addSubview:_quantityControl];
    
    _problemDescription.delegate = self;
    _problemDescription.placeholder = @"请描述您的问题...";
    _problemDescription.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    _problemDescription.returnKeyType = UIReturnKeyDone;
}

#pragma mark private methods
- (void)beginAfterSale:(UIButton *)sender
{
    for (UIButton *btn in self.afterSaleBtns)
    {
        btn.selected = NO;
        if (sender == btn)
        {
            sender.selected = !sender.isSelected;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(chooseAfteSaleWithType:)])
    {
        [self.delegate chooseAfteSaleWithType:sender.tag];
    }
}

- (void)quantityChange:(HYQuantityControl *)sender
{
    [_quantityControl setEnabledAdd:(_quantityControl.quantity < _returnGoodsInfo.returnableQuantity)];
    
    if ([self.delegate respondsToSelector:@selector(applyAfterSaleQuantity:)])
    {
        [self.delegate applyAfterSaleQuantity:sender.quantity];
    }
}

#pragma mark textview
- (void)textViewDidChange:(UITextView *)textView
{
    
   _textProgressLabel.text = [NSString
                              stringWithFormat:@"%ld/200",_problemDescription.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    _textProgressLabel.text = [NSString
                               stringWithFormat:@"%ld/200",_problemDescription.text.length];
    NSString *result = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (result.length > 200 && ![text isEqualToString:@""])
    {
        return NO;
    }
    //点回车键时调的方法
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(applyAfterSaleProblemDescription:)])
    {
        [self.delegate applyAfterSaleProblemDescription:textView.text];
    }
}

#pragma mark getter and setter
-(NSMutableArray *)afterSaleBtns
{
    if (!_afterSaleBtns)
    {
        _afterSaleBtns = [NSMutableArray array];
    }
    return _afterSaleBtns;
}

-(void)setReturnGoodsInfo:(HYMallOrderItem *)returnGoodsInfo
{
    _returnGoodsInfo = returnGoodsInfo;

    _isCanApplyExchange = _returnGoodsInfo.isCanApplyExchange;
    _isCanApplyLigthReturn = _returnGoodsInfo.isCanApplyLightReturn;
    _isCanApplyReturn = _returnGoodsInfo.isCanApplyReturn;
    
    /// 如果可以闪电退，就直接闪电退，否则只显示退货
    if (_isCanApplyLigthReturn)
    {
        _thunder.hidden = NO;
        _tuihuo.hidden = YES;
    }
    else
    {
        _thunder.hidden = YES;
        _tuihuo.hidden = NO;
    }
    
    [_quantityControl setEnabledAdd:(_quantityControl.quantity < _returnGoodsInfo.returnableQuantity)];
    
    _thunder.enabled = _isCanApplyLigthReturn;
    _tuihuo.enabled = _isCanApplyReturn;
    _huanhuo.enabled = _isCanApplyExchange;
}

#pragma mark gesture
- (void)tapAction
{
    [self endEditing:YES];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(self.frame, location))
    {
        return NO;
    }
    return YES;
}
@end
