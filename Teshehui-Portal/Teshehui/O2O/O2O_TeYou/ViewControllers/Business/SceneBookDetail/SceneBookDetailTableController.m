//
//  SceneBookDetailTableController.m
//  Teshehui
//
//  Created by LiuLeiMacmini on 16/4/9.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "SceneBookDetailTableController.h"
#import "HYUserInfo.h"          // 用户信息头文件
#import "UWDatePickerView.h"

#define CSS_ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString *_strNotChooseDate = @"可不选择日期";
@interface SceneBookDetailTableController ()<UWDatePickerViewDelegate,UITextFieldDelegate>
{
    UWDatePickerView *_pickerView;
}

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;

@end

@implementation SceneBookDetailTableController
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 注册键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _strDate             = _strNotChooseDate;
    _lblName.text        = _detailInfo.packageName;
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    _txtPhone.text       = userInfo.mobilePhone;
    if (userInfo.realName.length > 0) {
        _txtContacts.text = userInfo.realName;
    }
    [self setConsumLabelAttributedText];
}

- (BOOL) dateSelected {
    return ![_btnDate.titleLabel.text isEqualToString:_strNotChooseDate];
}

- (IBAction)btnClick:(id)sender {
    [self.view endEditing:YES];
    [self setupDateView:DateTypeOfStart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 费用标签化字体
- (void) setConsumLabelAttributedText{
    NSMutableAttributedString *attConsum;
    NSString *consum = [NSString stringWithFormat:@"￥%@/份 ",_detailInfo.thsPrice?:@" "];
    attConsum = [[NSMutableAttributedString alloc]initWithString:consum
                                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:CSS_ColorFromRGB(0xb80000)}];
    NSString *point = [NSString stringWithFormat:@"已抵扣%@现金券",_detailInfo.coupon?:@" "];
    NSAttributedString *attPoint = [[NSAttributedString alloc] initWithString:point attributes:@{
                                                                                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:CSS_ColorFromRGB(0x606060)}];
    
    [attConsum appendAttributedString:attPoint];
    _lblPrice.attributedText = attConsum;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1f;
    }
    return 5.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0f;
}
#pragma mark - 日期选择器
// 日期选择器
- (void)setupDateView:(DateType)type {
    
    _pickerView          = [UWDatePickerView instanceDatePickerView];
    _pickerView.frame    = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    _pickerView.delegate = self;
    _pickerView.type     = type;
    [self.view.window.rootViewController.view  addSubview:_pickerView];
    
}
// 回调
- (void)getSelectDate:(NSString *)date type:(DateType)type {
    
    switch (type) {
        case DateTypeOfStart:{
            _strDate = date;
        }break;
            
        case DateTypeOfEnd:{
            _strDate = _strNotChooseDate;
        }break;
        default:
            break;
    }
    
    [self.btnDate setTitle:_strDate forState:UIControlStateNormal];
}
#pragma mark textfiled delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if ([string isEqualToString:@"\n"]) {//按回车可以改变
//        return YES;
//    }
//    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    
//    if ([toBeString length] > 10) {
//        textField.text       = [toBeString substringToIndex:10];
//        return NO;
//    }
//    return YES;
//}
// 键盘事件
-(void)textFieldDidChangeNotification:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 10) {
                textField.text = [toBeString substringToIndex:10];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 10) {
            textField.text = [toBeString substringToIndex:10];
        }
    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//返回YES允许结束并且resign first responder status. 返回NO不许编辑状态结束
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
// 上面返回YES后执行;上面返回NO时有可能强制执行(e.g. view removed from window)
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    // iOS7下不会自动回到顶部　所以加这个操作
    if (self.tableView.contentOffset.y < -15.0f) {
     [self.tableView setContentOffset:CGPointZero];
    }
}

- (void)dealloc{
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}


@end
