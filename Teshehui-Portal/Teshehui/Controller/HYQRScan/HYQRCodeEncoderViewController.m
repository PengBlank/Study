//
//  HYQRScanViewController.m
//  Teshehui
//
//  Created by HYZB on 14-7-1.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYQRCodeEncoderViewController.h"
#import "HYAroundMallListViewController.h"
#import "ZXingObjC.h"
#import "HYAppDelegate.h"
#import "HYUserInfo.h"
#import "NSString+Addition.h"

@interface HYQRCodeEncoderViewController ()<UIAlertViewDelegate>
{
    UIImageView *_QRImageView;
}

@end

@implementation HYQRCodeEncoderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我的二维码 ";
        self.showBottom = NO;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    _QRImageView = [[UIImageView alloc] initWithFrame:TFRectMake(10,
                                                                 (frame.size.height-300)/2-64,
                                                                 300,
                                                                 300)];
    [self.view addSubview:_QRImageView];
    
    UILabel *desLabel = [[UILabel alloc] initWithFrame:TFRectMake(55,
                                                                  (frame.size.height-210)/2+240-64,
                                                                  210,
                                                                  18)];
    desLabel.textColor = [UIColor colorWithRed:101.0/255.0
                                         green:101.0/255.0
                                          blue:99.0/255.0
                                         alpha:1];
    desLabel.font = [UIFont systemFontOfSize:16];
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.text = @"请将此二维码提供给商户扫描";
    [self.view addSubview:desLabel];
    
    UILabel *des2Label = [[UILabel alloc] initWithFrame:TFRectMake(52,
                                                                   desLabel.frame.origin.y+40,
                                                                   210,
                                                                   18)];
    des2Label.textColor = [UIColor colorWithRed:101.0/255.0
                                          green:101.0/255.0
                                           blue:99.0/255.0
                                          alpha:1];
    des2Label.font = [UIFont systemFontOfSize:14];
    des2Label.textAlignment = NSTextAlignmentCenter;
    des2Label.text = @"＊该功能目前在部分城市试运营";
    [self.view addSubview:des2Label];
    
    if (self.showBottom)
    {
        UIImage *image = [[UIImage imageNamed:@"qr_nav_bg_128"] stretchableImageWithLeftCapWidth:2
                                                                                    topCapHeight:0];
        
        UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        checkBtn.frame = TFRectMakeFixWidth(0,
                                            frame.size.height-64,
                                            320,
                                            64);
        [checkBtn setBackgroundImage:image
                            forState:UIControlStateNormal];
        [checkBtn setBackgroundImage:image
                            forState:UIControlStateHighlighted];
        [checkBtn setTitle:@"查看合作商户" forState:UIControlStateNormal];
        [checkBtn addTarget:self
                     action:@selector(checkAroundBusinessInfo:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:checkBtn];
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSString *imageName = CheckIOS7 ? @"qr_nav_bg_128" : @"qr_nav_bg_88";
//    UIImage *image = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:2
//                                                                         topCapHeight:0];
//    [self.navigationController.navigationBar setBackgroundImage:image
//                                                  forBarMetrics:UIBarMetricsDefault];
    
    [self updateQRCode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)test
{
    NSString *titles =
    @"Dent-Inn齿素屋,疗亮2N,富安娜,羽博,奥卡利斯,柒格格服饰,ABC,爹地宝贝,合生元奶粉,派克,D&G手表,赛诺,瑞士军刀,惠人,奔腾,爱仕达,飞科,欧姆龙,苏泊尔,阿迪,耐克,新百伦,喜钻,舒适达,杰奎琳,何金昌,鑫万福,千百媚,金稻,爱贝斯,奥克斯,素乐,亿觅,智仕玛,摩米士,小熊,木林森,创悦,北极绒内衣,蜜丝佛陀,威戈,亨吉利手表,施华洛世奇,丸美,maskhouse,老冯记,正品1,正品2,MICHAEL KORS 1,MICHAEL KORS 2,MICHAEL KORS 3,MICHAEL KORS 4,MICHAEL KORS 5,MICHAEL KORS 6,MICHAEL KORS 7,古奇天伦旗舰店,花花公子 1,花花公子 2,花花公子 3,花花公子 4,ABA旗舰店,奕彤时尚美妆,纤慕 1,纤慕 2,美肤宝 1,美肤宝 2,水嫩精纯,百雀羚,南方厨具 1,南方厨具 2,艾格斯1,艾格斯2,婧麒1,婧麒2,欧淘婴儿1,欧淘婴儿2,朵云清旗舰店,简丹1,简丹2,黛若天然1,黛若天然2,瑞士凯琳斯蒂,抱抱熊,南极人,每度 MEIDU,Missha 谜尚,freeplus 芙丽芳丝1,freeplus芙丽芳丝 2,十月天使,莫蕾蔻蕾,金猴 1,金猴 2,雷瓦,丹爵(DANJUE),倍轻松iSee100,达利园,【煌上煌】,清华同,科美（Kemei）1,科美（Kemei）2,瓷肌1,瓷肌2,瓷肌3";
    
    NSArray *array = [titles componentsSeparatedByString:@","];
    
    NSString *ids = @"030200009631,050100009421,030700010089,090100013586,150100013880,150100042986,150100015561,150100017326,150100038486,010100000840,150100041884,030700013957,150100037715,150100040324,150100037405,150100037522,150100037561,150100037640,150100037613,120500013458,110500013061,150100039975,150100040613,030200014854,120400069717,150100040846,150100017009,150100041394,150100016166,090100014354,090100013447,150100017191,150100017188,150100017278,150100017192,150100039806,150100014884,020500013191,150100016134,050400005671,140600006868,130100011086,130400009252,050100014035,050100010101,130400011368,080200012779,080100014552,150100040266,150100040295,150100040261,150100040254,150100040276,150100040263,150100040257,150100017852,110300013050,110300013058,150100015225,150100015251,150100018366,050100014032,120400010705,120400010800,150100043247,050100012107,050100013114,050100013270,150100017107,030300013527,150100040443,150100040449,120700012983,120700011048,150100039947,150100042598,070600011608,130100101404,130300101416,150100016594,130100014432,150100014343,150100040575,150100040208,080300068744,050100067978,050100068246,050100068225,150100038639,150100018182,110300011631,110100009756,090200069629,080100015855,150100012642,070700069027,070700068668,010200014885,150100040815,150100041076,150100041574,150100041652,050100068441";
    NSArray *idArray = [ids componentsSeparatedByString:@","];
    
    int i = 0;
    for (NSString *pid in idArray)
    {
        NSString *dataStr = [NSString stringWithFormat:@"teshehui&type=1&product_id=%@", pid];
        
        //base64
        dataStr = [dataStr base64EncodedString];
        
        if (dataStr)
        {
            ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
            ZXBitMatrix *result = [writer encode:dataStr
                                          format:kBarcodeFormatQRCode
                                           width:280
                                          height:280
                                           error:nil];
            [result setRegionAtLeft:0 top:0 width:280 height:280];
            
            if (result)
            {
                ZXImage *zximage = [ZXImage imageWithMatrix:result];
                UIImage *image = [UIImage imageWithCGImage:zximage.cgimage];
                NSData *data = UIImageJPEGRepresentation(image, 1.0);
                
                NSString* string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                
                NSString *name = [array objectAtIndex:i];
    
                NSString* fileName = [string stringByAppendingPathComponent:[NSString stringWithFormat: @"/%@.jpg", name]];
                
                [data writeToFile:fileName atomically:fileName];
            }
        }
        
        i++;
    }
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loadLoginView];
    }
}

