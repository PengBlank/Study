//
//  ViewController.m
//  MMMMMMMMM
//
//  Created by wujianming on 16/3/4.
//  Copyright © 2016年 szteyou. All rights reserved.
//

#define kDefaltConstraint 10.0
#define myDotNumbers @"0123456789.\n"
#define myNumbers @"0123456789\n"

#import "CommonPayController.h"
#import "MainViewCell.h"
#import "NSString+Common.h"
#import "UIColor+expanded.h"
#import "HYAlipayOrder.h"
#import "DefineConfig.h"
#import "HYPaymentViewController.h"
#import "METoast.h"
#import "CreatOrderRequest.h"
#import "HYUserInfo.h"
#import "PaySuccessViewController.h"
#import "HYNormalLeakViewController.h"
#import "HYExperienceLeakViewController.h"
@interface CommonPayController ()

@property (weak, nonatomic) IBOutlet UILabel *shopTitle; // 商店名
@property (weak, nonatomic) IBOutlet UILabel *promptMessageTitle; // 提示信息

@property (weak, nonatomic) IBOutlet UITextField *expenditureTextF; // 消费额
@property (weak, nonatomic) IBOutlet UIButton *prompNoDiscountButton; // 请输入不参与折扣按钮
@property (weak, nonatomic) IBOutlet UITextField *noDiscountTextF; // 不参与折扣文本
@property (weak, nonatomic) IBOutlet UICollectionView *discountView; // 折扣列表

@property (weak, nonatomic) IBOutlet UITextField *cashTextF; // 现金
@property (weak, nonatomic) IBOutlet UITextField *couponTextF; // 现金券

@property (weak, nonatomic) IBOutlet UIView *dynamicBackgroundView; // 可伸缩背景视图
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dynamicDiscountViewConstraint;

@property (nonatomic, assign) BOOL isSelectedNoDiscountBtn;
@property (nonatomic, assign) NSInteger seletedIndex;
@property (nonatomic, strong) UIButton *selectedBtn;

@property (weak, nonatomic) IBOutlet UIButton *GoPayButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopH;

@property (nonatomic,strong) CreatOrderRequest  *creatOrderRequest;
@property (nonatomic,strong) NSString  *C2B_Order_Number;
@property (nonatomic,strong) NSString  *O2O_Order_Number;
@property (nonatomic,strong) NSString  *C2B_Order_ID;
//@property (nonatomic,strong) NSString  *payMoney;
//@property (nonatomic,strong) NSString  *payCoupon;
@property (nonatomic,strong) NSString  *inputMoney;
@property (nonatomic,strong) NSString  *inputNoDiscountMoney;
@property (nonatomic,strong) NSString  *disCountValue;
//@property (nonatomic,assign) NSInteger  oldIndex;
@property (weak, nonatomic) IBOutlet UIButton *discountState; // 折扣状态

@end

@implementation CommonPayController

static NSString *_identifier = @"common_mainCell";


- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"支付";
    self.navigationItem.leftBarButtonItem = self.backItemBar;
    _inputMoney = @"";
    _inputNoDiscountMoney = @"";
    
    if (currentDeviceType() == iPhone4_4S || currentDeviceType() == iPhone5_5S) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFrameWithShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFrameWithHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    
    if(self.bdInfo.discounts.count != 0 ){
        _disCount = [NSMutableArray array];
        [_disCount addObjectsFromArray:self.bdInfo.discounts ];
        _disCountValue =  _disCount[0];
    }else{
        _disCountValue =  @"10.0";
    }
    
    [self setupControllerSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIBarButtonItem *)backItemBar{
   return [super backItemBar];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//#pragma mark - collectiondelegate and datasource
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    
//    return self.disCount.count;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    __weak typeof(self) weakSelf = self;
//    MainViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_identifier forIndexPath:indexPath];
//    [cell.btn setTitle:weakSelf.disCountTitle[indexPath.row] forState:UIControlStateNormal];
//    
//    cell.discountCallBack = ^(UIButton *selecteBtn) { //
//        weakSelf.seletedIndex = indexPath.row; // 记录选中下标
//        weakSelf.selectedBtn.selected = NO; // 选中逻辑
//        selecteBtn.selected = YES;
//        weakSelf.selectedBtn = selecteBtn;
//        weakSelf.selectedBtn.tag = indexPath.row;
//        [weakSelf figureConsumeMoney:indexPath.row];
//        
//    };
//    
//    if (_seletedIndex == indexPath.row) { // 折扣复用逻辑，默认0位置为选中
//        cell.btn.selected = YES;
//        _selectedBtn = cell.btn; // 记录选中按钮
//        [self figureConsumeMoney:indexPath.row];
//    }
//    else {
//        cell.btn.selected = NO;
//    }
//    
//    return cell;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    return CGSizeMake((collectionView.bounds.size.width - 5 * 10) / 4 - 0.5, collectionView.bounds.size.height);
//}
//
////定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 10);
//}

#pragma mark - private methods

- (void)setupControllerSubviews
{

    
    if(self.disCount != 0 ){
        [_discountState setTitle:[NSString stringWithFormat:@"享受%@折优惠",_disCountValue] forState:UIControlStateNormal];
        [_discountState setImage:[UIImage imageNamed:@"ico_discount"] forState:UIControlStateNormal];
    }
    
//    [_disCount insertObject:@"10.0" atIndex:0];
    
//    _disCountTitle = [NSMutableArray array];
//    WS(weakSelf);
//    [_disCount enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (idx == 0) {
//            [weakSelf.disCountTitle addObject:@"原价"];
//        }else{
//            [weakSelf.disCountTitle addObject:[NSString stringWithFormat:@"%@折",obj]];
//        }
//        
//    }];
    
    switch (currentDeviceType()) {
        case iPhone4_4S:
            self.titleTopH.constant = 15;
            break;
        case iPhone5_5S:
            self.titleTopH.constant = 25;
            break;
        default:
            break;
    }

    
    _dynamicDiscountViewConstraint.constant = -(_expenditureTextF.bounds.size.height + kDefaltConstraint); // 初始约束
    _noDiscountTextF.alpha = 0; // 不参与折扣初始透明度
    _discountView.backgroundColor = [UIColor whiteColor];
    
    self.shopTitle.text = self.bdInfo.MerchantsName;
    self.promptMessageTitle.textColor = [UIColor colorWithHexString:@"0xb80000"];
    self.GoPayButton.backgroundColor = [UIColor colorWithHexString:@"0xb80000"];
    
    [_discountView registerClass:[MainViewCell class] forCellWithReuseIdentifier:_identifier];
    
    [self addLeftViewWithTitle:@"消费额:" toTextField:_expenditureTextF leftMove:0];
    [self addLeftViewWithTitle:@"不参与优惠金额:" toTextField:_noDiscountTextF leftMove:10];
    [self addLeftViewWithTitle:@"实付现金:" toTextField:_cashTextF leftMove:0];
    [self addLeftViewWithTitle:@"现金券:" toTextField:_couponTextF leftMove:0];
}

- (void)addLeftViewWithTitle:(NSString *)title toTextField:(UITextField *)textF leftMove:(CGFloat)move
{
    CGSize maxSize = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, textF.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName : [UIFont systemFontOfSize:15.0]} context:nil].size;
    UILabel *leftV = [[UILabel alloc] initWithFrame:(CGRect){0,0,maxSize.width + 30 + move,_expenditureTextF.bounds.size.height}];
    leftV.textColor = [UIColor colorWithHexString:@"0x000000"];
    

    
    if (textF == self.noDiscountTextF) {
        textF.textColor = [UIColor colorWithHexString:@"0xb80000"];
    }else{
        textF.textColor = [UIColor colorWithHexString:@"0x606060"];
    }
    
    leftV.font = [UIFont systemFontOfSize:15.0];
    leftV.text = title;
    leftV.textAlignment = NSTextAlignmentCenter;
    textF.layer.cornerRadius = 3;
    textF.layer.borderWidth = 0.5;
    textF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textF.leftView = leftV;
    textF.leftViewMode = UITextFieldViewModeAlways;
    
    if (textF == _cashTextF ) {
        
        UIImageView *mImage = [[UIImageView alloc] initWithFrame:CGRectMake(_cashTextF.frame.size.width - 26.5, (_cashTextF.frame.size.height - 25) / 2, 25, 26.5)];
        [mImage setImage:[UIImage imageNamed:@"icon-money"]];
        textF.rightView = mImage;
        textF.rightViewMode = UITextFieldViewModeAlways;
    }else if (textF == _couponTextF){
        UIImageView *mImage = [[UIImageView alloc] initWithFrame:CGRectMake(_cashTextF.frame.size.width - 26.5, (_cashTextF.frame.size.height - 25) / 2, 25, 26.5)];
        [mImage setImage:[UIImage imageNamed:@"icon-discount"]];
        textF.rightView = mImage;
        textF.rightViewMode = UITextFieldViewModeAlways;
    }
}

