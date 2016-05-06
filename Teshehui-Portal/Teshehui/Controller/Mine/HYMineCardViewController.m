//
//  HYMineCardViewController.m
//  Teshehui
//
//  Created by HYZB on 14-10-9.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMineCardViewController.h"
#import "HYMobileTypeSelectViewController.h"
#import "HYInputCell.h"
#import "HYMineCardMobileCell.h"
#import "HYBusinessCardInfo.h"
#import "ZXingObjC.h"
#import "ZXQRCodeErrorCorrectionLevel.h"
#import "HYUserInfo.h"
#import "UIImageView+WebCache.h"
#import "HYAppDelegate.h"

@interface HYMineCardViewController ()
<
HYMineCardMobileCellDelegate,
HYMobileTypeSelectViewControllerDelegate,
UITextFieldDelegate
>
{
    BOOL _eidt;
    UILabel *_desLabel;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *QRImageView;
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) HYBusinessCardInfo *cardsInfo;

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UIView *bottomV;

@end

static CGFloat bottomViewHeight = 55;

@implementation HYMineCardViewController

- (id)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    // 27 34 47
    view.backgroundColor = [UIColor colorWithRed:27/255.0f green:34/255.0f
                                            blue:47/255.0f alpha:1.0f];
    self.view = view;
    
    UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:frame];
    scrollV.backgroundColor = [UIColor colorWithRed:27/255.0f green:34/255.0f
                                               blue:47/255.0f alpha:1.0f];
    [self.view addSubview:scrollV];
    
    CGFloat x = TFScalePoint(20);
    CGFloat width = TFScalePoint(280);
    CGFloat y = TFScalePoint(40);
    UIView *contentV = [[UIView alloc]
                        initWithFrame:CGRectMake(x, y, width, TFScalePoint(360))];
    [scrollV addSubview:contentV];
    contentV.backgroundColor = [UIColor whiteColor];
    _contentV = contentV;
    contentV.layer.cornerRadius = 5;
    
    UIView *bottomV = [[UIView alloc]
                       initWithFrame:CGRectMake(x, CGRectGetMaxY(_contentV.frame) + 20, width, bottomViewHeight)];
    [scrollV addSubview:bottomV];
    bottomV.backgroundColor = [UIColor whiteColor];
    _bottomV = bottomV;
    bottomV.layer.cornerRadius = 5;
    
    CGFloat lineX = CGRectGetWidth(_bottomV.frame)/2;
    CGFloat height = CGRectGetHeight(bottomV.frame)-20;
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(lineX, 10, 1, height)];
    [bottomV addSubview:lineV];
    lineV.backgroundColor = [UIColor grayColor];
    
    scrollV.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(_bottomV.frame) + 50);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的名片";
    
    self.cardsInfo = [HYBusinessCardInfo initWithDiskCache];
    [self loadContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)loadContentView
{
    BOOL _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (!_isLogin)
    {
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loadLoginView];
    }
    else
    {
        CGRect frame = [[UIScreen mainScreen] bounds];
        frame.size.height -= 64;
        
        if (!_eidt && self.cardsInfo.hasCache)
        {
            CGFloat bgWidth = 249;
            CGFloat bgX = (_contentV.frame.size.width-bgWidth)/2;
            CGFloat bgY = _contentV.frame.origin.y+TFScalePoint(60);
            UIImageView *bgImageView = [[UIImageView alloc]
                                        initWithFrame:CGRectMake(bgX, bgY, bgWidth, 260)];
            bgImageView.image = [UIImage imageNamed:@"background_QRcode"];
            _bgImageView = bgImageView;
            
            //        _QRImageView = [[UIImageView alloc] initWithFrame:TFRectMake(60,
            //                                                                     (frame.size.height-360)/2-64,
            //                                                                     150,
            //                                                                     150)];
            CGFloat centerX = bgImageView.frame.size.width/2;
            CGFloat centerY = bgImageView.frame.size.height/2;
            CGFloat bounds = 150;
            _QRImageView = [[UIImageView alloc] init];
            _QRImageView.center = CGPointMake(centerX, centerY);
            _QRImageView.bounds = CGRectMake(0, 0, bounds, bounds);
            
#if TARGET_OS_IPHONE
            NSString *dataStr = self.cardsInfo.QRDesctription;
            
            if (dataStr)
            {
                ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
                ZXEncodeHints* hints = [ZXEncodeHints hints];
                hints.margin = @(0);
                //容错性设成最高，二维码里添加图片
                hints.errorCorrectionLevel = [ZXQRCodeErrorCorrectionLevel errorCorrectionLevelH];
                //CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);//
                hints.encoding = NSUTF8StringEncoding;
                NSError *error = nil;
                ZXBitMatrix *result = [writer encode:dataStr
                                              format:kBarcodeFormatQRCode
                                               width:294
                                              height:294
                                               hints:hints
                                               error:&error];
                
                if (result)
                {
                    //                ZXImage *image = [ZXImage imageWithMatrix:result];
                    // 228 6 57
                    UIColor *onColor = [UIColor colorWithRed:237/255.0f green:6/255.0f
                                                        blue:62/255.0f alpha:1.0f];
                    ZXImage *image = [ZXImage imageWithMatrix:result onColor:onColor.CGColor
                                                     offColor:[UIColor whiteColor].CGColor];
                    UIImage *logo = [UIImage imageNamed:@"icon_QRcode"];
                    UIImageView *logoView = [[UIImageView alloc]
                                             initWithFrame:CGRectMake(_QRImageView.frame.size.width/2-20,
                                                                      
                                                                      _QRImageView.frame.size.height/2-27,
                                                                      45,
                                                                      45)];
                    logoView.image = logo;
                    
                    _QRImageView.backgroundColor = [UIColor blackColor];
                    [_QRImageView addSubview:logoView];
                    
                    _QRImageView.image = [UIImage imageWithCGImage:image.cgimage];
                }
                else
                {
                    _QRImageView.image = nil;
                }
            }
#endif
            //        [self.view addSubview:_QRImageView];
            [bgImageView addSubview:_QRImageView];
            [_contentV addSubview:bgImageView];
            
            UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 65, 65)];
            [_contentV addSubview:userImage];
            userImage.layer.cornerRadius = userImage.frame.size.width/2;
            userImage.layer.masksToBounds = YES;
            HYUserInfo *user = [HYUserInfo getUserInfo];
            if (user.userLogo)
            {
                NSURL *url = [NSURL URLWithString:user.userLogo.defaultURL];
                [userImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"mine_default"]];
            }
            else
            {
                userImage.image = [UIImage imageNamed:@"mine_default"];
            }
            
            
            //        _desLabel = [[UILabel alloc] initWithFrame:TFRectMake(55,
            //                                                              (frame.size.height-210)/2+240-54,
            //                                                              210,
            //                                                              18)];
            _desLabel = [[UILabel alloc] initWithFrame:TFRectMake(CGRectGetMaxX(userImage.frame)+5,
                                                                  30,
                                                                  210,
                                                                  18)];
            //        _desLabel.textColor = [UIColor colorWithRed:101.0/255.0
            //                                              green:101.0/255.0
            //                                               blue:99.0/255.0
            //                                              alpha:1];
            _desLabel.textColor = [UIColor blackColor];
            _desLabel.font = [UIFont systemFontOfSize:20];
            //        _desLabel.textAlignment = NSTextAlignmentCenter;
            _desLabel.text = [NSString stringWithFormat:@"%@", self.cardsInfo.name];
            [_contentV addSubview:_desLabel];
            //        [self.view addSubview:_desLabel];
            
            //        frame.size.height -= 44;
            //
            //        self.toolView = [[UIView alloc] initWithFrame:TFRectMakeFixWidth(0, frame.size.height, 320, 44)];
            
            UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //        logoutBtn.frame = TFRectMakeFixWidth(5,3,152,30);
            //        [logoutBtn setBackgroundImage:[UIImage imageNamed:@"person_buttom_orange2_normal"]
            //                             forState:UIControlStateNormal];
            //        [logoutBtn setBackgroundImage:[UIImage imageNamed:@"person_buttom_orange2_press"]
            //                             forState:UIControlStateHighlighted];
            //        [logoutBtn setBackgroundColor:[UIColor colorWithRed:208.0/255.0
            //                                                      green:15.0/255.0
            //                                                       blue:30.0/255.0
            //                                                      alpha:1.0]];
            [logoutBtn setTitle:@"修改名片" forState:UIControlStateNormal];
            [logoutBtn addTarget:self
                          action:@selector(editMineInfo:)
                forControlEvents:UIControlEventTouchUpInside];
            //        [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //        [logoutBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            //        [self.toolView addSubview:logoutBtn];
            CGFloat logoutBtnX = (CGRectGetWidth(_bottomV.frame)/2 - 80)/2;
            logoutBtn.frame = CGRectMake(logoutBtnX, (bottomViewHeight-30)/2, 80, 30);
            [logoutBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_bottomV addSubview:logoutBtn];
            
            UIButton *nfcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //        nfcBtn.frame = TFRectMakeFixWidth(163,3,152,38);
            //        [nfcBtn setBackgroundColor:[UIColor colorWithRed:29.0/255.0
            //                                                   green:30.0/255.0
            //                                                    blue:31.0/255.0
            //                                                   alpha:1.0]];
            [nfcBtn setTitle:@"存入NFC名片" forState:UIControlStateNormal];
            [nfcBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //        [nfcBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [nfcBtn setEnabled:NO];
            //        [self.toolView addSubview:nfcBtn];
            CGFloat nfcBtnX = CGRectGetWidth(_bottomV.frame)/2+((CGRectGetWidth(_bottomV.frame)/2-120)/2);
            nfcBtn.frame = CGRectMake(nfcBtnX, (bottomViewHeight-30)/2, 120, 30);
            [_bottomV addSubview:nfcBtn];
            
            //        [self.view addSubview:self.toolView];
        }
        else
        {
            frame.size.height -= 44;
            UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                                  style:UITableViewStylePlain];
            tableview.delegate = self;
            tableview.dataSource = self;
            tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableview.backgroundColor = [UIColor whiteColor];
            tableview.allowsSelectionDuringEditing = YES;
            [tableview setEditing:YES];
            
            UIView *footerView = [[UIView alloc] initWithFrame:TFRectMakeFixWidth(0, 0, 320, 260)];
            tableview.tableFooterView = footerView;
            
            UIImageView *lineView = [[UIImageView alloc] initWithFrame:TFRectMakeFixWidth(0, 0, 320, 1.0)];
            lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                           topCapHeight:0];
            tableview.tableHeaderView = lineView;
            [self.view addSubview:tableview];
            self.tableView = tableview;
            
            //
            self.toolView = [[UIView alloc] initWithFrame:TFRectMakeFixWidth(0, frame.size.height, 320, 44)];
            
            UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            logoutBtn.frame = TFRectMakeFixWidth(0,0,160,45);
            //        [logoutBtn setBackgroundImage:[UIImage imageNamed:@"person_buttom_orange2_normal"]
            //                             forState:UIControlStateNormal];
            //        [logoutBtn setBackgroundImage:[UIImage imageNamed:@"person_buttom_orange2_press"]
            //                             forState:UIControlStateHighlighted];
            [logoutBtn setBackgroundColor:[UIColor colorWithRed:208.0/255.0
                                                          green:15.0/255.0
                                                           blue:30.0/255.0
                                                          alpha:1.0]];
            [logoutBtn setTitle:@"生成二维码名片" forState:UIControlStateNormal];
            [logoutBtn addTarget:self
                          action:@selector(creatQRView:)
                forControlEvents:UIControlEventTouchUpInside];
            [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [logoutBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [self.toolView addSubview:logoutBtn];
            
            UIButton *nfcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            nfcBtn.frame = TFRectMakeFixWidth(160,0,160,45);
            [nfcBtn setBackgroundColor:[UIColor colorWithRed:29.0/255.0
                                                       green:30.0/255.0
                                                        blue:31.0/255.0
                                                       alpha:1.0]];
            [nfcBtn setTitle:@"存入NFC名片" forState:UIControlStateNormal];
            [nfcBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [nfcBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [nfcBtn setEnabled:NO];
            [self.toolView addSubview:nfcBtn];
            
            [self.view addSubview:self.toolView];
        }
    }
}

- (void)creatQRView:(id)sender
{
    NSError *error = nil;
    [self.cardsInfo saveToDisk:&error];
    
    if (!error)
    {
        _eidt = NO;
        self.title = @"我的名片";
        [self.tableView removeFromSuperview];
        self.tableView = nil;
        [self.toolView removeFromSuperview];
        self.toolView = nil;
        
        [self loadContentView];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:error.domain
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)editMineInfo:(id)sender
{
    _eidt = YES;
    self.title = @"填写我的名片";
    [_QRImageView removeFromSuperview];
    _QRImageView = nil;
    
    [_desLabel removeFromSuperview];
    _desLabel = nil;
    
    [self.toolView removeFromSuperview];
    self.toolView = nil;
    
    [self loadContentView];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 5 + [self.cardsInfo.numberList count]+self.cardsInfo.canAddNumber;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0 || indexPath.row>([self.cardsInfo.numberList count]+self.cardsInfo.canAddNumber))
    {
        static NSString *textFeildCellId = @"textFeildCellId";
        HYInputCell *cell = [tableView dequeueReusableCellWithIdentifier:textFeildCellId];
        if (!cell)
        {
            cell = [[HYInputCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:textFeildCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameLab.textColor = [UIColor darkGrayColor];
            cell.nameLab.font = [UIFont systemFontOfSize:14];
            cell.nameLab.textAlignment = NSTextAlignmentLeft;
            cell.nameLab.frame = CGRectMake(54, 15, 56, 20);
            
            cell.textField.font = [UIFont systemFontOfSize:14];
            cell.textField.frame = CGRectMake(120, 10, 200, 30);
            cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.delegate = self;
        }
        
        NSInteger index = (indexPath.row-self.cardsInfo.numberList.count)-self.cardsInfo.canAddNumber;
        index = index>=0 ? index : 0;
        
        switch (index)
        {
            case 0:
                cell.nameLab.text = NAME;
                cell.textField.placeholder = @"填写姓名";
                cell.textField.text = self.cardsInfo.name;
                break;
            case 1:
                cell.nameLab.text = ORG;
                cell.textField.placeholder = @"填写公司名称";
                cell.textField.text = self.cardsInfo.org;
                break;
            case 2:
                cell.nameLab.text = TITLE;
                cell.textField.placeholder = @"填写职位名称";
                cell.textField.text = self.cardsInfo.title;
                break;
            case 3:
                cell.nameLab.text = EMAIL;
                cell.textField.placeholder = @"填写电子邮箱";
                cell.textField.text = self.cardsInfo.email;
                break;
            case 4:
                cell.nameLab.text = ADD;
                cell.textField.placeholder = @"填写详细地址";
                cell.textField.text = self.cardsInfo.address;
                break;
            default:
                break;
        }
        
        cell.textField.tag = indexPath.row;
        
        return cell;
    }
    else if (self.cardsInfo.canAddNumber && (indexPath.row == ([self.cardsInfo.numberList count]+1)))
    {
        static NSString *addTelNumberCellId = @"addTelNumberCellId";
        HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:addTelNumberCellId];
        if (!cell)
        {
            cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:addTelNumberCellId];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
        
        cell.textLabel.text = @"添加电话";
        return cell;
    }
    else
    {
        static NSString *moblieInputCellId = @"moblieInputCellId";
        HYMineCardMobileCell *cell = [tableView dequeueReusableCellWithIdentifier:moblieInputCellId];
        if (!cell)
        {
            cell = [[HYMineCardMobileCell alloc]initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:moblieInputCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.fieldDelegate = self;
        }
        
        
        NSInteger index = indexPath.row-1;
        if (index>=0 && index < [self.cardsInfo.numberList count])
        {
            HYTelNumberInfo *tel = [self.cardsInfo.numberList objectAtIndex:index];
            [cell setTelNumber:tel];
        }
        
        cell.textField.tag = indexPath.row;
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL eidt = NO;
    if (indexPath.row>0 && indexPath.row<=([self.cardsInfo.numberList count]+self.cardsInfo.canAddNumber))
    {
        eidt = YES;
    }
    
    return eidt;
}

#pragma mark - UITableViewDelegate
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle style = UITableViewCellEditingStyleDelete;
    
    if (self.cardsInfo.canAddNumber && (indexPath.row==([self.cardsInfo.numberList count]+1)))
    {
        style = UITableViewCellEditingStyleInsert;
    }
    else if (indexPath.row>0 && indexPath.row<[self.cardsInfo.numberList count])
    {
        style = UITableViewCellEditingStyleDelete;
    }
    return style;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.editingStyle == UITableViewCellEditingStyleInsert)  // add
    {
        HYTelNumberInfo *number = [[HYTelNumberInfo alloc] init];
        number.type = indexPath.row;
        [self.cardsInfo.numberList addObject:number];
        
        if (self.cardsInfo.canAddNumber)
        {
            NSIndexPath *insertPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:insertPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            [self.tableView reloadData];
        }
    }
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSInteger index = indexPath.row-1;
        if (index >=0 && index < [self.cardsInfo.numberList count])
        {
            if (!self.cardsInfo.canAddNumber)
            {
                [self.cardsInfo.numberList removeObjectAtIndex:index];
                [self.tableView reloadData];
            }
            else
            {
                [self.cardsInfo.numberList removeObjectAtIndex:index];
                NSIndexPath *insertPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:insertPath]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)  // add
    {
        HYTelNumberInfo *number = [[HYTelNumberInfo alloc] init];
        number.type = indexPath.row;
        [self.cardsInfo.numberList addObject:number];
        if (self.cardsInfo.canAddNumber)
        {
            NSIndexPath *insertPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:insertPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            [self.tableView reloadData];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    CGFloat height = self.tableView.contentOffset.y-254;
    height = height>0 ? height : 0;
    [self.tableView setContentOffset:CGPointMake(0, height) animated:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat offset = 164;
    if (bounds.size.height > 480)
    {
        offset = 214;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
    CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
    CGFloat height = rect.origin.y + rect.size.height;
    offset = height-offset;
    
    offset = offset>0 ? offset : 0;
    
    CGPoint point = CGPointMake(0, offset);
    [self.tableView setContentOffset:point animated:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField.tag > 0 && textField.tag<([self.cardsInfo.numberList count]+1))
    {
        NSInteger index = textField.tag-1;
        if (index>=0 && index < [self.cardsInfo.numberList count])
        {
            HYTelNumberInfo *tel = [self.cardsInfo.numberList objectAtIndex:index];
            tel.number = textField.text;
        }
    }
    else
    {
        NSInteger index = (textField.tag-self.cardsInfo.numberList.count)-self.cardsInfo.canAddNumber;
        index = index>=0 ? index : 0;
        
        switch (index)
        {
            case 0:
                self.cardsInfo.name = textField.text;
                break;
            case 1:
                self.cardsInfo.org = textField.text;
                break;
            case 2:
                self.cardsInfo.title = textField.text;
                break;
            case 3:
                self.cardsInfo.email = textField.text;
                break;
            case 4:
                self.cardsInfo.address = textField.text;
                break;
            default:
                break;
        }
    }
}

#pragma mark - HYMineCardMobileCellDelegate
- (void)didSelectSetTelNumberType:(HYTelNumberInfo *)telNumber
{
    HYMobileTypeSelectViewController *vc = [[HYMobileTypeSelectViewController alloc] init];
    vc.telNumber = telNumber;
    vc.delegate = self;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

#pragma mark - HYMobileTypeSelectViewControllerDelegate
- (void)didSelectMobileType
{
    [self.tableView reloadData];
}

/*
//增加联系人按钮事件
- (IBAction)createOne:(id)sender
{
    if ([finalArr count] > 0) {
        
        ABNewPersonViewController *newPersonViewController = [[ABNewPersonViewController alloc] init];
        
        //创建一条联系人记录
        ABRecordRef tmpRecord = ABPersonCreate();
        
        CFErrorRef error;
        BOOL tmpSuccess = NO;
        
        for (int i = 0; i < [finalArr count]; i++) {
            NSString *firstStr = [[finalArr objectAtIndex:i] substringToIndex:(@"前部:   ".length)];
            NSString *SecondStr = [[finalArr objectAtIndex:i] substringFromIndex:(@"前部:   ".length)];
            NSLog(@"firstStr:==%@==SecondStr===%@==",firstStr,SecondStr);
            if ([firstStr hasPrefix:@"姓名:   "]) {
                NSString *name = [NSString stringWithFormat: SecondStr];
                NSString *Xname = [NSString stringWithFormat:@""];
                //如果有分割  如：X;XX
                if ([name rangeOfString:@";"].location !=NSNotFound) {
                    Xname = [name substringToIndex:([name rangeOfString:@";"].location)];
                    name = [name substringFromIndex:([name rangeOfString:@";"].location+1)];
                }
                //First name  名  --OK
                //注意转换类型
                CFStringRef tmpFirstName = CFStringRef(name);
                tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonFirstNameProperty, tmpFirstName, &error);
                //                CFRelease(tmpFirstName);
                //Last name  姓  --OK
                CFStringRef tmpLastName = CFStringRef(Xname);
                tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonLastNameProperty, tmpLastName, &error);
                //                CFRelease(tmpLastName);
            }
            if ([firstStr hasPrefix:@"电话:   "]) {
                CFStringRef tel = CFStringRef([NSString stringWithFormat:SecondStr]);
                //phone number
                //CFSTR("13902400000")
                //注意转换类型
                //        NSString *tmpPhones = [NSString stringWithFormat:tel];
                //                CFStringRef tmpPhones = CFSTR("13902400000");
                ABMutableMultiValueRef tmpMutableMultiPhones = ABMultiValueCreateMutable(kABMultiStringPropertyType);
                ABMultiValueAddValueAndLabel(tmpMutableMultiPhones, tel, kABPersonPhoneMobileLabel, NULL);
                tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonPhoneProperty, tmpMutableMultiPhones, &error);
                //                CFRelease(tmpPhones);
            }
            if ([firstStr hasPrefix:@"邮箱:   "]) {
                CFStringRef mail = CFStringRef([NSString stringWithFormat:SecondStr]);
                //email  邮件
                ABMutableMultiValueRef tmpMutableMultiEmails = ABMultiValueCreateMutable(kABMultiStringPropertyType);
                ABMultiValueAddValueAndLabel(tmpMutableMultiEmails, mail, kABWorkLabel, NULL);
                tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonEmailProperty, tmpMutableMultiEmails, &error);
                //                CFRelease(tmpEmail);
            }
            if ([firstStr hasPrefix:@"公司:   "]) {
                NSString *org = [NSString stringWithFormat:SecondStr];
                //公司  --OK
                CFStringRef tmpCompany = CFStringRef(org);
                tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonOrganizationProperty, tmpCompany, &error);
                //                CFRelease(tmpCompany);
            }
            if ([firstStr hasPrefix:@"网址:   "]) {
                CFStringRef url = CFStringRef([NSString stringWithFormat:SecondStr]);
                //网址
                ABMutableMultiValueRef tmpMutableMultiUrls = ABMultiValueCreateMutable(kABMultiStringPropertyType);
                ABMultiValueAddValueAndLabel(tmpMutableMultiUrls, url, kABWorkLabel, NULL);
                tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonURLProperty, tmpMutableMultiUrls, &error);
                //                CFRelease(tmpUrl);
            }
            if ([firstStr hasPrefix:@"地址:   "]) {
                NSString *address = [NSString stringWithFormat:SecondStr];
                //地址
                //;;xxx;;XX;400039
                NSString *strCity = [NSString stringWithFormat:@""];
                NSString *strState = [NSString stringWithFormat:@""];
                NSString *strZip = [NSString stringWithFormat:@""];
                NSString *strCountry = [NSString stringWithFormat:@""];
                NSString *strCountryCode = [NSString stringWithFormat:@""];
                if ([address rangeOfString:@";"].location != NSNotFound) {
                    NSArray *addarray = [address componentsSeparatedByString:@";"];
                    if ([addarray count] == 6) {
                        address = [NSString stringWithFormat:[addarray objectAtIndex:2]];
                        strCity = [NSString stringWithFormat:[addarray objectAtIndex:4]];
                        strState = [NSString stringWithFormat:[addarray objectAtIndex:3]];
                        strZip = [NSString stringWithFormat:[addarray objectAtIndex:5]];
                        strCountry = [NSString stringWithFormat:[addarray objectAtIndex:1]];
                        strCountryCode = [NSString stringWithFormat:[addarray objectAtIndex:0]];
                    }
                }
                ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABDictionaryPropertyType);
                
                NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
                [addressDictionary setObject:address forKey:(NSString *) kABPersonAddressStreetKey];
                [addressDictionary setObject:strCity forKey:(NSString *)kABPersonAddressCityKey];
                [addressDictionary setObject:strState forKey:(NSString *)kABPersonAddressStateKey];
                [addressDictionary setObject:strZip forKey:(NSString *)kABPersonAddressZIPKey];
                [addressDictionary setObject:strCountry forKey:(NSString *)kABPersonAddressCountryKey];
                [addressDictionary setObject:strCountryCode forKey:(NSString *)kABPersonAddressCountryCodeKey];
                
                ABMultiValueIdentifier identifier;
                ABMultiValueAddValueAndLabel(multiAddress, addressDictionary, kABWorkLabel, &identifier);
                tmpSuccess =ABRecordSetValue(tmpRecord, kABPersonAddressProperty, multiAddress, &error);
                CFRelease(multiAddress);
                CFRelease(addressDictionary);
            }
        }
        
        newPersonViewController.displayedPerson = tmpRecord;
        newPersonViewController.newPersonViewDelegate = self;
        
        [self.navigationController pushViewController:newPersonViewController animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];  
    }  
}
*/
@end
