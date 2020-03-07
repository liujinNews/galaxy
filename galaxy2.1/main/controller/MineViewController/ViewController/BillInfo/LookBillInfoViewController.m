//
//  LookBillInfoViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2016/12/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "UIImage+ZLPhotoLib.h"
#import "LookBillInfoViewController.h"
#import <UShareUI/UShareUI.h>
#import "UILabel+Copy.h"

@interface LookBillInfoViewController ()<GPClientDelegate>

@property (nonatomic, strong) UIView *root_View;
@property (nonatomic, strong) UIScrollView *scroll_View;
@property (nonatomic, strong) UIImageView *img_rootView;
@property (nonatomic, strong) UILabel *lab_commentName;//公司全称
//@property (nonatomic, strong) UILabel *lab_PeopleNumber;//纳税人识别号
//@property (nonatomic, strong) UILabel *lab_backName;//开户行名称
//@property (nonatomic, strong) UILabel *lab_backAccount;//开户行账号
//@property (nonatomic, strong) UILabel *lab_commentPhone;//公司电话
//@property (nonatomic, strong) UILabel *lab_commentAddress;//公司地址
@property (nonatomic, strong) NSDictionary *dic_getrequestInfo;
@property (nonatomic, strong) NSString *str_BillInfo;

@end

@implementation LookBillInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"发票抬头", nil) backButton:YES];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"分享", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(right_btn_click:)];
    
    _str_BillInfo = @"";
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    //创建主页面
    self.view.backgroundColor = Color_White_Same_20;
    _scroll_View = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-44)];
    [self.view addSubview:_scroll_View];
    
    _root_View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 400)];
    _root_View.backgroundColor = Color_White_Same_20;
    _img_rootView = [UIImageView imageViewWithImage:[UIImage imageNamed:@"BillInfo_back"]];
    _img_rootView.frame = CGRectMake(15, 10, Main_Screen_Width-30, 400);
    [_img_rootView.image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30) resizingMode:UIImageResizingModeStretch];
    [_root_View addSubview:_img_rootView];
    [_scroll_View addSubview:_root_View];
    
    [self getRequestInfo];
}

#pragma mark - funtion
-(void)getRequestInfo
{
    NSString *url=[NSString stringWithFormat:@"%@",GetCoCardInfo];
    NSDictionary *parameters = @{@"Id":_Id};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}

