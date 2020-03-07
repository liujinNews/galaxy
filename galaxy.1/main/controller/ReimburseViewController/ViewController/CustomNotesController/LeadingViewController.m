//
//  LeadingViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/7/14.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "LeadingViewController.h"
#import "CustomLeadInController.h"
#import "CtripLeadController.h"
#import "DiDiBindController.h"
#import "DiDiImportViewController.h"
#import "TrvOneImportViewController.h"
#import "BusiTvlOrderViewController.h"

@interface LeadingViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>

@property (nonatomic, strong) UITableView *tab_tableview;
@property (nonatomic, strong) NSMutableArray *arr_Binding;
@property (nonatomic, strong) NSMutableArray *arr_BindingNo;

@property (nonatomic, strong) NSDictionary *dic_request;

/**
 *  区分viewwillapper是否请求数据
 */
@property(nonatomic,strong)NSString *requestType;

@property(nonatomic,copy)NSString *str_phone;

@end

@implementation LeadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"导入第三方订单", nil) backButton:YES];
    // Do any additional setup after loading the view from its nib.
    _tab_tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - NavigationbarHeight) style:UITableViewStylePlain];
    _tab_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tab_tableview.backgroundColor = Color_White_Same_20;
    _tab_tableview.dataSource = self;
    _tab_tableview.delegate = self;
    [self.view addSubview:_tab_tableview];
    [self requestDic];
    _requestType=@"1";

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    if (![_requestType isEqualToString:@"1"]) {
        [self requestDic];
    }
    _requestType=@"0";
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

#pragma mark - function
-(void)requestDic{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",XB_PlatformsList];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}

-(void)handleData{
    _arr_Binding = [NSMutableArray array];
    _arr_BindingNo = [NSMutableArray array];
    NSArray *arr = _dic_request[@"result"];
    if (arr.count>0) {
        for (int i = 0; i<arr.count; i++) {
            NSDictionary *dic = arr[i];
            if ([dic[@"bindings"]intValue]==1) {
                if ([dic[@"code"] isEqualToString:@"LA517"]) {
                    NSMutableDictionary *ciDict = [NSMutableDictionary dictionary];
                    [ciDict setValue:Custing(@"商旅出行", nil) forKey:@"name"];
                    [ciDict setValue:@"LA517" forKey:@"code"];
                    [ciDict setValue:@"LA517" forKey:@"logo"];
                    [_arr_Binding addObject:ciDict];
                }else{
                    [_arr_Binding addObject:dic];
                }
                
                
            }else{
                [_arr_BindingNo addObject:dic];
            }
        }
    }
//    [_arr_Binding addObject:@{@"code":@"CITSAMEX",@"name":@"商旅订单",@"logo":@"CITSAMEX"}];
    [_tab_tableview reloadData];
}

#pragma mark - delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    if (serialNum == 0) {
        _dic_request = responceDic;
        [self handleData];
    }else if (serialNum == 1){
        if ([responceDic[@"result"] isKindOfClass:[NSDictionary class]]) {
            DiDiImportViewController *vc=[[DiDiImportViewController alloc]init];
            vc.str_phone = self.str_phone;
            vc.str_payType = [NSString stringWithIdOnNO:responceDic[@"result"][@"ordPayType"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(serialNum == 2){
        if ([responceDic[@"result"] isKindOfClass:[NSDictionary class]]) {
            //进入差旅一号订单列表
        }
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_arr_Binding.count>0&&_arr_BindingNo.count>0) {
        if (section==0) {
            return _arr_Binding.count;
        }else{
            return _arr_BindingNo.count;
        }
    }
    if (_arr_Binding.count>0||_arr_BindingNo.count>0) {
        if (_arr_Binding.count>0) {
            return _arr_Binding.count;
        }else{
            return _arr_BindingNo.count;
        }
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_arr_Binding.count>0&&_arr_BindingNo.count>0) {
        return 2;
    }
    if (_arr_Binding.count>0||_arr_BindingNo.count>0) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 27;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0,107, Main_Screen_Width, 27)];
    headView.backgroundColor=Color_White_Same_20;
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 4, 27)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [headView addSubview:ImgView];
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(0, 0, 200, 18) text:@"" font:Font_Important_15_20 textColor:Color_Unsel_TitleColor textAlignment:NSTextAlignmentLeft];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+115, 13.5);
    [headView addSubview:titleLabel];
    if (section==0) {
        if (_arr_Binding.count>0) {
            titleLabel.text =Custing(@"已绑定", nil) ;
        }else{
            titleLabel.text =Custing(@"未绑定", nil) ;
        }
    }else{
        titleLabel.text =Custing(@"未绑定", nil) ;
    }
    return headView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic;
    if (indexPath.section==0) {
        if (_arr_Binding.count>0) {
            dic = _arr_Binding[indexPath.row];
        }else{
            dic = _arr_BindingNo[indexPath.row];
        }
    }else{
        dic = _arr_BindingNo[indexPath.row];
    }
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 40, 40)];
    image.image = [UIImage imageNamed:[NSString isEqualToNull:dic[@"logo"]]?dic[@"logo"]:@""];
    [cell addSubview:image];
    
    UILabel *lab = [GPUtils createLable:CGRectMake(70, 22, Main_Screen_Width-85, 20) text:[NSString isEqualToNull:dic[@"name"]]?dic[@"name"]:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:lab];
    UIImageView *borrowicon = [GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-25, 24, 10, 16) imageName:@"ApproveRemind_Right"];
    [cell addSubview:borrowicon];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==1) {
        UILabel *label=[GPUtils createLable:CGRectMake(Main_Screen_Width-25-100, 0, 95, 64) text:Custing(@"绑定", nil) font:Font_Important_15_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentRight];
        [cell addSubview:label];
    }
    
    [cell addSubview:[self createLineViewOfHeight:63.5]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic;
    if (indexPath.section==0) {
        dic = _arr_Binding[indexPath.row];
        if ([dic[@"logo"]isEqualToString:@"HuaZhu"]) {
            CustomLeadInController *vc=[[CustomLeadInController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([dic[@"logo"]isEqualToString:@"Ctrip"]) {
            CtripLeadController *vc=[[CtripLeadController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([dic[@"logo"]isEqualToString:@"Didi"]) {
            self.str_phone = [NSString stringWithIdOnNO:dic[@"account"]];
            [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
            NSString *url=[NSString stringWithFormat:@"%@",GETDIDICORPINFO];
            [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
        }
        else if([dic[@"logo"]isEqualToString:@"LA517"]){//商旅订单
            BusiTvlOrderViewController *vc = [[BusiTvlOrderViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section==1){
        dic = _arr_BindingNo[indexPath.row];
        if ([[NSString stringWithFormat:@"%@",[NSString isEqualToNull:dic[@"status"]]?dic[@"status"]:@"0"]isEqualToString:@"0"]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"滴滴企业账号没开通,请联系管理员", nil) duration:1.0];
            return;
        }
        if ([dic[@"logo"]isEqualToString:@"Didi"]) {
            DiDiBindController *vc=[[DiDiBindController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([dic[@"logo"] isEqualToString:@"LA517"]) {
            TrvOneImportViewController *vc = [[TrvOneImportViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
  
    
    
    
    NSLog(@"section%ld  row%ld",(long)indexPath.section,(long)indexPath.row);
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
