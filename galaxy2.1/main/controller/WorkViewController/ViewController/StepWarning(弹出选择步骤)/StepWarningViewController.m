//
//  StepWarningViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2016/12/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "StepWarningViewController.h"
#import "SelectViewController.h"

@interface StepWarningViewController ()<SelectViewControllerDelegate,GPClientDelegate>
@property (nonatomic, strong) UITextField *txf_Step;
@property (nonatomic, strong) NSString *stepId;
@end

@implementation StepWarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"选择审批步骤", nil) backButton:YES];
    //设置主页面
    [self.view setBackgroundColor:Color_White_Same_20];
    [self SetIntoView];
}

-(void)SetIntoView{
    UIView *_headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    _headView.backgroundColor = Color_White_Same_20;
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [_headView addSubview:ImgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,Main_Screen_Width-30, 18)];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+Main_Screen_Width/2-4, 13.5);
    titleLabel.font=Font_Important_15_20 ;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=Color_Unsel_TitleColor;
    titleLabel.text = Custing(@"选择当前审批步骤名称", nil);
    [_headView addSubview:titleLabel];
    
    [self.view addSubview:_headView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 27, Main_Screen_Width, 45)];
    view.backgroundColor = Color_form_TextFieldBackgroundColor;
    UIButton *btn=[GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 45) action:@selector(btn_Click:) delegate:self];
    btn.tag = 107;
    [view addSubview:btn];
    UIImageView * iconImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skipImage"]];
    iconImage.frame = CGRectMake(Main_Screen_Width-32, 12, 20, 20);
    [view addSubview:iconImage];
    _txf_Step = [GPUtils createTextField:CGRectMake(27, 0, Main_Screen_Width-35, 45) placeholder:Custing(@"请选择", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    [view addSubview:_txf_Step];
    _txf_Step.userInteractionEnabled = NO;
    [self.view addSubview:view];
    
    UIButton *btn_ok = [GPUtils createButton:CGRectMake(15, 90, Main_Screen_Width-30, 45) action:@selector(btn_Click:) delegate:self title:Custing(@"确定", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    btn_ok.tag = 2;
    [btn_ok setBackgroundColor:Color_Blue_Important_20];
    btn_ok.layer.cornerRadius = 10;
    [self.view addSubview:btn_ok];
    
}

#pragma mark - action
-(void)btn_Click:(UIButton *)btn
{
    if (btn.tag == 2) {
        if ([NSString isEqualToNull:_stepId]) {
            [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",UpdateProcNodeId] Parameters:@{@"ProcId":[NSString isEqualToNull:_procid]?_procid:@"0",@"NodeId":_stepId,@"NodeName":_txf_Step.text} Delegate:self SerialNum:0 IfUserCache:NO];
        }else{
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择审批步骤", nil) duration:2.0];
        }
    }else{
        SelectViewController *sele = [[SelectViewController alloc]init];
        sele.type = 4;
        sele.FlowGuid = _FlowGuid;
        sele.delegate = self;
        [self.navigationController pushViewController:sele animated:YES];
    }
}

#pragma mark = delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    NSString *success = [NSString stringWithFormat:@"%@",responceDic[@"success"]];
    if (![success isEqualToString:@"1"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
        return;
    }
    else
    {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"保存成功", nil) duration:2.0];
        [self performBlock:^{
            [self returnBack];
        } afterDelay:1.5];
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

-(void)SelectViewControllerClickedLoadBtn:(SelectDataModel *)selectmodel{
    _txf_Step.text = selectmodel.nodeName;
    _stepId = selectmodel.nodeId;
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
