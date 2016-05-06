//
//  HYCIFillCarInfoCell.m
//  Teshehui
//
//  Created by HYZB on 15/7/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIFillCarInfoCell.h"

@interface HYCIFillCarInfoCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputTF;
@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, assign) BOOL isChecked;

@end

@implementation HYCIFillCarInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.frame = CGRectMake(10, 12, 100, 20);
    }
    
    return self;
}

- (void)reloadView
{
    switch (self.infoType.inputType.intValue)
    {
        case 10:  //单行文本
            [_descLab setHidden:YES];
            [_checkBtn setHidden:YES];
            [self.inputTF setHidden:NO];
            self.inputTF.text = self.infoType.value;
            self.inputTF.returnKeyType = UIReturnKeyNext;
            self.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 20:  //单选
            [_descLab setHidden:NO];
            [_inputTF setHidden:YES];
            
            [self.checkBtn setHidden:NO];
            [self.checkBtn setSelected:self.infoType.value.integerValue];
            self.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 21:  //下拉框
        case 100:  //下拉框
            [self.descLab setHidden:NO];
            [_checkBtn setHidden:YES];
            [_inputTF setHidden:YES];
            self.descLab.text = self.infoType.value;
            
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        case 30:  //,隐藏域
//            [self.inputTF setHidden:NO];
//            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            break;
        case 40:  //日期
            [self.descLab setHidden:NO];
            [_checkBtn setHidden:YES];
            [_inputTF setHidden:YES];
            self.descLab.text = self.infoType.value;
            
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }
}

- (void)checkEvent:(id)sender
{
    [_checkBtn setSelected:!_checkBtn.isSelected];
    _isChecked = _checkBtn.isSelected;
    self.infoType.value = [NSString stringWithFormat:@"%d", _isChecked];
    
    if ([self.delegate respondsToSelector:@selector(didEidtCheckStatus:)])
    {
        [self.delegate didEidtCheckStatus:_isChecked];
    }
}


//"inputType": "text(10,单行文本),radio(20,单选),combo(21,下拉框),hidden(30,隐藏域),date(40,日期)"

#pragma mark setter/getter
- (void)setInfoType:(HYCICarInfoFillType *)infoType
{
    if (infoType != _infoType)
    {
        _infoType = infoType;
        self.textLabel.text = infoType.inputShowName;
        
        [self reloadView];
    }
    
    if (![_descLab isHidden] && _descLab)
    {
        self.descLab.text = infoType.value;
    }
}

- (UITextField *)inputTF
{
    if (!_inputTF)
    {
        _inputTF = [[UITextField alloc] initWithFrame:CGRectMake(120, 10, ScreenRect.size.width-130, 24)];
        _inputTF.textAlignment = NSTextAlignmentRight;
        _inputTF.font = [UIFont systemFontOfSize:16];
        _inputTF.delegate = self;
        [self.contentView addSubview:_inputTF];
    }
    
    return _inputTF;
}

- (UILabel *)descLab
{
    if (!_descLab)
    {
        _descLab = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, ScreenRect.size.width-145, 24)];
        _descLab.textAlignment = NSTextAlignmentRight;
        _descLab.textColor = [UIColor blackColor];
        _descLab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_descLab];
    }
    
    return _descLab;
}

- (UIButton *)checkBtn
{
    if (!_checkBtn)
    {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setFrame:CGRectMake(TFScalePoint(280), 0, 44, 44)];
        [_checkBtn setImage:[UIImage imageNamed:@"icon_check"]
                   forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage imageNamed:@"icon_check_on"]
                   forState:UIControlStateSelected];
        [_checkBtn addTarget:self
                      action:@selector(checkEvent:)
            forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_checkBtn];
    }
    
    return _checkBtn;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.infoType.value = textField.text;
    
    if ([self.delegate respondsToSelector:@selector(didTextInputFinished:)])
    {
        [self.delegate didTextInputFinished:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(didTextInputNext:)])
    {
        [self.delegate didTextInputNext:(self.tag+1)];
    }
    
    return YES;
}

@end
