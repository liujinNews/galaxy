//
//  ElectInvoiceViewController.m
//  galaxy
//
//  Created by 赵碚 on 2016/12/21.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "ImportElInController.h"
#import "ElectInvoiceData.h"
#import "ElectInvoiceCell.h"
#import "ElectInvoiceViewController.h"
#import "ElectInvoiceInfoViewController.h"

@interface ElectInvoiceViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * electArray;
@property (nonatomic,strong)NSDictionary * electDic;
@property (nonatomic,strong)NSString * perOrComStr;
@property (nonatomic,strong)NSString * refushStr;
@property (nonatomic,strong)UIButton * importBtn;

@property (nonatomic,strong)UIView * footView;

@end

@implementation ElectInvoiceViewController
-(id)initWithType:(NSDictionary *)type{
    self = [super init];
    if (self) {
       self.electDic = type;
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
    if ([self.refushStr isEqualToString:@"YES"]) {
        [self requestGetInvoiceListData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"电子发票", nil) backButton:YES];
    self.electArray = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight-45)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self createFootView];
    self.tableView.tableFooterView = self.footView;
    
    self.refushStr = @"NO";
    [self requestGetInvoiceListData];
    self.importBtn = [GPUtils createButton:CGRectMake(0,ScreenRect.size.height - 45 - NavigationbarHeight, Main_Screen_Width,45) action:@selector(ImportElectInvoice:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"导入", nil) font:Font_Important_15_20 color:Color_form_TextFieldBackgroundColor];
    [self.importBtn setBackgroundColor:Color_Blue_Important_20];
    [self.view addSubview: self.importBtn];
    
    // Do any additional setup after loading the view.
}

-(void)createFootView {
    self.footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 30)];
    self.footView.backgroundColor = [UIColor clearColor];
    [self.tableView addSubview:self.footView];
    
    UILabel * titleLa = [GPUtils createLable:CGRectMake(0, 10, Main_Screen_Width, 20) text:Custing(@"仅支持百望电子开具的电子发票", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
    titleLa.backgroundColor = [UIColor clearColor];
    [self.footView addSubview:titleLa];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.electArray count];
    
}


//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 30;
//    
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UILabel * titleLa = [GPUtils createLable:CGRectMake(0, 10, Main_Screen_Width, 20) text:Custing(@"仅支持百望电子开具的电子发票", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
//    titleLa.backgroundColor = [UIColor clearColor];
//    if (self.electArray.count==0) {
//        titleLa.text = @"";
//    }else{
//        titleLa.text = Custing(@"仅支持百望电子开具的电子发票", nil);
//    }
//    return titleLa;
//    
//}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ElectInvoiceCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ElectInvoiceCell"];
    if (cell==nil) {
        cell=[[ElectInvoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ElectInvoiceCell"];
    }
    NSDictionary * data = self.electArray[indexPath.row];
    if ([[self.electDic objectForKey:@"list"] isEqualToString:@"person"]) {
        [cell configElectListCellTypeSelected:data];
    }else {
        [cell configCompanyElectListCellTypeSelected:data];
    }
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 10, Main_Screen_Width-50, 57)];
    btn.tag = indexPath.row;
    [btn addTarget:self action:@selector(btn_clcik:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];
    return cell;
}

//当前行点击事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i=0; i<self.electArray.count; i++) {
        NSMutableDictionary * cateDic = [NSMutableDictionary dictionaryWithDictionary:self.electArray[i]];
        if (i == indexPath.row) {
            if ([[NSString stringWithFormat:@"%@",cateDic[@"type"]] isEqualToString:@"0"]) {
                cateDic[@"type"] = @"1";
            }else {
                cateDic[@"type"] = @"0";
            }
            [self.electArray replaceObjectAtIndex:indexPath.row withObject:cateDic];
        }
    }
    [self.tableView reloadData];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - action
-(void)btn_clcik:(UIButton *)btn{
    NSLog(@"%ld", (long)btn.tag);
    NSDictionary * data = self.electArray[btn.tag];
    ElectInvoiceInfoViewController *info = [[ElectInvoiceInfoViewController alloc]initWithNibName:@"ElectInvoiceInfoViewController" bundle:nil];
    info.dic = data;
    info.AcctionNo = self.electDic[@"result"][@"accountNo"];
    info.AcctionType = self.electDic[@"result"][@"accountType"];
    [self.navigationController pushViewController:info animated:YES];
}

//导入
-(void)ImportElectInvoice:(UIButton *)btn {
    self.refushStr = @"YES";
    NSMutableArray * arrays = [NSMutableArray array];
    if ([[self.electDic objectForKey:@"list"] isEqualToString:@"person"]) {
        for (int i=0; i<self.electArray.count; i++) {
            NSMutableDictionary * cateDic = [NSMutableDictionary dictionaryWithDictionary:self.electArray[i]];
            if ([[NSString stringWithFormat:@"%@",cateDic[@"type"]] isEqualToString:@"1"]) {
                cateDic = [NSMutableDictionary dictionaryWithDictionary:@{@"fP_DM":cateDic[@"fP_DM"],@"fP_HM":cateDic[@"fP_HM"],@"FPLX":cateDic[@"fplx"],@"GMF_MC":cateDic[@"gmF_MC"],@"JSHJ":cateDic[@"jshj"]}];
                [arrays addObject:cateDic];
            }
        }
        if (arrays.count == 0){
            [[GPAlertView sharedAlertView]showAlertText:self WithText:@"至少选择一条导入" duration:2.0];
            return;
        }
        
        
//        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//        [dict setValue:stri forKey:@"Invoices"];
//        [dict setValue:[self.electDic objectForKey:@"list"] forKey:@"list"];
//        [dict setValue:self.electDic[@"result"] forKey:@"result"];
        
        ImportElInController * import = [[ImportElInController alloc]initWithType:@{@"result":self.electDic[@"result"],@"list":[self.electDic objectForKey:@"list"],@"InvItems":arrays}];
        [self.navigationController pushViewController:import animated:YES];
        
    }else {
        for (int i=0; i<self.electArray.count; i++) {
            NSMutableDictionary * cateDic = [NSMutableDictionary dictionaryWithDictionary:self.electArray[i]];
            if ([[NSString stringWithFormat:@"%@",cateDic[@"type"]] isEqualToString:@"1"]) {
                cateDic = [NSMutableDictionary dictionaryWithDictionary:@{@"bX_RQ":cateDic[@"bX_RQ"],@"bxdh":cateDic[@"bxdh"],@"fP_DM":cateDic[@"fP_DM"],@"fP_HM":cateDic[@"fP_HM"],@"invoicE_AMT":cateDic[@"invoicE_AMT"],@"kprq":cateDic[@"kprq"],@"kpxm":cateDic[@"kpxm"],@"xsF_MC":cateDic[@"xsF_MC"],@"xsF_NSRSBH":cateDic[@"xsF_NSRSBH"]}];
                [arrays addObject:cateDic];
            }
        }
        if (arrays.count == 0){
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"至少选择一条导入", nil) duration:2.0];
            return;
        }
//        NSDictionary *parameters = @{@"ThirdItems":arrays};
//        
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
//        NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
//        
//        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//        [dict setValue:stri forKey:@"Invoices"];
//        [dict setValue:[self.electDic objectForKey:@"list"] forKey:@"list"];
//        [dict setValue:self.electDic[@"result"] forKey:@"result"];
        
        ImportElInController * import = [[ImportElInController alloc]initWithType:@{@"result":self.electDic[@"result"],@"list":[self.electDic objectForKey:@"list"],@"ThirdItems":arrays}];
        [self.navigationController pushViewController:import animated:YES];
    }
    
    
    
}

