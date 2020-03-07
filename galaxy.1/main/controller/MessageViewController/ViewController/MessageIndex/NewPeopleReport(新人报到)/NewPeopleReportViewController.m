//
//  NewPeopleReportViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/4/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "StatisticalView.h"

#import "NewPeopleReportViewController.h"
#import "NewPeopleReportTableViewCell.h"
#import "EditPeopleNewViewController.h"

@interface NewPeopleReportViewController ()<UITableViewDataSource,UITableViewDelegate,GPClientDelegate,StatisticalViewDelegate,NewPeopleReportTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tab_tabview;

@property (nonatomic, strong)NSDictionary *resultDict;

@property (nonatomic, strong)NSMutableArray *showArray;
@property (nonatomic,strong)StatisticalView * dateView;
@property (nonatomic,strong)NSDictionary * EditDic;

@end

@implementation NewPeopleReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:Custing(@"新人报到", nil) backButton:YES];
    _tab_tabview.dataSource = self;
    _tab_tabview.delegate = self;
    _tab_tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tab_tabview.rowHeight = 96;
    
//    _resultDict = [NSString dictionaryWithJsonString:@"{\"success\":true,\"result\":[{\"requestor\":\"根据LOL\",\"jobTitle\":null,\"requestrDeptId\":0,\"photoGraph\":null,\"gender\":0,\"contact\":\"17765109284\",\"companyId\":0,\"userDspName\":null,\"costCenter\":null,\"requestorAccount\":\"17765109284\",\"jobTitleCode\":null,\"isActivated\":1,\"requestorDept\":null,\"email\":null,\"requestorUserId\":21371,\"requestorHRID\":null},{\"requestor\":\"根据XXXL\",\"jobTitle\":null,\"requestorDeptId\":0,\"photoGraph\":null,\"gender\":0,\"contact\":\"17765109284\",\"companyId\":0,\"userDspName\":null,\"costCenter\":null,\"requestorAccount\":\"17765109284\",\"jobTitleCode\":null,\"isActivated\":0,\"requestorDept\":null,\"email\":null,\"requestorUserId\":21371,\"requestorHRID\":null}],\"msg\":null,\"unAuthorizedRequest\":false,\"error\":null}"];
//
//    [self newPeopleData];
//     Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    [self requestNewPeople];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

#pragma mark - function
//获取新加入员工
-(void)requestNewPeople
{
    NSString *url=[NSString stringWithFormat:@"%@",getnewbieboard];
    NSDictionary *parameters = @{};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:3 IfUserCache:NO];
}

//删除员工
- (void)requestDeleteuser:(NSString *)str
{
    NSDictionary *adddic = @{@"UserId":str};
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",deleteuser] Parameters:adddic Delegate:self SerialNum:7 IfUserCache:NO];
}

-(void)requestupdateuserisa:(NSDictionary *)dic
{
    NSString *url=[NSString stringWithFormat:@"%@",updateuserisa];
    NSDictionary *parameters = @{@"UserId":dic[@"requestorUserId"],@"UserDspName":dic[@"requestor"]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:4 IfUserCache:NO];
}

-(void)requestuserReject:(NSDictionary *)dic
{
    NSString *url=[NSString stringWithFormat:@"%@",userReject];
    NSDictionary *parameters = @{@"UserId":dic[@"requestorUserId"]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:6 IfUserCache:NO];
}
  
-(void)newPeopleData
{
    NSArray *array =_resultDict[@"result"];
    if (array.count==0||[array isEqual:[NSNull null]]) {
    }else{
        if (!_showArray) {
            _showArray = [[NSMutableArray alloc]init];
        }
        [_showArray removeAllObjects];
        for (int i = 0; i<array.count; i++) {
            [_showArray addObject:array[i]];
        }
        [_tab_tabview reloadData];
    }
    [self createNOdataView];
}

