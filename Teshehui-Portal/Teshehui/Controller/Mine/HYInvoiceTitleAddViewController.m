//
//  HYInvoiceTitleAddViewController.m
//  Teshehui
//
//  Created by apple on 15/3/5.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYInvoiceTitleAddViewController.h"
#import "HYBaseLineCell.h"

@interface HYInvoiceTitleAddViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *nameField;

//由编辑框得到的新抬头
@property (nonatomic, strong) NSString *aInvoiceTitle;

@end

@implementation HYInvoiceTitleAddViewController

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
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1.0)];
    lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                   topCapHeight:0];
    
    tableview.tableHeaderView = lineView;
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(0, 0, 48, 30);
    [doneBtn setTitle:NSLocalizedString(@"done", nil)
             forState:UIControlStateNormal];
    [doneBtn setTitleColor:self.navBarTitleColor
                  forState:UIControlStateNormal];
    
    [doneBtn addTarget:self
                action:@selector(addNewInvoiceTitle:)
      forControlEvents:UIControlEventTouchUpInside];
    if (!CheckIOS7)
    {
        [doneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12)];
    }
    UIBarButtonItem *itemBar = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    self.navigationItem.rightBarButtonItem = itemBar;
    
    if (self.titleAction == HYInvoiceTitleAdd)
    {
        self.title = @"新增常用发票抬头";
    }
    else if (self.titleAction == HYInvoiceTitleEdit)
    {
        self.title = @"编辑常用发票抬头";
        
        UIView *footer = [[UIView alloc] initWithFrame:TFRectMakeFixWidth(0, 0, 320, 60)];
        UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextBtn.frame = TFRectMakeFixWidth(80, 10, 160, 40);
        [nextBtn setBackgroundImage:[UIImage imageNamed:@"person_buttom_orange2_normal"] forState:UIControlStateNormal];
        [nextBtn setBackgroundImage:[UIImage imageNamed:@"person_buttom_orange2_press"] forState:UIControlStateHighlighted];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextBtn setTitle:@"删除" forState:UIControlStateNormal];
        nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19.0f];
        [nextBtn addTarget:self action:@selector(deleteInvoiceTitle:) forControlEvents:UIControlEventTouchUpInside];
        [footer addSubview:nextBtn];
        self.tableView.tableFooterView = footer;
    }
    
    if (_invoiceTitle.length > 0)
    {
        _aInvoiceTitle = _invoiceTitle;
    }
}

- (void)deleteInvoiceTitle:(UIButton *)btn
{
    NSArray *addedTitles = [[NSUserDefaults standardUserDefaults] arrayForKey:@"kInvoiceTitles"];
    if (!addedTitles)
    {
        addedTitles = [NSArray array];
    }
    NSMutableArray *addedts = [NSMutableArray arrayWithArray:addedTitles];
    if (_invoiceTitle) {
        [addedts removeObject:_invoiceTitle];
    }
    [[NSUserDefaults standardUserDefaults] setObject:addedts forKey:@"kInvoiceTitles"];
    if (self.invoiceAddCallback)
    {
        self.invoiceAddCallback(nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    return count;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow -1)
    {
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *nameCellId = @"nameCellId";
        HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:nameCellId];
        if (cell == nil)
        {
            cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:nameCellId];
            cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
            
            _nameField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, TFScalePoint(200), 44)];
            _nameField.keyboardType = UIKeyboardTypeDefault;
            _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _nameField.font = [UIFont systemFontOfSize:16];
            _nameField.returnKeyType = UIReturnKeyNext;
            _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _nameField.delegate = self;
            [cell.contentView addSubview:_nameField];
        }
        
        cell.textLabel.text = @"发票抬头";
        _nameField.text = _aInvoiceTitle;
        return cell;
    }
    return nil;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _aInvoiceTitle = textField.text;
}

#pragma mark - 
- (void)addNewInvoiceTitle:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    if (_aInvoiceTitle.length > 0)
    {
        NSArray *addedTitles = [[NSUserDefaults standardUserDefaults] arrayForKey:@"kInvoiceTitles"];
        if (!addedTitles)
        {
            addedTitles = [NSArray array];
        }
        NSMutableArray *addedts = [NSMutableArray arrayWithArray:addedTitles];
        if (_invoiceTitle) {
            [addedts removeObject:_invoiceTitle];
        }
        [addedts insertObject:_aInvoiceTitle atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:addedts forKey:@"kInvoiceTitles"];
        if (self.invoiceAddCallback)
        {
            self.invoiceAddCallback(_aInvoiceTitle);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
