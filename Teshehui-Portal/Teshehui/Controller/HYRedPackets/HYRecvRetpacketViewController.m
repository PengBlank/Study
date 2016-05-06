//
//  HYRecvRetpacketViewController.m
//  Teshehui
//
//  Created by HYZB on 15/3/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRecvRetpacketViewController.h"
#import "UIImage+Addition.h"
#import "HYRecvRedpacketReq.h"
#import "HYLoadHubView.h"
#import "HYRedpacketDetailViewController.h"
#import "HYRPRecvFailedResultViewController.h"
#import "UIView+ScreenTransform.h"

@interface HYRecvRetpacketViewController ()
{
    HYRecvRedpacketReq *_request;
}

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end

@implementation HYRecvRetpacketViewController

- (void)dealloc
{
    [_request cancel];
    _request = nil;
    
    [HYLoadHubView dismiss];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    
    if (self)
    {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"领取红包";
    
    [self.scrollView transformSubviewFrame:NO];
    
    self.nameLab.text = self.redpacket.title;
    self.descLab.text = self.redpacket.greetings;
    
    [self.footerView setImage:[UIImage imageWithNamedAutoLayout:@"t_index_bottom"]];
    
    CGSize size = [self.descLab.text sizeWithFont:self.descLab.font
                                constrainedToSize:self.descLab.frame.size];
    
    
    CGRect frame = self.redpacketView.frame;
    frame.origin.y = self.descLab.frame.origin.y+size.height+30;
    self.redpacketView.frame = frame;
    
    [self.redpacketView setImage:[UIImage imageNamed:@"t_chai_hb"]];
    self.recvBtn.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark private methods
- (IBAction)recvRedpacket:(id)sender
{
    [HYLoadHubView show];
    _request = [[HYRecvRedpacketReq alloc] init];
    _request.code = self.redpacket.receive_code;
    
    __weak typeof(self) b_self = self;
    [_request sendReuqest:^(HYRecvRedpacketResp* result, NSError *error)
     {
         [HYLoadHubView dismiss];
         
         if (result && result.status == 200)
         {
             HYRedpacketDetailViewController *vc = [[HYRedpacketDetailViewController alloc] initWithNibName:@"HYRedpacketDetailViewController" bundle:nil];
             vc.redpacket = self.redpacket;
             vc.isRecvPacket = YES;
             
             if (b_self.redpacketRecvCallback)
             {
                 b_self.redpacketRecvCallback(YES);
             }
             
             [b_self.navigationController pushViewController:vc
                                                  animated:YES];
         }
         else
         {
             if (result.status == 201 ||
                 result.status == 202 ||
                 result.status == 203)
             {
                 HYRPRecvFailedResultViewController *vc = [[HYRPRecvFailedResultViewController alloc] initWithNibName:@"HYRPRecvFailedResultViewController" bundle:nil];
                 vc.redpacket = result.packetInfo;
                 vc.redpacket.recv_status = result.status;
                 vc.recv = result.recv;
                 [b_self.navigationController pushViewController:vc
                                                        animated:YES];
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:error.domain
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
                 [alert show];
             }
         }
     }];
}

@end
