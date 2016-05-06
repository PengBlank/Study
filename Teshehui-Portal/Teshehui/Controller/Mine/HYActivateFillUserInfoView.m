//
//  HYActivateFillUserInfoView.m
//  Teshehui
//
//  Created by 成才 向 on 16/1/9.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYActivateFillUserInfoView.h"
#import "HYDatePickerView.h"
#import "HYLoginV2InputCell.h"
#import "HYLoginV2RadioCell.h"
#import "HYLoginV2SelectCell.h"
#import "HYLoginV2CheckCell.h"
#import "HYBaseLineHeadView.h"
#import "NSDate+Addition.h"
#import "NSString+Addition.h"
#import "HYCardType.h"
#import "HYPickerToolView.h"
#import "METoast.h"

@interface HYActivateFillUserInfoView ()

<UITableViewDataSource,
UITableViewDelegate,
HYDatePickerViewDelegate,
UITextFieldDelegate>

{
    BOOL _isAgree;
    
    HYDatePickerView *_datePicker;
    
    HYPickerToolView *_dataPicker;
}

@property (nonatomic, strong) UIButton *agreeCheckBtn;
@property (nonatomic, strong) UIButton *agreeTranscationBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic)  UIButton *agreeActivationBtn;
@property (strong, nonatomic)  UIButton *noInsuranceBtn;
@property (strong, nonatomic)  UILabel *userNeedToKnow1;
@property (strong, nonatomic)  UILabel *userNeedToKnow2;

@end

@implementation HYActivateFillUserInfoView

- (void)dealloc
{
    [_datePicker dismissWithAnimation:YES];
}

- (void)setUp
{
    _sex = HYSexMale;
    _agreeInsurance = NO;
    _cardInfo = [[HYCardType alloc] init];
    _cardInfo.certifacateCode = @"01";
    _cardInfo.certifacateName = @"身份证";
    _sexCanEdit = YES;
    _isAuthentificated = NO;
    //        _birthday = @"1980-01-01";
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUp];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds
                                                      style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = TFScalePoint(44);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tableView];
        
        //head
        UILabel *head = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, TFScalePoint(30))];
        head.backgroundColor = [UIColor colorWithWhite:.91 alpha:1];
        head.text = @"   以下填写的信息只作为购买保险使用";
        head.font = [UIFont systemFontOfSize:TFScalePoint(13.0)];
        head.textColor = [UIColor colorWithRed:0.53 green:0.52 blue:0.52 alpha:1.0f];
        self.tableView.tableHeaderView = head;
        
        //foot
        UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, TFScalePoint(200))];
        foot.backgroundColor = [UIColor colorWithWhite:.91 alpha:1];
        self.tableView.tableFooterView = foot;
        
        UIButton *agreeCheckBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 40, 30)];
        [agreeCheckBtn setImage:[UIImage imageNamed:@"infoofmine_checkBox2"] forState:UIControlStateSelected];
        [agreeCheckBtn setImage:[UIImage imageNamed:@"infoofmine_checkBox2_on"] forState:UIControlStateNormal];
        [agreeCheckBtn addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
        [agreeCheckBtn setSelected:NO];
        [foot addSubview:agreeCheckBtn];
        self.agreeCheckBtn = agreeCheckBtn;
        
        _agreeTranscationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeTranscationBtn setTitle:@"我已同意保险条款" forState:UIControlStateNormal];
        _agreeTranscationBtn.titleLabel.font = [UIFont systemFontOfSize:TFScalePoint(13.0f)];
        [_agreeTranscationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_agreeTranscationBtn addTarget:self action:@selector(checkInsuraceAction) forControlEvents:UIControlEventTouchUpInside];
        [_agreeTranscationBtn setTitleColor:[UIColor colorWithRed:0.53 green:0.52 blue:0.52 alpha:1.0f]forState:UIControlStateNormal];
        _agreeTranscationBtn.frame = CGRectMake(CGRectGetMaxX(agreeCheckBtn.frame), 0, TFScalePoint(110), 30);
        [foot addSubview:_agreeTranscationBtn];
        
        UIImage *agreeImg = [[UIImage imageNamed:@"myinfo_saveBtn"]stretchableImageWithLeftCapWidth:5 topCapHeight:10];
        _agreeActivationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeActivationBtn setTitle:@"同意购买" forState:UIControlStateNormal];
        [_agreeActivationBtn setBackgroundImage:agreeImg forState:UIControlStateNormal];
        _agreeActivationBtn.frame = CGRectMake(TFScalePoint(30), CGRectGetMaxY(_agreeTranscationBtn.frame) + TFScalePoint(8), TFScalePoint(260), TFScalePoint(30));
        [_agreeActivationBtn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
        [foot addSubview:_agreeActivationBtn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTap:)];
        tap.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tap];
        
        //pickerview
        _dataPicker = [[HYPickerToolView alloc]init];
        [self addSubview:_dataPicker];
    }
    return self;
}