#pragma mark private methods
- (void)updateQRCode
{
#if TARGET_OS_IPHONE
    NSString *dataStr = [self createQRCodeString];
    
    if (dataStr)
    {
        ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
        ZXBitMatrix *result = [writer encode:dataStr
                                      format:kBarcodeFormatQRCode
                                       width:_QRImageView.frame.size.width
                                      height:_QRImageView.frame.size.width
                                       error:nil];
        
        if (result)
        {
            ZXImage *image = [ZXImage imageWithMatrix:result];
            
            UIImage *logo = [UIImage imageNamed:@"QR_icon"];
            UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(_QRImageView.frame.size.width/2-27,
                                                                                  _QRImageView.frame.size.height/2-27,
                                                                                  56,
                                                                                  56)];
            logoView.image = logo;

            _QRImageView.backgroundColor = [UIColor blackColor];
            [_QRImageView addSubview:logoView];
            
            _QRImageView.image = [UIImage imageWithCGImage:image.cgimage];
        } else {
            _QRImageView.image = nil;
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                        message:@"用户登录信息不完整，请重新登录"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"重新登录", nil];
        [alert show];
    }
#endif
}

- (NSString *)createQRCodeString
{
    NSMutableString *QRStr = [NSMutableString stringWithString:@"teshehui"];
    
    HYUserInfo *user = [HYUserInfo getUserInfo];
    
    if ([user.number length]<=0 || [user.mobilePhone length]<=0)
    {
        return nil;
    }
    
    if ([user.realName length] > 0)
    {
        [QRStr appendFormat:@"&name=%@", user.realName];
    }
    
    [QRStr appendFormat:@"&card_no=%@", user.number];
    [QRStr appendFormat:@"&phone_no=%@", user.mobilePhone];
    
    return [QRStr base64EncodedString];
}

- (void)checkAroundBusinessInfo:(id)sender
{
    HYAroundMallListViewController *vc = [[HYAroundMallListViewController alloc] init];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

@end