- (IBAction)prompNoDiscountBtnDidClick:(id)sender {
    _prompNoDiscountButton.selected = !_isSelectedNoDiscountBtn;
    _isSelectedNoDiscountBtn = _prompNoDiscountButton.selected;
    
    WS(weakSelf)
    if (_prompNoDiscountButton.selected) {

        [UIView animateWithDuration:0.25 animations:^{
             weakSelf.dynamicDiscountViewConstraint.constant = kDefaltConstraint;
             weakSelf.noDiscountTextF.alpha = 1;
            [ weakSelf.view layoutIfNeeded];
        }];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.dynamicDiscountViewConstraint.constant = -_noDiscountTextF.bounds.size.height;
            weakSelf.noDiscountTextF.alpha = 0;
            [weakSelf.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            weakSelf.noDiscountTextF.text = @"";
            weakSelf.inputNoDiscountMoney = @"";
            [weakSelf figureConsumeMoney:0];
            
        }];
    }
}

- (void)figureConsumeMoney:(NSInteger)index{
    
    
    NSString *money = [self.expenditureTextF text];
    NSString *noDiscount = [self.noDiscountTextF text];

    if ([money floatValue] >= [noDiscount floatValue]) {
        
        self.cashTextF.text = [NSString stringWithFormat:@"%.2f", (([money floatValue] - [noDiscount floatValue]) *[_disCountValue floatValue] * 0.1 + [noDiscount floatValue])];

        
        NSString *pay = [NSString stringWithFormat:@"%.2f", ([money floatValue] - [noDiscount floatValue]) * (1 - [_disCountValue floatValue] * 0.1)];
        
        self.couponTextF.text = [NSString stringWithFormat:@"%d", (int)([pay floatValue] + 0.5)];
        
    }
    else {
        self.cashTextF.text = @"";
        self.couponTextF.text = @"";
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.expenditureTextF) {
        
        textField.layer.cornerRadius = 3;
        textField.layer.borderWidth = 0.5;
        textField.layer.borderColor = [UIColor colorWithHexString:@"0xb80000"].CGColor;
        
        self.cashTextF.layer.cornerRadius = 3;
        self.cashTextF.layer.borderWidth = 0.5;
        self.cashTextF.layer.borderColor = [UIColor colorWithHexString:@"0xbfbfbf"].CGColor;
        
        self.noDiscountTextF.layer.cornerRadius = 3;
        self.noDiscountTextF.layer.borderWidth = 0.5;
        self.noDiscountTextF.layer.borderColor = [UIColor colorWithHexString:@"0xbfbfbf"].CGColor;
        
        self.couponTextF.layer.cornerRadius = 3;
        self.couponTextF.layer.borderWidth = 0.5;
        self.couponTextF.layer.borderColor = [UIColor colorWithHexString:@"0xbfbfbf"].CGColor;
        
    }else if (textField == self.cashTextF){
        
        if (currentDeviceType() == iPhone4_4S) {
             [self changeTheViewFrameWitTextField:self.cashTextF];
        }
   
        textField.layer.cornerRadius = 3;
        textField.layer.borderWidth = 0.5;
        textField.layer.borderColor = [UIColor colorWithHexString:@"0xb80000"].CGColor;
        
        self.expenditureTextF.layer.cornerRadius = 3;
        self.expenditureTextF.layer.borderWidth = 0.5;
        self.expenditureTextF.layer.borderColor = [UIColor colorWithHexString:@"0xbfbfbf"].CGColor;
        
        self.noDiscountTextF.layer.cornerRadius = 3;
        self.noDiscountTextF.layer.borderWidth = 0.5;
        self.noDiscountTextF.layer.borderColor = [UIColor colorWithHexString:@"0xbfbfbf"].CGColor;
        
        self.couponTextF.layer.cornerRadius = 3;
        self.couponTextF.layer.borderWidth = 0.5;
        self.couponTextF.layer.borderColor = [UIColor colorWithHexString:@"0xbfbfbf"].CGColor;
    }else if (textField == self.noDiscountTextF) {
        
        if (currentDeviceType() == iPhone4_4S) {
            [self changeTheViewFrameWitTextField:self.noDiscountTextF];
        }
        
        textField.layer.cornerRadius = 3;
        textField.layer.borderWidth = 0.5;
        textField.layer.borderColor = [UIColor colorWithHexString:@"0xb80000"].CGColor;
        
        self.expenditureTextF.layer.cornerRadius = 3;
        self.expenditureTextF.layer.borderWidth = 0.5;
        self.expenditureTextF.layer.borderColor = [UIColor colorWithHexString:@"0xbfbfbf"].CGColor;
        
        self.cashTextF.layer.cornerRadius = 3;
        self.cashTextF.layer.borderWidth = 0.5;
        self.cashTextF.layer.borderColor = [UIColor colorWithHexString:@"0xbfbfbf"].CGColor;
        
        self.couponTextF.layer.cornerRadius = 3;
        self.couponTextF.layer.borderWidth = 0.5;
        self.couponTextF.layer.borderColor = [UIColor colorWithHexString:@"0xbfbfbf"].CGColor;

    }else{
        if (currentDeviceType() == iPhone4_4S) {
            [self changeTheViewFrameWitTextField:self.couponTextF];
        }
        
        textField.layer.cornerRadius = 3;
        textField.layer.borderWidth = 0.5;
        textField.layer.borderColor = [UIColor colorWithHexString:@"0xb80000"].CGColor;
        
        self.expenditureTextF.layer.cornerRadius = 3;
        self.expenditureTextF.layer.borderWidth = 0.5;
        self.expenditureTextF.layer.borderColor = [UIColor colorWithHexString:@"0xbfbfbf"].CGColor;
        
        self.cashTextF.layer.cornerRadius = 3;
        self.cashTextF.layer.borderWidth = 0.5;
        self.cashTextF.layer.borderColor = [UIColor colorWithHexString:@"0xbfbfbf"].CGColor;
        
        self.noDiscountTextF.layer.cornerRadius = 3;
        self.noDiscountTextF.layer.borderWidth = 0.5;
        self.noDiscountTextF.layer.borderColor = [UIColor colorWithHexString:@"0xbfbfbf"].CGColor;
    }
    
    return YES;
}
//
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    
    if (textField.text.length > 8 && range.length != 1) {
        return NO;
    }
    
    if (textField == self.expenditureTextF) {
        
         [self YesOrNo:textField range:range string:string];
        
        if (string.length >= 1) {
            _cashTextF.userInteractionEnabled = NO;
           // _cashTextF.textColor = [UIColor colorWithHexString:@"0x606060"];
            
            _couponTextF.userInteractionEnabled = NO;
           // _couponTextF.textColor = [UIColor colorWithHexString:@"0x606060"];
        }
        
        if (range.length == 1) {
            _inputMoney = [_inputMoney stringByReplacingCharactersInRange:NSMakeRange(_inputMoney.length - 1, 1) withString:@""];
            if (_inputMoney.length == 0) {
                _cashTextF.userInteractionEnabled = YES;
                //_cashTextF.textColor = [UIColor colorWithHexString:@"0xbfbfbf"];
                
                _couponTextF.userInteractionEnabled = YES;
              //  _couponTextF.textColor = [UIColor colorWithHexString:@"0xbfbfbf"];
            }
        }else{
            _inputMoney = [NSString stringWithFormat:@"%@%@",_inputMoney,string];
        }
        NSString *noDiscount = [self.noDiscountTextF text];

        
        if ([_inputMoney floatValue] >= [noDiscount floatValue]) {
            
            NSString *payMoney = [NSString stringWithFormat:@"%.2f", (([_inputMoney floatValue] - [noDiscount floatValue]) *[_disCountValue floatValue] * 0.1 + [noDiscount floatValue])];
            
            self.cashTextF.text = payMoney;
            
            
            NSString *pay = [NSString stringWithFormat:@"%.2f", ([_inputMoney floatValue] - [noDiscount floatValue]) * (1 - [_disCountValue floatValue] * 0.1)];
            
            self.couponTextF.text = [NSString stringWithFormat:@"%d", (int)([pay floatValue] + 0.5)];
            
        }
        else {
            self.cashTextF.text = @"";
            self.couponTextF.text = @"";
        }
       
    }
    else if (textField == _noDiscountTextF) {

         [self YesOrNo:textField range:range string:string];
        
        if (textField.text.length >= 1) {
            _cashTextF.userInteractionEnabled = NO;
         //   _cashTextF.textColor = [UIColor colorWithHexString:@"0x606060"];
            
            _couponTextF.userInteractionEnabled = NO;
            //_couponTextF.textColor = [UIColor colorWithHexString:@"0x606060"];
        }else{
            _cashTextF.userInteractionEnabled = YES;
           // _cashTextF.textColor = [UIColor colorWithHexString:@"0x606060"];
            
            _couponTextF.userInteractionEnabled = YES;
            //_couponTextF.textColor = [UIColor colorWithHexString:@"0x606060"];
        }
        
        if (range.length == 1) {
            _inputNoDiscountMoney = [_inputNoDiscountMoney stringByReplacingCharactersInRange:
                                     NSMakeRange(_inputNoDiscountMoney.length - 1, 1) withString:@""];
        }else{
            _inputNoDiscountMoney = [NSString stringWithFormat:@"%@%@",_inputNoDiscountMoney,string];
        }
        
        if ([_inputMoney floatValue] >= [_inputNoDiscountMoney floatValue]) {
            
            self.cashTextF.text = [NSString stringWithFormat:@"%.2f", (([_inputMoney floatValue] - [_inputNoDiscountMoney floatValue])
                                                                       *[_disCountValue floatValue] * 0.1 + [_inputNoDiscountMoney floatValue])];
            
            
            NSString *pay = [NSString stringWithFormat:@"%.2f", ([_inputMoney floatValue] - [_inputNoDiscountMoney floatValue])
                             * (1 - [_disCountValue floatValue] * 0.1)];
            
            self.couponTextF.text = [NSString stringWithFormat:@"%d", (int)([pay floatValue] + 0.5)];
            
        }
        else {
            self.cashTextF.text = @"";
            self.couponTextF.text = @"";
        }
        
    }
    else if (textField == _cashTextF){
        
        [self YesOrNo:textField range:range string:string];
    }
    else{
    
        if (![string isPureInt] && range.length != 1) {
            return NO;
        }
    }
    
    
    return YES;
}