-(void)setupView{
    //公司名称
    UIView *view_commentName = [[UIView alloc]initWithFrame:CGRectMake(30, 15, Main_Screen_Width-60, 54)];
    _lab_commentName = [GPUtils createLable:CGRectMake(0, 5, Main_Screen_Width-60, 44) text:_dic_getrequestInfo[@"result"][@"companyName"] font:Font_Important_18_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
    _lab_commentName.numberOfLines = 0;
    _lab_commentName.isCopyable = YES;
    [view_commentName addSubview:_lab_commentName];
    [_root_View addSubview:view_commentName];
    
    //纳税人识别号
    UIView *view_PeopleNumber = [self CreateLableView:Custing(@"纳税人识别号",nil) content:_dic_getrequestInfo[@"result"][@"taxpayerId"]];
    view_PeopleNumber.frame = CGRectMake(30, 100, WIDTH(view_PeopleNumber), HEIGHT(view_PeopleNumber));
    [_root_View addSubview:view_PeopleNumber];
    
    //开户行名称
    UIView *view_backName = [self CreateLableView:Custing(@"开户行名称",nil) content:_dic_getrequestInfo[@"result"][@"bankName"]];
    view_backName.frame = CGRectMake(30, 155, WIDTH(view_backName), HEIGHT(view_backName));
    [_root_View addSubview:view_backName];
    
    //银行账户
    UIView *view_backAccount = [self CreateLableView:Custing(@"开户行账号",nil) content:_dic_getrequestInfo[@"result"][@"bankAccount"]];
    view_backAccount.frame = CGRectMake(30, 210, WIDTH(view_backAccount), HEIGHT(view_backAccount));
    [_root_View addSubview:view_backAccount];
    
    //公司电话
    UIView *view_commentPhone = [self CreateLableView:Custing(@"公司电话",nil) content:_dic_getrequestInfo[@"result"][@"telephone"]];
    view_commentPhone.frame = CGRectMake(30, 265, WIDTH(view_commentPhone), HEIGHT(view_commentPhone));
    [_root_View addSubview:view_commentPhone];
    
    //注册地址
    UIView *view_commentAddress = [[UIView alloc]init];
    view_commentAddress.frame = CGRectMake(30, 320, Main_Screen_Width-60, 55);
    UIImageView *lineview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 4, 2, 12)];
    lineview.backgroundColor = Color_Blue_Important_20;
    [view_commentAddress addSubview:lineview];
    UILabel *lab_title = [GPUtils createLable:CGRectMake(5, 0, Main_Screen_Width-70, 20) text:Custing(@"注册地址", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [view_commentAddress addSubview:lab_title];
    
    CGSize sizes = [NSString sizeWithText:[NSString isEqualToNull:_dic_getrequestInfo[@"result"][@"address"]]?_dic_getrequestInfo[@"result"][@"address"]:@""  font:Font_filterTitle_17 maxSize:CGSizeMake(Main_Screen_Width-70, MAXFLOAT)];
    
    UILabel *lab_content = [GPUtils createLable:CGRectMake(5, 22, Main_Screen_Width-70, sizes.height) text:_dic_getrequestInfo[@"result"][@"address"] font:Font_filterTitle_17 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    lab_content.numberOfLines = 0;
    lab_content.isCopyable = YES;
    [view_commentAddress addSubview:lab_content];
    [_root_View addSubview:view_commentAddress];
    
    _scroll_View.contentSize = CGSizeMake(Main_Screen_Width, 400);
}

-(UIView *)CreateLableView:(NSString *)title content:(NSString *)content
{
    UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width-60, 55)];
    UIImageView *lineview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 4, 2, 12)];
    lineview.backgroundColor = Color_Blue_Important_20;
    [view addSubview:lineview];
    UILabel *lab_title = [GPUtils createLable:CGRectMake(5, 0, Main_Screen_Width-70, 20) text:Custing(title, nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [view addSubview:lab_title];
    UILabel *lab_content = [GPUtils createLable:CGRectMake(5, 22, Main_Screen_Width-70, 20) text:Custing(content,nil) font:Font_filterTitle_17 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    lab_content.numberOfLines = 0;
    lab_content.isCopyable = YES;
    if ([title isEqualToString:Custing(@"纳税人识别号",nil)]||[title isEqualToString:Custing(@"开户行账号",nil)]) {
        NSMutableString *str = [NSMutableString new];
        int max = 0;
        if ([NSString isEqualToNull:content]) {
            max = (int)ceil(content.length/4)+1;
        }
        NSString *string = @"";
        for (int i = 0; i<max; i++) {
            if (i==max-1) {
                string = [NSString stringWithFormat:@"%@ ",[content substringWithRange:NSMakeRange(i*4, content.length-i*4)]];
            }else{
                string = [NSString stringWithFormat:@"%@ ",[content substringWithRange:NSMakeRange(i*4, 4)]];
            }
            
            [str insertString:string atIndex:str.length];
        }
        lab_content.text = str;
    }
    [view addSubview:lab_content];
    return view;
}

#pragma mark - action
-(void)right_btn_click:(UIButton *)btn
{
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2
                                     withPlatformIcon:[UIImage imageNamed:@"Mine_socia"]
                                     withPlatformName:@"复制链接"];
    
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_UserDefine_Begin+2)]];
    __weak typeof(self) weakSelf = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建网页内容对象
        NSString* thumbURL =  weakSelf.str_BillInfo;
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:Custing(@"发票抬头", nil) descr:[NSString isEqualToNull:weakSelf.dic_getrequestInfo[@"result"][@"companyName"]]?weakSelf.dic_getrequestInfo[@"result"][@"companyName"]:@"链接" thumImage:[UIImage imageNamed:@"shareAvatar"]];
        
        //设置网页地址
        shareObject.webpageUrl = thumbURL;
        messageObject.shareObject = shareObject;
        if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"复制成功",nil) duration:1.0];
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            pboard.string = weakSelf.str_BillInfo;
        }else{
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    NSLog(@"************Share fail with error %@*********",error);
                }else{
                    NSLog(@"response data is %@",data);
                }
            }];
        }
    }];
}


#pragma mark - delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    NSString *success = [NSString stringWithFormat:@"%@",responceDic[@"success"]];
    if (![success isEqualToString:@"1"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"请求失败，请重试！" duration:1.0];
        return;
    }
    if (serialNum == 1) {
        _dic_getrequestInfo = responceDic;
        _str_BillInfo = [NSString stringWithFormat:@"%@?token=%@&uid=%@&id=%@",[UrlKeyManager getHelpURL:XB_InvoiceHead],self.userdatas.token,self.userdatas.userId,_Id];
        [self setupView];
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
