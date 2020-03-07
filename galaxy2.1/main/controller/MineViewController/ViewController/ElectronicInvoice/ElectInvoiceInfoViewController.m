//
//  ElectInvoiceInfoViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/2/17.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ElectInvoiceInfoViewController.h"

@interface ElectInvoiceInfoViewController ()<GPClientDelegate>
@property (nonatomic, strong) NSDictionary *dic_request;
@end

@implementation ElectInvoiceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:Custing(@"发票详情", nil) backButton:YES];
    
    _dic_request = [NSDictionary new];
    self.view.backgroundColor = Color_White_Same_20;
    [self requstGetinvoicedetail];
}

#pragma mark - function
//网络请求
-(void)requstGetinvoicedetail
{
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",BW_GetInvoiceDetail] Parameters:@{@"AccountNo":_AcctionNo,@"AccountType":_AcctionType,@"FP_DM":_dic[@"fP_DM"],@"FP_HM":_dic[@"fP_HM"]} Delegate:self SerialNum:5 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

//创建视图
-(void)createMainView{
    _lab_fkf.text = _dic_request[@"result"][@"gmF_MC"];
    _lab_skf.text = _dic_request[@"result"][@"xsF_MC"];
    _lab_fpje.text = _dic_request[@"result"][@"jshj"];
    _lab_fpsj.text = _dic_request[@"result"][@"kprq"];
    _lab_fpxmc.text = _dic_request[@"result"][@"kpxm"];
    _lab_fpdm.text = _dic_request[@"result"][@"fP_DM"];
    _lab_fphm.text = _dic_request[@"result"][@"fP_HM"];
}

#pragma mark - delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    NSLog(@"resDic:%@",responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    if (serialNum == 5) {
        _dic_request = responceDic;
        [self createMainView];
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
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

@end