#pragma mark - setter getter
- (void)setPoliceType:(HYPolicyType *)policeType
{
    if (_policeType != policeType)
    {
        _policeType = policeType;
        
        if (policeType) {
            _agreeCheckBtn.enabled = YES;
            _agreeCheckBtn.selected = YES;
            _agreeTranscationBtn.enabled = YES;
            _agreeInsurance = YES;
        }
        
        [self.tableView reloadData];
    }
}

- (void)setAgreeInsurance:(BOOL)agreeInsurance
{
    _agreeInsurance = agreeInsurance;
    _agreeCheckBtn.selected = agreeInsurance;
}

- (void)setCommitBtnTitle:(NSString *)commitBtnTitle
{
    [_agreeActivationBtn setTitle:commitBtnTitle forState:UIControlStateNormal];
}

- (void)setFeeDesc:(NSString *)feeDesc
{
    if (feeDesc && feeDesc.length > 0)
    {
        UIView *foot = self.tableView.tableFooterView;
        
        UILabel *fee = [[UILabel alloc] init];
        fee.text = feeDesc;
        fee.textColor = [UIColor redColor];
        fee.textAlignment = NSTextAlignmentCenter;
        fee.font = [UIFont systemFontOfSize:14];
        fee.frame = CGRectMake(TFScalePoint(20), CGRectGetMaxY(_agreeTranscationBtn.frame)-10, TFScalePoint(280), 20);
        [foot addSubview:fee];
        
        CGRect frame = _agreeActivationBtn.frame;
        frame.origin.y = CGRectGetMaxY(fee.frame) + 20;
        _agreeActivationBtn.frame = frame;
        
        frame = fee.frame;
        frame.size.height += 30;
        fee.frame = frame;
        self.tableView.tableFooterView = foot;
    }
}

- (void)setIsAuthentificated:(BOOL)isAuthentificated
{
    _isAuthentificated = isAuthentificated;
    [self.tableView reloadData];
}

- (void)setSexCanEdit:(BOOL)sexCanEdit
{
    _sexCanEdit = sexCanEdit;
    [self.tableView reloadData];
}

#pragma mark - event
- (void)editTap:(UITapGestureRecognizer *)tap
{
    [self endEditing:YES];
}

- (void)completeAction
{
    [self endEditing:YES];
    [self validateActivateInfos];
}

- (void)agreeAction:(UIButton *)btn
{
    if (self.policeType)
    {
        btn.selected = !btn.selected;
        _agreeInsurance = btn.selected;
    }
    else
    {
        [METoast toastWithMessage:@"请选择保险类型"];
    }
}

- (void)checkInsuraceAction
{
    if (self.policeType) {
        if (self.didClickInsuranceComments) {
            self.didClickInsuranceComments();
        }
        else if ([self.delegate respondsToSelector:@selector(didClickInsuranceComments)]) {
            [self.delegate didClickInsuranceComments];
        }
    }
    else
    {
        [METoast toastWithMessage:@"请选择保险类型"];
    }
}

