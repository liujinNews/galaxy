//
//  SendEmailViewController.m
//  galaxy
//
//  Created by hfk on 2018/3/29.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "SendEmailViewController.h"

@interface SendEmailViewController ()<GPClientDelegate,UIScrollViewDelegate>
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;
@property (nonatomic, strong) UITextField *txf_MailTo;
@property (nonatomic, strong) UITextField *txf_MailCc;
@property (nonatomic, strong) UITextField *txf_MailSubject;

@end

@implementation SendEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    [self setTitle:[NSString stringWithFormat:@"%@%@",self.model_Send.str_Requestor,Custing(@"的报销申请单打印", nil)] backButton:YES];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"发送", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(btn_click:)];
    [self createMainView];

}
-(void)createMainView{
    
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.width.equalTo(self.view);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    

    UIView *MailToView=[[UIView alloc]init];
    MailToView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:MailToView];
    [MailToView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_MailTo=[[UITextField alloc]init];
    [MailToView addSubview:[[SubmitFormView alloc]initBaseView:MailToView WithContent:_txf_MailTo WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"收件人", nil) WithTips:Custing(@"请输入收件人邮箱", nil) WithInfodict:nil]];
    
    
    UIView *MailCcView=[[UIView alloc]init];
    MailCcView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:MailCcView];
    [MailCcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(MailToView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_MailCc=[[UITextField alloc]init];
    [MailCcView addSubview:[[SubmitFormView alloc]initBaseView:MailCcView WithContent:_txf_MailCc WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"抄送", nil) WithTips:Custing(@"请输入抄送人邮箱(英文,分割)", nil) WithInfodict:nil]];
    
    
    UIView *MailSubjectView=[[UIView alloc]init];
    MailSubjectView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:MailSubjectView];
    [MailSubjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(MailCcView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_MailSubject=[[UITextField alloc]init];
    [MailSubjectView addSubview:[[SubmitFormView alloc]initBaseView:MailSubjectView WithContent:_txf_MailSubject WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"主题", nil) WithTips:Custing(@"请输入主题", nil) WithInfodict:nil]];
    
    
    UIView *SegmentLineView=[[UIView alloc]init];
    SegmentLineView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:SegmentLineView];
    [SegmentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(MailSubjectView.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@10);
    }];

    CGSize size = [self.model_Send.str_Link sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    UIView *View_Content=[[UIView alloc]init];
    View_Content.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:View_Content];
    [View_Content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SegmentLineView.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@(size.height+20));
    }];

    UILabel *lab_Content=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@%@%@",self.model_Send.str_Requestor,Custing(@"的报销单链接：", nil), self.model_Send.str_Link] font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    lab_Content.numberOfLines=0;
    [View_Content addSubview:lab_Content];
    [lab_Content makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_Content.top).offset(@10);
        make.left.equalTo(self.contentView.left).offset(@12);
        make.right.equalTo(self.contentView.right).offset(@-12);
        make.height.equalTo(@(size.height));
    }];

    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(View_Content.bottom);
    }];
}

-(void)btn_click:(UIButton *)btn{
    if (self.txf_MailTo.text.length==0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入收件人邮箱", nil) duration:2.0];
        return;
    }
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *MailBody;
    if ([self.userdatas.language isEqualToString:@"ch"]) {
        MailBody=@"<div style=\"background-color:#f1f1f1;padding:20px;  \"><p style=\"color:#000;font-size:18px;\"><span>NAMEKEY</span>您好:</p><br><p><span style=\"color:#000;\">打印链接：</span><a href=\"URLKEY\">URLKEY</a></p><p><span style=\"color:#000;\"> 密码：</span><span style=\"color:#f37e34;\">PAWKEY</span></p><p style=\"color:#8f8f8f;\">(打开链接十五分钟内有效)</p> <hr style=\"color:#ccc3\"><p>DEVICEKEY</p></div>";
    }else{
        MailBody=@"<div style=\"background-color:#f1f1f1;padding:20px;  \"><p style=\"color:#000;font-size:18px;\"><span>Hi,</span>NAMEKEY</p><br><p><span style=\"color:#000;\">Print link：</span><a href=\"URLKEY\">URLKEY</a></p><p><span style=\"color:#000;\"> Password：</span><span style=\"color:#f37e34;\">PAWKEY</span></p><p style=\"color:#8f8f8f;\">(Valid within fifteen minutes)</p> <hr style=\"color:#ccc3\"><p>DEVICEKEY</p></div>";
    }
    
    MailBody=[MailBody stringByReplacingOccurrencesOfString:@"NAMEKEY" withString:self.model_Send.str_Requestor];
    MailBody=[MailBody stringByReplacingOccurrencesOfString:@"URLKEY" withString:self.model_Send.str_Link];
    MailBody=[MailBody stringByReplacingOccurrencesOfString:@"PAWKEY" withString:self.model_Send.str_Password];
    MailBody=[MailBody stringByReplacingOccurrencesOfString:@"DEVICEKEY" withString:Custing(@"来自我的iPhone", nil)];
    NSDictionary *Parameters=@{@"MailTo":self.txf_MailTo.text,@"MailCcc":self.txf_MailCc.text,@"MailSubject":self.txf_MailSubject.text,@"MailBody":MailBody};
    NSString *url=[NSString stringWithFormat:@"%@",SENDFORMEMAIL];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:Parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:下载成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    switch (serialNum) {
        case 0:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"发送成功", nil) duration:2.0];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1.5];
        }
            break;
        default:
            break;
    }
    
}

//MARK:请求失败
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
