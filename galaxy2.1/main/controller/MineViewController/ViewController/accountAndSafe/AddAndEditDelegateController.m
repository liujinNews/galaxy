//
//  AddAndEditDelegateController.m
//  galaxy
//
//  Created by hfk on 2018/8/8.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AddAndEditDelegateController.h"
#import "SetDelegatePeopleVController.h"

@interface AddAndEditDelegateController ()<GPClientDelegate>

@property (nonatomic,strong)UITextField * txf_agent;
@property (nonatomic,strong)UITextField * txf_hasApprove;
@property (nonatomic,strong)NSString  *str_hasApprove;
@property (nonatomic, strong) NSMutableArray *arr_power;


@end

@implementation AddAndEditDelegateController

-(NSMutableArray *)arr_power{
    if (_arr_power == nil) {
        _arr_power = [NSMutableArray array];
        NSArray *type = @[Custing(@"提交单据", nil),Custing(@"审批单据", nil)];
        NSArray *code = @[@"0",@"1"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type = type[i];
            model.Id = code[i];
            [_arr_power addObject:model];
        }
    }
    return _arr_power;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color_White_Same_20;
    if (self.dict) {
        [self setTitle:Custing(@"修改代理人", nil) backButton:YES];
        self.str_hasApprove = [[NSString stringWithFormat:@"%@",self.dict[@"taskApproval"]]isEqualToString:@"0"] ? @"0":@"1";
    }else{
        [self setTitle:Custing(@"新增代理人", nil) backButton:YES];
        self.str_hasApprove = @"1";
    }
    [self createView];
}

-(void)createView{
    
    __weak typeof(self) weakSelf = self;
    UIView *AgentView=[[UIView alloc]init];
    AgentView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view addSubview:AgentView];
    [AgentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
    }];
    _txf_agent=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:AgentView WithContent:_txf_agent WithFormType:self.dict ? formViewShowText:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"代理人", nil) WithInfodict:@{@"value1":self.dict ? [NSString stringWithIdOnNO:self.dict[@"agentUserName"]]:@""} WithTips:self.dict ?@"":Custing(@"请选择代理人", nil) WithNumLimit:200];
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf chooseAgentData:nil];
    }];
    [AgentView addSubview:view];
    
    UIView *HasView=[[UIView alloc]init];
    HasView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view addSubview:HasView];
    [HasView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(AgentView.bottom);
        make.left.right.equalTo(self.view);
    }];
    _txf_hasApprove=[[UITextField alloc]init];
    SubmitFormView *view1=[[SubmitFormView alloc]initBaseView:HasView WithContent:_txf_hasApprove WithFormType:formViewSelect WithSegmentType:lineViewOnlyLine WithString:Custing(@"授权范围", nil) WithInfodict:@{@"value1":[self.str_hasApprove isEqualToString:@"1"] ? Custing(@"审批单据", nil):Custing(@"提交单据", nil)} WithTips:Custing(@"请选择授权范围", nil) WithNumLimit:200];
    [view1 setFormClickedBlock:^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.str_hasApprove = Model.Id;
            weakSelf.txf_hasApprove.text = Model.Type;
        }];
        picker.typeTitle=Custing(@"授权范围", nil);
        picker.DateSourceArray=weakSelf.arr_power;
        STOnePickModel *model1=[[STOnePickModel alloc]init];
        model1.Id = weakSelf.str_hasApprove;
        picker.Model=model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [HasView addSubview:view1];

    
    UIButton *saveBtn = [GPUtils createButton:CGRectZero action:@selector(saveinfo:) delegate:self title:Custing(@"保存", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    saveBtn.backgroundColor = Color_Blue_Important_20;
    saveBtn.layer.cornerRadius = 11.0f;
    saveBtn.layer.masksToBounds = YES;
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(HasView.bottom).offset(@40);
        make.left.equalTo(self.view).offset(@12);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-24, 50));
    }];
    
}


-(void)chooseAgentData:(UIButton *)btn{
    SetDelegatePeopleVController *vc = [[SetDelegatePeopleVController alloc]init];
    if (self.dict) {
        NSDictionary *dict = @{@"agentUserId":[NSString stringWithIdOnNO:self.dict[@"agentUserId"]]};
        vc.arrClickPeople = [NSMutableArray arrayWithObject:dict];
    }
    __weak typeof(self) weakSelf = self;
    [vc setChooseDelegateBlock:^(NSArray *array) {
        NSDictionary *dict= array[0];
        if (dict) {
            weakSelf.dict = @{@"agentUserId":[NSString stringWithIdOnNO:dict[@"requestorUserId"]],
                              @"agentUserAccount":[NSString stringWithIdOnNO:dict[@"requestorAccount"]],
                              @"agentUserName":[NSString stringWithIdOnNO:dict[@"requestor"]]
                              };
            self.txf_agent.text = weakSelf.dict[@"agentUserName"];
        }
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)saveinfo:(id)sender{
    if (!self.dict) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择代理人", nil) duration:2.0];
        return;
    }
    NSDictionary *dic = @{@"AgentUserId":self.dict[@"agentUserId"],@"AgentUserAccount":self.dict[@"agentUserAccount"],@"AgentUserName":self.dict[@"agentUserName"],@"TaskApproval":self.str_hasApprove};
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",delegated_save] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        [YXSpritesLoadingView dismiss];
        return;
    }
    
    switch (serialNum) {
        case 0:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"保存成功", nil) duration:1.5];
            __weak typeof(self) weakSelf = self;
            [self performBlock:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } afterDelay:1.5];
        }
            break;
       
        default:
            break;
    }
    
}
//MARK:-请求失败
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
