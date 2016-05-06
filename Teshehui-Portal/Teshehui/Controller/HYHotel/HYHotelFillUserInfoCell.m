//
//  HYHotelFillUserInfoCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelFillUserInfoCell.h"

@interface HYHotelFillUserInfoCell ()
{
    BOOL _addDoneBtn;
}

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *phoneField;

@end

@implementation HYHotelFillUserInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _addDoneBtn = NO;
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.text = NSLocalizedString(@"contacts", nil);
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.text = NSLocalizedString(@"phone", nil);
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        
        UIButton *contactsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        contactsBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-44-4, 22, 44, 44);
        [contactsBtn setImage:[UIImage imageNamed:@"btn_addbook"]
                     forState:UIControlStateNormal];
        [contactsBtn setImage:[UIImage imageNamed:@"btn_addbook_pressed"]
                     forState:UIControlStateHighlighted];
        [contactsBtn addTarget:self
                        action:@selector(selectFromAddressBook:)
              forControlEvents:UIControlEventTouchUpInside];
        contactsBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:contactsBtn];
        
        UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(14, 44, CGRectGetMinX(contactsBtn.frame)-5-14, 1)];
        line1.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                    topCapHeight:0];
        line1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:line1];
        
        // field
        CGRect rect = CGRectMake(100, 12, 200, 20);
        _nameField = [[UITextField alloc] initWithFrame:rect];
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameField.returnKeyType = UIReturnKeyNext;
        _nameField.placeholder = NSLocalizedString(@"name", nil);
        _nameField.delegate = self;
        _nameField.font = [UIFont systemFontOfSize:16];
        _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_nameField];
        
        rect.origin.y = 56;
        _phoneField = [[UITextField alloc] initWithFrame:rect];
        _phoneField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneField.placeholder = NSLocalizedString(@"use_recv_sms", nil);
        _phoneField.delegate = self;
        _phoneField.font = [UIFont systemFontOfSize:16];
        _phoneField.returnKeyType = UIReturnKeyDone;
        _phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_phoneField];
        
        [self configFields];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(10, 12, 150, 20);
    self.detailTextLabel.frame = CGRectMake(10, 56, 150, 20);
}

- (void)configFields
{
    int tag = 10;
    for (UIView *v in self.contentView.subviews)
    {
        if ([v isKindOfClass:[UITextField class]])
        {
            v.tag = tag;
            tag++;
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(cellBecomeFirstResponder:)])
    {
        [self.delegate cellBecomeFirstResponder:self];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext)
    {
        UIView *view = [self.contentView viewWithTag:(textField.tag+1)];
        if ([view isKindOfClass:[UITextField class]])
        {
            [(UITextField *)view becomeFirstResponder];
        }
    }
    else if (textField.returnKeyType == UIReturnKeyDone)
    {
        if ([self.delegate respondsToSelector:@selector(didNameInputComplete:)])
        {
            [self.delegate didNameInputComplete:self];
        }
        
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(didNameInputComplete:)])
    {
        [self.delegate didNameInputComplete:self];
    }
}

- (void)done
{
    if ([self.delegate respondsToSelector:@selector(didNameInputComplete:)])
    {
        [self.delegate didNameInputComplete:self];
    }
    
    [_phoneField resignFirstResponder];
}

- (void)fieldResignFirstResponder
{
    [_phoneField resignFirstResponder];
    [_nameField resignFirstResponder];
}

- (void)selectFromAddressBook:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(displayAllContacts)])
    {
        [self.delegate displayAllContacts];
    }
}

@end