- (BOOL)YesOrNo:(UITextField *)textField range:(NSRange)range string:(NSString *)string{

    NSCharacterSet *cs;
    NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
    
    
    if (NSNotFound == nDotLoc && 0 != range.location) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers]invertedSet];
        if ([string isEqualToString:@"."]) {
            return YES;
        }
        if (textField.text.length >= 13) {
            return NO;
        }
    }
    else {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers]invertedSet];
        if (textField.text.length >= 13) {
            return  NO;
        }
    }
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        return NO;
    }
    if (NSNotFound != nDotLoc && range.location > nDotLoc + 2) { // 小数点后面两位
        return NO;
    }
    if (NSNotFound != nDotLoc && range.location > nDotLoc) {
        if ([string isEqualToString:@"."]) {
            return NO;
        }
    }
    
    return YES;

}


- (IBAction)goPayButtonDidclick { // 去支付事件处理
    
    
    [self.view endEditing:YES];
    
    
    if (self.cashTextF.text.floatValue == 0 && self.couponTextF.text.floatValue == 0) { //两个都没有，不让生成订单
        [METoast toastWithMessage:@"请输入有效金额或现金券"];
        return;
    }
    
   self.view.userInteractionEnabled = NO;
    
    [HYLoadHubView show];
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    
    self.creatOrderRequest = [[CreatOrderRequest alloc] init];
    self.creatOrderRequest.interfaceURL     = [NSString stringWithFormat:@"%@/TSHOrder/Create",ORDER_API_URL_V3];
    self.creatOrderRequest.interfaceType = DotNET2;
    self.creatOrderRequest.postType      = JSON;
    self.creatOrderRequest.httpMethod    = @"POST";
    
    self.creatOrderRequest.Coupon           = self.couponTextF.text.integerValue;
    self.creatOrderRequest.Amount           = self.cashTextF.text.doubleValue;
    self.creatOrderRequest.userId           = userInfo.userId;
    self.creatOrderRequest.UserName         = userInfo.realName.length == 0 ? userInfo.mobilePhone : userInfo.realName;
    self.creatOrderRequest.Mobile           = userInfo.mobilePhone ? : @"";
    self.creatOrderRequest.CardNo           = userInfo.number? : @"";
    self.creatOrderRequest.MerId            = self.bdInfo.MerId ? :@"";
    self.creatOrderRequest.MerchantName     = self.bdInfo.MerchantsName ? : @"";
    self.creatOrderRequest.MerchantLogo     = self.bdInfo.Logo ? :@"";
    self.creatOrderRequest.productName      = @"TSHAPP";
    
    self.creatOrderRequest.first_area_id    = self.bdInfo.first_area_id;
    self.creatOrderRequest.second_area_id   = self.bdInfo.second_area_id;
    self.creatOrderRequest.third_area_id    = self.bdInfo.third_area_id;
    self.creatOrderRequest.fourth_area_id   = self.bdInfo.fourth_area_id;
    
    WS(weakSelf);
    [self.creatOrderRequest sendReuqest:^(id result, NSError *error)
     {
         [HYLoadHubView dismiss];
         [weakSelf.view endEditing:YES];
         if(result){
             NSDictionary *objDic = [result jsonDic];
             
             int code = [objDic[@"code"] intValue];
             if (code == 0) { //状态值为0 代表请求成功  其他为失败
                 NSDictionary *objKeyValue = objDic[@"data"];
                 
                 weakSelf.C2B_Order_Number = objKeyValue[@"c2b_trade_no"];
                 weakSelf.O2O_Order_Number = objKeyValue[@"o2o_trade_no"];
                 weakSelf.C2B_Order_ID     = objKeyValue[@"c2b_order_id"];
                 
                 if(weakSelf.cashTextF.text.floatValue == 0 && weakSelf.couponTextF.text.floatValue != 0){  //此时说明用户只用现金券支付 服务器会直接扣除 不需要跳转支付页面
                     
                     PaySuccessViewController *tmpCtrl = [[PaySuccessViewController alloc] init];
                     tmpCtrl.merId = weakSelf.bdInfo.MerId;
                     tmpCtrl.storeName = weakSelf.bdInfo.MerchantsName;
                     tmpCtrl.coupon = weakSelf.couponTextF.text;
                     tmpCtrl.O2O_OrderNo = weakSelf.O2O_Order_Number;
                     tmpCtrl.orderType = @"1";
                     tmpCtrl.payType = BusinessPay;
                     [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
                     
                 }else{
                     [weakSelf gotoPay];
                 }
                 
             }else{
                 NSString *msg = objDic[@"msg"];
                 
                 if([msg isEqualToString:@"现金券不足"]){
                     /*** 这里进行现金券不足页面跳转 页面由总部那边提供***/
                     
                     if ([HYUserInfo getUserInfo].userLevel == 0) { //体验用户跳转到体验用户的页面
                         HYExperienceLeakViewController *vc = [[HYExperienceLeakViewController alloc] init];
                         [weakSelf.navigationController pushViewController:vc animated:YES];
                     }
                     else {//正式会员用户跳转到正式会员的页面
                         HYNormalLeakViewController *vc = [[HYNormalLeakViewController alloc] init];
                         vc.pushType = @"O2O";
                         [weakSelf.navigationController pushViewController:vc animated:YES];
                     }
                     
                 }else{
                     [METoast toastWithMessage:msg];
                 }
             }
         }else{
             [METoast toastWithMessage:@"服务器请求异常"];
         }
         
          self.view.userInteractionEnabled = YES;
     }];

    

}

- (void)gotoPay{
    HYAlipayOrder *alOrder = [[HYAlipayOrder alloc] init];
    alOrder.partner = PartnerID;
    alOrder.seller = SellerID;
    alOrder.tradeNO = self.C2B_Order_Number; //订单号 (显示订单号)
    alOrder.productName = [NSString stringWithFormat:@"【特奢汇】O2O商家订单: %@", self.C2B_Order_Number]; //商品标题 (显示订单号)
    alOrder.productDescription = [NSString stringWithFormat:@"【特奢汇】O2O商家订单: %@", self.C2B_Order_Number]; //商品描述
    alOrder.amount = [NSString stringWithFormat:@"%0.2f",self.cashTextF.text.floatValue]; //商品价格
    
    HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
    payVC.navbarTheme = self.navbarTheme;
    payVC.alipayOrder = alOrder;
    payVC.amountMoney = self.cashTextF.text;   //付款总额
    payVC.point = self.couponTextF.text.floatValue;     //  现金券
    payVC.orderID = self.C2B_Order_ID;          //用户获取银联支付流水号
    payVC.orderCode = self.C2B_Order_Number;        //订单号
    payVC.type = Pay_O2O_QRScan;
    payVC.O2OpayType = BusinessPay;
    
    __weak typeof(self) weakSelf = self;
    [payVC setBusinessPaymentSuccess:^(O2OPayType type) {
        
        [weakSelf pushPaySuccessWithType:type];
        
    }];
    
    [self.navigationController pushViewController:payVC animated:YES];
}
//　回调支付成功
- (void)pushPaySuccessWithType:(O2OPayType)type{
    
    PaySuccessViewController *tmpCtrl = [[PaySuccessViewController alloc] init];
    tmpCtrl.merId = self.bdInfo.MerId;
    tmpCtrl.storeName = self.bdInfo.MerchantsName;
    tmpCtrl.money = self.cashTextF.text;//[NSString stringWithFormat:@"%.2f",self.payMoney.floatValue];
    tmpCtrl.O2O_OrderNo = self.O2O_Order_Number;
    tmpCtrl.payType = type;
    tmpCtrl.orderType = @"1"; //1 代表商家订单
    if (self.couponTextF.text.floatValue != 0) {
        tmpCtrl.coupon = self.couponTextF.text;
    }
    [self.navigationController pushViewController:tmpCtrl animated:YES];
    
}

#pragma mark 键盘事件处理

- (void)changeFrameWithShow:(NSNotification *)notifi
{
    
    self.GoPayButton.hidden = YES;
    

    CGFloat height;
    switch (currentDeviceType()) {
        case iPhone4_4S:
            height = 0;
            return;
            break;
        case iPhone5_5S:
            height = 84;
            break;
        case iPhone6:
            height = 64;
            break;
            
        default:
            height = 64;
            break;
    }

    
    WS(weakSelf);
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.view.transform = CGAffineTransformMakeTranslation(0, - height);
    }];
}

- (void)changeFrameWithHide:(NSNotification *)notifi
{
    self.GoPayButton.hidden = NO;
    WS(weakSelf);
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.view.transform = CGAffineTransformIdentity;
    }];

}

- (void)changeTheViewFrameWitTextField:(UITextField *)textField{
    
    WS(weakSelf);
    if (textField == _noDiscountTextF) {
        [UIView animateWithDuration:0.25 animations:^{
           weakSelf.view.transform = CGAffineTransformMakeTranslation(0, -60);
        }];
        
    }else if (textField == _cashTextF){
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.view.transform = CGAffineTransformMakeTranslation(0, _prompNoDiscountButton.selected ? -110 : -70);
        }];
    }else if (textField == _couponTextF){
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.view.transform = CGAffineTransformMakeTranslation(0,_prompNoDiscountButton.selected ? -160 : -120);
        }];
    }else {
    
    }
}

- (void)dealloc{
    if (currentDeviceType() != iPhone6Plus) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    [_creatOrderRequest cancel];
    _creatOrderRequest = nil;
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));

}


@end