// 电子发票 》查询用户未报销过的发票列表
-(void)requestGetInvoiceListData {
    if ([[self.electDic objectForKey:@"list"] isEqualToString:@"person"]) {
        NSDictionary * dict = @{@"AccessToken":self.electDic[@"result"][@"accessToken"],@"accountType":self.electDic[@"result"][@"accountType"],@"accountNo":self.electDic[@"result"][@"accountNo"],@"InvoiceTitle":[self.electDic objectForKey:@"InvoiceTitle"],@"StartDate":[self.electDic objectForKey:@"StartDate"],@"EndDate":[self.electDic objectForKey:@"EndDate"]};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"BaiWang/GetInvoiceList"] Parameters:dict Delegate:self SerialNum:5 IfUserCache:NO];
    }else {
        
        NSDictionary * dic = @{@"AccessToken":self.electDic[@"result"][@"accessToken"],@"ClientId":self.electDic[@"result"][@"clientId"],@"SPSQM":self.electDic[@"result"][@"spsqm"],@"StartDate":[self.electDic objectForKey:@"StartDate"],@"EndDate":[self.electDic objectForKey:@"EndDate"],@"PageIndex":@"1",@"PageSize":@"1000",@"OrderBy":@"",@"IsAsc":@""};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"BaiWang/GetInfoByThirds"] Parameters:dic Delegate:self SerialNum:5 IfUserCache:NO];
    }
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}


- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"resDic:%@",responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    
    
    if (serialNum ==5) {
        if ([[self.electDic objectForKey:@"list"] isEqualToString:@"person"]) {
            NSArray * items = [responceDic objectForKey:@"result"];
            self.electArray = [NSMutableArray arrayWithArray:items];
            if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
                
                for (int i=0; i<self.electArray.count; i++) {
                    NSMutableDictionary * cateDic = [NSMutableDictionary dictionaryWithDictionary:self.electArray[i]];
                    cateDic[@"type"] = @"0";
                    [self.electArray replaceObjectAtIndex:i withObject:cateDic];
                }
                
            }else {
                [self createNOdataView];
            }
        }else {
            NSDictionary * result = [responceDic objectForKey:@"result"];
            if (![result isKindOfClass:[NSNull class]] && result != nil && result.count != 0){
                
                NSArray * items = [result objectForKey:@"items"];
                self.electArray = [NSMutableArray arrayWithArray:items];
                if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
                    
                    for (int i=0; i<self.electArray.count; i++) {
                        NSMutableDictionary * cateDic = [NSMutableDictionary dictionaryWithDictionary:self.electArray[i]];
                        cateDic[@"type"] = @"0";
                        [self.electArray replaceObjectAtIndex:i withObject:cateDic];
                    }
                    
                }else {
                    [self createNOdataView];

                }
                
            }
        }
        [self.tableView reloadData];
    }
    
    switch (serialNum) {
        case 0://
        
            break;
            
            
        default:
            break;
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

//MARK:创建无数据视图
-(void)createNOdataView{
    if (self.electArray.count==0) {
        self.self.importBtn.hidden = YES;
    }else{
        self.self.importBtn.hidden = NO;
    }
    [_tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有电子发票哦", nil) hasData:(self.electArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
