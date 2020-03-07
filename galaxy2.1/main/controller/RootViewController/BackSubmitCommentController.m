//
//  BackSubmitCommentController.m
//  galaxy
//
//  Created by hfk on 2018/3/26.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "BackSubmitCommentController.h"

@interface BackSubmitCommentController ()<GPClientDelegate>

@property(nonatomic,strong)UITextView *txv_Comment;

@end

@implementation BackSubmitCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    if (self.type==1) {
        [self setTitle:Custing(@"重新提交", nil) backButton:YES];
    }else if (self.type==2){
        [self setTitle:Custing(@"直送", nil) backButton:YES];
    }
    [self createComment];
}
-(void)createComment{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"确定", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(btn_right_click)];
    
    UIView *View_Comment=[[UIView alloc]init];
    View_Comment.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view addSubview: View_Comment];
    [View_Comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    
    _txv_Comment=[[UITextView alloc]init];
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.tips=Custing(@"请输入原因", nil);
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:View_Comment WithContent:_txv_Comment WithFormType:formViewVoiceNoTitleTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [View_Comment addSubview:view];
}
-(void)btn_right_click{
    [self keyClose];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    if (self.type==1) {
        NSMutableDictionary *Parameters=[NSMutableDictionary dictionaryWithDictionary:[self.FormDatas SubmitFormAgainWithExpIds:self.FormDatas.str_submitId  WithComment:self.txv_Comment.text WithCommonField:self.str_CommonField?self.str_CommonField:@""]];
        if ([self.FormDatas.str_flowCode isEqualToString:@"F0009"]&&_bool_AddPars) {
            [Parameters setValue:_str_PayAmount forKey:@"Amount"];
            [Parameters setValue:_str_PayContGridOrder forKey:@"ContGridOrder"];
            [Parameters setValue:_str_PayContractNumber forKey:@"ContractNumber"];
        }
        [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getBackSubmitUrl] Parameters:Parameters Delegate:self SerialNum:0 IfUserCache:NO];
    }else if (self.type==2){
        NSMutableDictionary *Parameters=[NSMutableDictionary dictionaryWithDictionary:[self.FormDatas DirectFormWithExpIds:self.FormDatas.str_submitId WithComment:self.txv_Comment.text WithCommonField:self.str_CommonField?self.str_CommonField:@""]];
        if ([self.FormDatas.str_flowCode isEqualToString:@"F0009"]&&_bool_AddPars) {
            [Parameters setValue:_str_PayAmount forKey:@"Amount"];
            [Parameters setValue:_str_PayContGridOrder forKey:@"ContGridOrder"];
            [Parameters setValue:_str_PayContractNumber forKey:@"ContractNumber"];
        }
        [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getDirectUrl] Parameters:Parameters Delegate:self SerialNum:0 IfUserCache:NO];
    }
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
            NSString * successRespone = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:successRespone];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"result"]] forKey:@"TaskId"];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goSubmitSuccessTo:) userInfo:dict repeats:NO];
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

-(void)goSubmitSuccessTo:(NSTimer *)timer{
    NSString *goId=[[timer userInfo] objectForKey:@"TaskId"];
    if ([NSString isEqualToNull:goId]) {
        NSDictionary *dict=[[VoiceDataManger sharedManager]getControllerNameWithFlowCode:self.FormDatas.str_flowCode];
        NSString *controller=dict[@"pushHasController"];
        Class cls = NSClassFromString(controller);
        UIViewController *vc = [[cls alloc] init];
        vc.pushTaskId=[NSString stringWithFormat:@"%@",goId];
        vc.pushFlowCode=self.FormDatas.str_flowCode;
        vc.pushComeStatus=@"1";
        vc.pushBackIndex=@"1";
        [self.navigationController pushViewController:vc animated:YES];
    }
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
