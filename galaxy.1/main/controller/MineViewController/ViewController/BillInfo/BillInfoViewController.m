//
//  BillInfoViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2016/12/2.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "BillInfoViewController.h"

@interface BillInfoViewController ()<GPClientDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *root_View;
@property (nonatomic, strong) UIScrollView *scroll_View;
@property (nonatomic, strong) UITextField *txf_commentName;//公司全称
@property (nonatomic, strong) UITextField *txf_PeopleNumber;//纳税人识别号
@property (nonatomic, strong) UITextField *txf_backName;//开户行名称
@property (nonatomic, strong) UITextField *txf_backAccount;//开户行账号
@property (nonatomic, strong) UITextField *txf_commentPhone;//公司电话
@property (nonatomic, strong) UITextView *txv_commentAddress;//公司地址
@property (nonatomic, strong) NSMutableDictionary *dic_request;//提交数据
@property (nonatomic, strong) NSDictionary *dic_getrequestInfo;//获取数据
@end

@implementation BillInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"开票信息", nil) backButton:YES];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    //创建主页面
    self.view.backgroundColor = Color_White_Same_20;
    _scroll_View = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-44)];
    [self.view addSubview:_scroll_View];
    
    _root_View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 400)];
    _root_View.backgroundColor = Color_White_Same_20;
    [_scroll_View addSubview:_root_View];
    [self setupView];
    [self getRequestInfo];
}

