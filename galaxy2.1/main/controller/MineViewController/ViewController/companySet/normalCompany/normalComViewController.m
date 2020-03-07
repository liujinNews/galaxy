//
//  normalComViewController.m
//  galaxy
//
//  Created by 赵碚 on 2016/12/26.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "ticketSpecificationViewController.h"
#import "LookBillInfoViewController.h"
#import "ReiStandardViewController.h"
#import "costCenterCell.h"
#import "normalComViewController.h"
#import "BillInfoListController.h"
#import "StdBranchListController.h"

@interface normalComViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * normalArray;
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;

@end

@implementation normalComViewController
-(id)initWithType:(NSDictionary *)type{
    self = [super init];
    if (self) {
//        self.electDic = type;
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.normalArray = @[@{@"normalImage":@"NormalForStandard",@"normalType":Custing(@"报销标准", nil)},@{@"normalImage":@"NormalTicketSpecification",@"normalType":Custing(@"报销规范", nil)}];
    [self setTitle:Custing(@"企业信息", nil) backButton:YES];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.normalArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    costCenterCell *cell=[tableView dequeueReusableCellWithIdentifier:@"costCenterCell"];
    if (cell==nil) {
        cell=[[costCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"costCenterCell"];
    }
    NSDictionary *name = self.normalArray[indexPath.row];
    [cell configNormalCompanyTypeCellInfo:name];
    return cell;
}

//当前行点击事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name = self.normalArray[indexPath.row][@"normalType"];
    if ([name isEqualToString:Custing(@"发票抬头", nil)]) {
        [self requestList];
    }else if ([name isEqualToString:Custing(@"报销标准", nil)]){
        [self requestBranchStdSet];
    }else if ([name isEqualToString:Custing(@"报销规范", nil)]){
        ticketSpecificationViewController * ticket = [[ticketSpecificationViewController alloc]initWithType:@{@"ticket":@"normal"}];
        [self.navigationController pushViewController:ticket animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//请求开票信息
-(void)requestList{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@", GetCoCardList];
    [[GPClient shareGPClient]RequestByGetWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}
//是否开启分公司标准
-(void)requestBranchStdSet{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@", GETBRANCHSTDSET];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    _resultDict = responceDic;
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
            [self dealWithData];
            break;
        case 1:
        {
            if ([responceDic[@"result"] isKindOfClass:[NSArray class]]) {
                if ([responceDic[@"result"][0] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = responceDic[@"result"][0];
                    if ([[NSString stringWithFormat:@"%@",dict[@"paramValue"]]isEqualToString:@"1"]) {
                        StdBranchListController *vc = [[StdBranchListController alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        ReiStandardViewController * financial = [[ReiStandardViewController alloc]init];
                        [self.navigationController pushViewController:financial animated:YES];
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}
-(void)dealWithData{
    if (![_resultDict[@"result"] isKindOfClass:[NSNull class]]) {
        NSArray *arr=_resultDict[@"result"];
        if (arr.count==1) {
            NSDictionary *dict=arr[0];
            LookBillInfoViewController *look = [[LookBillInfoViewController alloc]init];
            look.Id=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"id"]]]?[NSString stringWithFormat:@"%@",dict[@"id"]]:@"0";
            [self.navigationController pushViewController:look animated:YES];
        }else{
            BillInfoListController *vc=[[BillInfoListController alloc]init];
            vc.CanDeal=NO;
            vc.resultDict=_resultDict;
            [self.navigationController pushViewController:vc animated:YES];
        }
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