#pragma mark - functions

#pragma mark -- public
- (void)reloadData
{
    [self.tableView reloadData];
}

#pragma mark -- private

/// 更新生日
- (void)updatebirthday
{
    if (!_datePicker)
    {
        _datePicker = [[HYDatePickerView alloc]  initWithFrame:CGRectMake(0, 0, self.frame.size.width, 260)];
        _datePicker.title = @"选择出生日期";
        _datePicker.delegate = self;
    }
    
    NSString *dateStr =  ([self.birthday length] > 0) ? self.birthday :@"1980-01-01";
    NSDate *date = [NSDate dateFromString:dateStr];
    _datePicker.pickerView.date = date;
    [_datePicker showWithAnimation:YES];
}

- (void)modifySex
{
    if (!_dataPicker)
    {
        _dataPicker = [[HYPickerToolView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 216)];
    }
    if (_dataPicker.isShow) {
        [_dataPicker dismissWithAnimation:YES];
    }
    
    NSArray *datas = @[@"男", @"女"];
    _dataPicker.dataSouce = datas;
    if (_sex == HYSexMale) {
        _dataPicker.currentIndex = 0;
    }
    else if (_sex == HYSexFemale) {
        _dataPicker.currentIndex = 1;
    }
    WS(weakSelf);
    _dataPicker.didSelectItem = ^(NSInteger idx) {
        if (idx == 0) {
            weakSelf.sex = HYSexMale;
        }
        else if (idx == 1) {
            weakSelf.sex = HYSexFemale;
        }
        [weakSelf.tableView reloadData];
    };
    [_dataPicker showWithAnimation:YES];
}

