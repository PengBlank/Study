//
//  HYFlowerFullBuyerViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-4-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerFullBuyerViewController.h"
#import "HYBaseLineCell.h"
#import "NSString+Addition.h"

@interface HYFlowerFullBuyerViewController ()<UITextFieldDelegate>
{
    UITextField *_nameTextField;
    UITextField *_mobileTextField;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HYFlowerFullBuyerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"填写信息";
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                           green:237.0f/255.0f
                                            blue:237.0f/255.0f
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.sectionFooterHeight = 10;
    tableview.sectionHeaderHeight = 0;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    
    UIButton* doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = TFRectMake(60, 18, 200, 44);
    
    UIImage *image = [[UIImage imageNamed:@"flower_bg_title_bar_88"] stretchableImageWithLeftCapWidth:2
                                                                                         topCapHeight:10];
    
    [doneBtn setBackgroundImage:image
                       forState:UIControlStateNormal];
//    [doneBtn setBackgroundImage:[UIImage imageNamed:@"person_buttom_orange2_press"]
//                       forState:UIControlStateHighlighted];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [doneBtn addTarget:self
                action:@selector(inputCompleteEvent:)
      forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:doneBtn];
    tableview.tableFooterView = footerView;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_nameTextField)
    {
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, TFScalePoint(200), 44)];
        _nameTextField.keyboardType = UIKeyboardTypeDefault;
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTextField.font = [UIFont systemFontOfSize:16];
        _nameTextField.returnKeyType = UIReturnKeyNext;
        _nameTextField.delegate = self;
        _nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _nameTextField.placeholder = @"请输入姓名";
    }
    
    if (!_mobileTextField)
    {
        _mobileTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, TFScalePoint(200), 44)];
        _mobileTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _mobileTextField.font = [UIFont systemFontOfSize:16];
        _mobileTextField.returnKeyType = UIReturnKeyDone;
        _mobileTextField.delegate = self;
        _mobileTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _mobileTextField.placeholder = @"请输入手机号码";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private methods
- (void)inputCompleteEvent:(id)sender
{
    if ([_mobileTextField.text length] > 0)
    {
        if (![_mobileTextField.text checkPhoneNumberValid])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请填写正确的手机号码"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
            
            return;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(didSelectedBuyerName:mobile:)])
    {
        [self.delegate didSelectedBuyerName:_nameTextField.text
                                     mobile:_mobileTextField.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate - methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _nameTextField)
    {
        [_mobileTextField becomeFirstResponder];
    }
    else
    {
        [self inputCompleteEvent:nil];
    }
    return YES;
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;
    
    return height;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
    if(indexPath.row == totalRow -1){
        //this is the last row in section.
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:cellId];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    }
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"姓名: ";
        if (!_nameTextField.superview)
        {
            [cell addSubview:_nameTextField];
        }
        _nameTextField.text = self.userName;
    }
    else
    {
        cell.textLabel.text = @"号码: ";
        if (!_mobileTextField.superview)
        {
            [cell addSubview:_mobileTextField];
        }
        _mobileTextField.text = self.mobile;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