#pragma mark - funtion
#define lab_width 100
-(void)setupView{
    //公司名称
    UIView *view_commentName = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 54)];
    view_commentName.backgroundColor = Color_form_TextFieldBackgroundColor;
    [view_commentName addSubview:[self createDownLineView]];
    UILabel *lab_commentName = [GPUtils createLable:CGRectMake(15, 10, lab_width, 44) text:Custing(@"公司全称", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lab_commentName.numberOfLines = 0;
    [view_commentName addSubview:lab_commentName];
    _txf_commentName = [GPUtils createTextField:CGRectMake(lab_width+30, 10, Main_Screen_Width-lab_width-30, 44) placeholder:Custing(@"请输入公司全称", nil) delegate:self font:Font_Same_14_20 textColor:Color_Black_Important_20];
    [view_commentName addSubview:_txf_commentName];
    [_root_View addSubview:view_commentName];
    
    //纳税人识别号
    UIView *view_PeopleNumber = [[UIView alloc]initWithFrame:CGRectMake(0, 54, Main_Screen_Width, 54)];
    view_PeopleNumber.backgroundColor = Color_form_TextFieldBackgroundColor;
    [view_PeopleNumber addSubview:[self createLineView]];
    UILabel *lab_peopleNumber = [GPUtils createLable:CGRectMake(15, 10, lab_width, 44) text:Custing(@"纳税人识别号", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lab_peopleNumber.numberOfLines = 0;
    [view_PeopleNumber addSubview:lab_peopleNumber];
    _txf_PeopleNumber = [GPUtils createTextField:CGRectMake(lab_width+30, 10, Main_Screen_Width-lab_width-30, 44) placeholder:Custing(@"请输入纳税人识别号", nil) delegate:self font:Font_Same_14_20 textColor:Color_Black_Important_20];
    [view_PeopleNumber addSubview:_txf_PeopleNumber];
    [_root_View addSubview:view_PeopleNumber];
    
    //开户行名称
    UIView *view_backName = [[UIView alloc]initWithFrame:CGRectMake(0, 108, Main_Screen_Width, 54)];
    view_backName.backgroundColor = Color_form_TextFieldBackgroundColor;
    [view_backName addSubview:[self createLineView]];
    UILabel *lab_backName = [GPUtils createLable:CGRectMake(15, 10, lab_width, 44) text:Custing(@"开户行名称", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lab_backName.numberOfLines = 0;
    [view_backName addSubview:lab_backName];
    _txf_backName = [GPUtils createTextField:CGRectMake(lab_width+30, 10, Main_Screen_Width-lab_width-30, 44) placeholder:Custing(@"请输入开户行名称", nil) delegate:self font:Font_Same_14_20 textColor:Color_Black_Important_20];
    [view_backName addSubview:_txf_backName];
    [_root_View addSubview:view_backName];
    
    //银行账户
    UIView *view_backAccount = [[UIView alloc]initWithFrame:CGRectMake(0, 162, Main_Screen_Width, 54)];
    view_backAccount.backgroundColor = Color_form_TextFieldBackgroundColor;
    [view_backAccount addSubview:[self createLineView]];
    [view_backAccount addSubview:[GPUtils createLable:CGRectMake(15, 10, lab_width, 44) text:Custing(@"银行账户", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft]];
    _txf_backAccount = [GPUtils createTextField:CGRectMake(lab_width+30, 10, Main_Screen_Width-lab_width-30, 44) placeholder:Custing(@"请输入银行账户", nil) delegate:self font:Font_Same_14_20 textColor:Color_Black_Important_20];
    [view_backAccount addSubview:_txf_backAccount];
    [_root_View addSubview:view_backAccount];
    
    //公司电话
    UIView *view_commentPhone = [[UIView alloc]initWithFrame:CGRectMake(0, 216, Main_Screen_Width, 54)];
    view_commentPhone.backgroundColor = Color_form_TextFieldBackgroundColor;
    [view_commentPhone addSubview:[self createLineView]];
    UILabel *lab_commentPhone = [GPUtils createLable:CGRectMake(15, 10, lab_width, 44) text:Custing(@"公司电话", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lab_commentPhone.numberOfLines = 0;
    [view_commentPhone addSubview:lab_commentPhone];
    _txf_commentPhone = [GPUtils createTextField:CGRectMake(lab_width+30, 10, Main_Screen_Width-lab_width-30, 44) placeholder:Custing(@"请输入公司电话", nil) delegate:self font:Font_Same_14_20 textColor:Color_Black_Important_20];
    [view_commentPhone addSubview:_txf_commentPhone];
    [_root_View addSubview:view_commentPhone];
    
    //注册地址
    UIView *view_commentAddress = [[UIView alloc]initWithFrame:CGRectMake(0, 270, Main_Screen_Width, 94)];
    view_commentAddress.backgroundColor = Color_form_TextFieldBackgroundColor;
    [view_commentAddress addSubview:[self createLineView]];
    UILabel *lab_commentAddress = [GPUtils createLable:CGRectMake(15, 10, lab_width, 44) text:Custing(@"注册地址", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lab_commentAddress.numberOfLines = 0;
    [view_commentAddress addSubview:lab_commentAddress];
//    _txv_commentAddress = [GPUtils createTextField:CGRectMake(lab_width+30, 10, Main_Screen_Width-lab_width-30, 44) placeholder:Custing(@"请输入注册地址", nil) delegate:self font:Font_Same_14_20 textColor:Color_Black_Important_20];
    _txv_commentAddress = [GPUtils createUITextView:CGRectMake(lab_width+30, 10, Main_Screen_Width-lab_width-30, 84) delegate:self font:Font_Same_14_20 textColor:Color_Black_Important_20];
    _txv_commentAddress.userInteractionEnabled = YES;
    [view_commentAddress addSubview:_txv_commentAddress];
    UIView *lineDown=[[UIView alloc]initWithFrame:CGRectMake(0,93.48, Main_Screen_Width,0.5)];
    lineDown.backgroundColor=Color_GrayLight_Same_20;
    [view_commentAddress addSubview:lineDown];
    [_root_View addSubview:view_commentAddress];
    
//    [_root_View addSubview:[GPUtils createLable:CGRectMake(0, 370, Main_Screen_Width, 20) text:Custing(@"增值税专用发票开票信息", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter]];
    _scroll_View.contentSize = CGSizeMake(Main_Screen_Width, 400);
    
    UIButton *btn_save = [GPUtils createButton:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-44, Main_Screen_Width, 49) action:@selector(btn_click:) delegate:self title:Custing(@"保存", nil) font:Font_Same_14_20 titleColor:Color_form_TextFieldBackgroundColor];
    [btn_save setBackgroundColor:Color_Blue_Important_20];
    [self.view addSubview:btn_save];
}

-(void)getRequestInfo
{
    NSString *url=[NSString stringWithFormat:@"%@",GetCoCardInfo];
    NSDictionary *parameters = @{@"Id":_Id};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}

-(void)disposeRequestInfo
{
    _txf_backName.text = [NSString isEqualToNull:_dic_getrequestInfo[@"result"][@"bankName"]]?_dic_getrequestInfo[@"result"][@"bankName"]:@"";
    _txf_commentName.text = [NSString isEqualToNull:_dic_getrequestInfo[@"result"][@"companyName"]]?_dic_getrequestInfo[@"result"][@"companyName"]:@"";
    _txf_PeopleNumber.text = [NSString isEqualToNull:_dic_getrequestInfo[@"result"][@"taxpayerId"]]?_dic_getrequestInfo[@"result"][@"taxpayerId"]:@"";
    _txf_commentPhone.text = [NSString isEqualToNull:_dic_getrequestInfo[@"result"][@"telephone"]]?_dic_getrequestInfo[@"result"][@"telephone"]:@"";
    _txv_commentAddress.text = [NSString isEqualToNull:_dic_getrequestInfo[@"result"][@"address"]]?_dic_getrequestInfo[@"result"][@"address"]:@"";
    _txf_backAccount.text = [NSString isEqualToNull:_dic_getrequestInfo[@"result"][@"bankAccount"]]?_dic_getrequestInfo[@"result"][@"bankAccount"]:@"";
}

#pragma mark - action
-(void)btn_click:(UIButton *)btn
{
    NSLog(@"保存点击");
    _dic_request = [[NSMutableDictionary alloc]init];
    [_dic_request addString:_txf_commentName.text forKey:@"CompanyName"];
    [_dic_request addString:_txf_PeopleNumber.text forKey:@"TaxpayerId"];
    [_dic_request addString:_txf_backName.text forKey:@"BankName"];
    [_dic_request addString:_txf_backAccount.text forKey:@"BankAccount"];
    [_dic_request addString:_txf_commentPhone.text forKey:@"Telephone"];
    [_dic_request addString:_txv_commentAddress.text forKey:@"Address"];
    [_dic_request addString:[NSString isEqualToNull:_dic_getrequestInfo[@"result"][@"einvoice"]]?_dic_getrequestInfo[@"result"][@"einvoice"]:@"" forKey:@"einvoice"];
    [_dic_request addString:_Id forKey:@"Id"];
    NSString *url=[NSString stringWithFormat:@"%@",SaveNewCoCard];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:_dic_request Delegate:self SerialNum:0 IfUserCache:NO];
}

#pragma mark - delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSString *success = [NSString stringWithFormat:@"%@",responceDic[@"success"]];
    if (![success isEqualToString:@"1"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"请求失败，请重试！" duration:1.0];
        return;
    }
    if (serialNum == 0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString isEqualToNull:_Id]?Custing(@"修改成功", nil):Custing(@"添加成功", nil) duration:2.0];
        [self performBlock:^{
            [self returnBack];
        } afterDelay:1.5];
        return;
    }
    if (serialNum == 1) {
        _dic_getrequestInfo = responceDic;
        [self disposeRequestInfo];
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![string isEqualToString:@""]) {
        if (textField.text.length>19) {
            if ([textField isEqual:_txf_commentPhone]) {
                return NO;
            }
            if (textField.text.length>29) {
                if ([textField isEqual:_txf_backAccount]) {
                    return NO;
                }
            }
            if (textField.text.length>49) {
                if ([textField isEqual:_txf_commentName]||[textField isEqual:_txf_PeopleNumber]) {
                    return NO;
                }
                if (textField.text.length>99) {
                    if ([textField isEqual:_txf_backName]) {
                        return NO;
                    }
                    if (textField.text.length>199) {
                        return NO;
                    }
                }
            }
        }
    }
    return YES;
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