- (void)validateActivateInfos
{
    _userName = [_userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *str = nil;
    if (!_agreeInsurance)
    {
        str = @"请同意保险条款";
    }
    
    else if (!_policeType)
    {
        str = @"请选择保险类型";
    }
    else if ([_userName length] <= 0 ) {
        str = @"真实姓名不能为空";
    }
    else if ([_idNum length]<=0)
    {
        str = @"证件号码不能为空";
    }
    else if (self.cardInfo.certifacateCode.integerValue==1 && ![NSString validateIDCardNumber:_idNum])
    {
        str = @"身份证号码不正确";
    }
    
    if (self.cardInfo.certifacateCode.integerValue == 1)
    {
        self.birthday = [_idNum getBirthdayForIDCard];
        self.sex = hyGetSexFromString([NSString sexStrFromIdentityCard:_idNum]);
    }
    else
    {
        if (_sex == HYSexUnknown) {
            str = @"请选择性别";
        }
        else if (_birthday.length == 0) {
            str = @"请选择出生日期";
        }
    }
    
    if (str)
    {
        [METoast toastWithMessage:str];
    }
    else if (self.didClickCommit) {
        self.didClickCommit();
    }
    else if ([self.delegate respondsToSelector:@selector(didClickCommit)]) {
        [self.delegate didClickCommit];
    }
}

#pragma mark - delegates
#pragma mark -- tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.cardInfo.certifacateCode.intValue == 1 ? 4 : 6;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        HYLoginV2SelectCell *input = [tableView dequeueReusableCellWithIdentifier:@"select"];
        if (!input)
        {
            input = [[HYLoginV2SelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"select"];
        }
        input.textLabel.text = @"保险类型";
        input.detailTextLabel.text = @"请选择保险类型";
        if (self.policeType) {
            input.detailTextLabel.text = self.policeType.insuranceTypeName;
        }
        return input;
    }
    else if (indexPath.row == 1)
    {
        HYLoginV2InputCell *input = [tableView dequeueReusableCellWithIdentifier:@"input"];
        if (!input)
        {
            input = [[HYLoginV2InputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"input"];
        }
        input.textLabel.text = @"真实姓名";
        input.textField.text = self.userName;
        input.textField.delegate = self;
        input.textField.tag = 101;
        input.textField.placeholder = @"请输入真实姓名";
        input.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        input.textField.enabled = !_isAuthentificated;
        input.textField.returnKeyType = UIReturnKeyDone;
        return input;
    }
    else if (indexPath.row == 4)
    {
        HYLoginV2SelectCell *input = [tableView dequeueReusableCellWithIdentifier:@"select"];
        if (!input)
        {
            input = [[HYLoginV2SelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"select"];
            input.textLabel.text = @"性别";
        }
        if (_sex == HYSexMale) {
            input.detailTextLabel.text = @"男";
        }
        else if (_sex == HYSexFemale) {
            input.detailTextLabel.text = @"女";
        }
        else {
            input.detailTextLabel.text = @"未知";
        }
        input.selectEnable = self.sexCanEdit;
        
        return input;
    }
    else if (indexPath.row == 3)
    {
        HYLoginV2InputCell *input = [tableView dequeueReusableCellWithIdentifier:@"input"];
        if (!input)
        {
            input = [[HYLoginV2InputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"input"];
        }
        input.textLabel.text = @"证件号码";
        input.textField.text = self.idNum;
        input.textField.delegate = self;
        input.textField.tag = 102;
        input.textField.keyboardType = UIKeyboardTypeDefault;
        input.textField.placeholder = @"请输入证件号码";
        input.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        input.textField.enabled = !_isAuthentificated;
        input.textField.returnKeyType = UIReturnKeyDone;
        return input;
    }
    else if (indexPath.row == 2)
    {
        HYLoginV2SelectCell *input = [tableView dequeueReusableCellWithIdentifier:@"select"];
        if (!input)
        {
            input = [[HYLoginV2SelectCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"select"];
        }
        input.textLabel.text = @"证件类型";
        input.detailTextLabel.text = self.cardInfo.certifacateName;
        return input;
    }
    else
    {
        HYLoginV2SelectCell *input = [tableView dequeueReusableCellWithIdentifier:@"select"];
        if (!input)
        {
            input = [[HYLoginV2SelectCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"select"];
        }
        input.textLabel.text = @"出生日期";
        input.detailTextLabel.text = self.birthday;
        return input;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[HYBaseLineCell class]])
    {
        NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
        if(indexPath.row == totalRow -1)
        {
            HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
            lineCell.separatorLeftInset = 0.0f;
        }
        else
        {
            HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
            lineCell.separatorLeftInset = 15;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self endEditing:YES];
    if (indexPath.row == 0) //保险类型
    {
        if (self.didSelectInsurace) {
            self.didSelectInsurace();
        }
        else if ([self.delegate respondsToSelector:@selector(didSelectInsurace)]){
            [self.delegate didSelectInsurace];
        }
    }
    else if (indexPath.row == 2)    //证件类型
    {
        if (!self.isAuthentificated)
        {
            if (self.didSelectCardType) {
                self.didSelectCardType();
            }
            else if ([self.delegate respondsToSelector:@selector(didSelectCardType)]){
                [self.delegate didSelectCardType];
            }
        }
    }
    else if (indexPath.row == 4)
    {
        if (!self.isAuthentificated)
        {
            [self modifySex];
        }
    }
    else if (indexPath.row == 5)    //生日
    {
        [self updatebirthday];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        [self endEditing:YES];
    }
}

#pragma mark -- text delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 102:
            [_tableView setContentOffset:CGPointMake(0, 130) animated:YES];
            break;
        default:
            [_tableView setContentOffset:CGPointMake(0, 30) animated:YES];
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 101:
            self.userName = textField.text;
            break;
        case 102:
            self.idNum = textField.text;
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -- HYDatePickerViewDelegate
- (void)didSelectDate:(NSDate *)date
{
    self.birthday = [date timeDescription];
    [self.tableView reloadData];
}


@end