//MARK:创建无数据视图
-(void)createNOdataView{
    [_tab_tabview configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有新人报到哦", nil) hasData:(_showArray.count!=0) hasError:NO reloadButtonBlock:nil];
}

#pragma mark - 代理
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    _resultDict = responceDic;    
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        if (serialNum == 4) {
            NSString * result = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"result"]];
            if ([result isEqualToString:@"-1"]) {
                //用户数用完
                if (self.userdatas.checkExpiryDic != nil) {
                    NSString * isAdmin = [NSString stringWithFormat:@"%@",[self.userdatas.checkExpiryDic objectForKey:@"isAdmin"]];
                    if ([isAdmin isEqualToString:@"1"]) {
                        [self createXueFeiLogin];
                        [YXSpritesLoadingView dismiss];
                        return;
                    }else {
                        EditPeopleNewViewController *edit = [[EditPeopleNewViewController alloc]init];
                        edit.userId = self.EditDic[@"requestorUserId"];
                        if ([self.EditDic[@"isActivated"]intValue]!=1) {
                            edit.isNowPeople = 1;
                        }
                        [self.navigationController pushViewController:edit animated:YES];
                    }
                }
            }
        }
        
        [YXSpritesLoadingView dismiss];
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    else
    {
        switch (serialNum) {
            case 0:
                break;
            case 1:
                break;
            case 3:
                [YXSpritesLoadingView dismiss];
                [self newPeopleData];
                break;
            case 4:
            {
                [self requestNewPeople];
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"同意成功", nil) duration:1.0];
//                [_tab_tabview reloadData];
                EditPeopleNewViewController *edit = [[EditPeopleNewViewController alloc]init];
                edit.userId = self.EditDic[@"requestorUserId"];
                if ([self.EditDic[@"isActivated"]intValue]!=1) {
                    edit.isNowPeople = 0;
                }
                [self.navigationController pushViewController:edit animated:YES];
                return;
                break;
            }
            case 6:{
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"拒绝成功", nil) duration:1.0];
                [self requestNewPeople];
                break;
            }
            case 7:
            {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:1.0];
                [self requestNewPeople];
                break;
            };
            default:
                break;
        }
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

//点击代理
-(void)NewPeopleReportTableViewCellClickedLoadBtn:(NSDictionary *)dic isReject:(int)Reject
{
    if (Reject == 0) {
        self.EditDic = dic;
        if ([dic[@"isActivated"]intValue]!=1) {
            [self requestupdateuserisa:dic];
        }
    }else{
        self.EditDic = dic;
        if ([dic[@"isActivated"]intValue]!=1) {
            [self requestuserReject:dic];
        }
    }
}

//创建tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _showArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewPeopleReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewPeopleReportTableViewCell"];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewPeopleReportTableViewCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 95, Main_Screen_Width, 0.5)];
    image.backgroundColor = Color_GrayLight_Same_20;
    [cell addSubview:image];
    cell.dic = _showArray[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _showArray[indexPath.row];
    if ([dic[@"isActivated"]intValue]!=1) {
        return;
    }
    EditPeopleNewViewController *edit = [[EditPeopleNewViewController alloc]init];
    edit.userId = dic[@"requestorUserId"];
    if ([dic[@"isActivated"]intValue]!=1) {
        edit.isNowPeople = 1;
    }
    [self.navigationController pushViewController:edit animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _showArray[indexPath.row];
    if ([dic[@"isActivated"]intValue]==1) {
        return NO;
    }
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = _showArray[indexPath.row];
        [self requestDeleteuser:dic[@"requestorUserId"]];
    }
}

//续费登录
-(void)createXueFeiLogin {
    
    UIView * View = [[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-135, 0,270, 345)];
    View.backgroundColor = Color_form_TextFieldBackgroundColor;
    View.layer.cornerRadius = 15.0f;
    View.userInteractionEnabled = YES;
    
    UIImageView * alertView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,270, 372/2)];
    alertView.image = GPImage(@"ArrearsNotification");
    alertView.backgroundColor = [UIColor clearColor];
    [View addSubview:alertView];
    
    UILabel * oneLa = [GPUtils createLable:CGRectMake(0, 372/2+5, 270, 50) text:Custing(@"您的公司购买的用户数已经用完", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
    oneLa.numberOfLines = 0;
    oneLa.backgroundColor = [UIColor clearColor];
    [View addSubview:oneLa];
    
    UILabel * twoLa = [GPUtils createLable:CGRectMake(0, 372/2+45, 270, 50) text:Custing(@"请前往网页端购买用户数", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
    twoLa.numberOfLines = 0;
    twoLa.backgroundColor = [UIColor clearColor];
    [View addSubview:twoLa];
    
    UIButton * chooseBtn = [GPUtils createButton:CGRectMake(67.5, 285, 135, 35) action:@selector(wozhdiaole:) delegate:self title:Custing(@"我知道了", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    chooseBtn.backgroundColor = Color_Blue_Important_20;
    chooseBtn.layer.cornerRadius = 10.0f;
    [View addSubview:chooseBtn];
    
    
    if (!self.dateView) {
        self.dateView = [[StatisticalView alloc]initWithStatisticalFrame:CGRectMake(0,Main_Screen_Height, 0, 0) pickerView:View titleView:nil];
        self.dateView.delegate = self;
    }
    [self.dateView showStatisticalDownView:View frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
}

//键盘取消
- (void)dimsissStatisticalPDActionView{
    self.dateView = nil;
}
//键盘显示通知
-(void)keyboardWillShow:(NSNotification*)notification{
    
    if (_dateView) {
        [_dateView removeStatistical];
    }
}

- (void)wozhdiaole:(UIButton *)btn {
    [self.dateView removeStatistical];
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
