//
//  positionDisignViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/4/28.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#define pageNum  (Main_Screen_Height-49)/49
#import "editPositionData.h"
#import "editPositionCell.h"
#import "infoViewController.h"
#import "addPositionViewController.h"


#import "positionDisignViewController.h"
#import "InstructionsViewController.h"
@interface positionDisignViewController ()<GPClientDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSString * returnStr;
@property (nonatomic,strong)NSString * recordcount;
@property (assign, nonatomic)NSInteger totalPages;
@property (nonatomic,strong)UIView * noDataView;//无数据视图
@property (nonatomic,strong)UIButton * addCVBtn;
@property (nonatomic,strong)NSString * status;

@end

@implementation positionDisignViewController
-(id)initWithType:(NSString *)type
{
    self=[super init];
    if (self) {
        self.status = type;
    }
    return self;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    if ([self.returnStr isEqualToString:@"bouu"]) {
        self.currPage = 1;
        [self requestEditPositionData:self.currPage];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAddCostDock];
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);

    }];
    self.currPage =1;
    NSString * titleStr;
    if ([self.status isEqualToString:@"position"]) {
        titleStr = Custing(@"设置员工职位", nil);
    }else{
        titleStr = Custing(@"设置员工级别", nil);
    }
    [self setTitle:titleStr backButton:YES WithTitleImg:@"my_positionQ"];
}

-(void)ImageClicked:(id)obj{
    NSString * typeStr;
    if ([self.status isEqualToString:@"position"]) {
        typeStr = @"editPositionInfo";
    }else{
        typeStr = @"editLeavelInfo";
    }
    InstructionsViewController * INFO = [[InstructionsViewController alloc]initWithType:typeStr];
    [self.navigationController pushViewController:INFO animated:YES];
}

//添加员工职位
-(void)createAddCostDock{
    
    self.addCVBtn = [GPUtils createButton:CGRectMake(0,ScreenRect.size.height - 49 - NavigationbarHeight, ScreenRect.size.width, 49) action:@selector(addCostCenterData:) delegate:self title:Custing(@"添加", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    self.addCVBtn.backgroundColor =Color_Blue_Important_20;
    [self.view addSubview:self.addCVBtn];
    
}
-(void)addCostCenterData:(UIButton *)btn{
    self.returnStr = @"bouu";
    NSString * str;
    if ([self.status isEqualToString:@"position"]) {
        str = @"addPosition";
    }else{
        str = @"addLeavel";
    }
    addPositionViewController * reimburs = [[addPositionViewController alloc]initWithType:nil Name:str];
    [self.navigationController pushViewController:reimburs animated:YES];
}
//MARK:tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.status isEqualToString:@"position"]) {
        return 1;
    }else{
        if (self.resultArray&&self.resultArray.count>0) {
            return self.resultArray.count;
        }
        else
        {
            return 0;
        }
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.status isEqualToString:@"position"]) {
        return self.resultArray.count;
    }else{
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.status isEqualToString:@"position"]) {
        if (section!=0) {
            return 10;
        }else{
            return 0.01;
        }
    }else{
        if (section!=0) {
            return 8;
        }else{
            return 12;
        }
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=Color_White_Same_20;
    view.frame=CGRectMake(0, 0, Main_Screen_Width, 10);
    return view;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    editPositionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"editPositionCell"];
    if (cell==nil) {
        cell=[[editPositionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"editPositionCell"];
    }
    if ([self.status isEqualToString:@"position"]) {
        editPositionData *cellInfo = self.resultArray[indexPath.row];
        [cell configEditPositionCellInfo:cellInfo];
        if (indexPath.row==self.resultArray.count-1) {
            cell.line.hidden = YES;
        }
    }else{
        editPositionData *cellInfo = self.resultArray[indexPath.section];
        [cell configEditUserLevelCellInfo:cellInfo];
    }
    
    return cell;
}
//单行点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    self.returnStr = @"bouu";
    NSDictionary *parameters;
    if ([self.status isEqualToString:@"position"]) {
        editPositionData *cellInfo = self.resultArray[indexPath.row];
        parameters = @{@"id":cellInfo.idd,@"jobTitle":cellInfo.jobTitle,@"creater":cellInfo.creater,@"jobTitleCode":cellInfo.jobTitleCode,@"jobTitleEn":cellInfo.jobTitleEn};
        addPositionViewController * reimburs = [[addPositionViewController alloc]initWithType:parameters Name:@"editPosition"];
        [self.navigationController pushViewController:reimburs animated:YES];
    }else{
        editPositionData *cellInfo = self.resultArray[indexPath.section];
        parameters =@{@"active":[NSString stringWithFormat:@"%@",cellInfo.active],@"companyId":[NSString stringWithFormat:@"%@",cellInfo.companyId],@"createTime":[NSString stringWithFormat:@"%@",cellInfo.createTime],@"creater":[NSString stringWithFormat:@"%@",cellInfo.creater],@"description":[NSString stringWithFormat:@"%@",cellInfo.descriptino],@"id":[NSString stringWithFormat:@"%@",cellInfo.idd],@"total":[NSString stringWithFormat:@"%@",cellInfo.total],@"updateTime":[NSString stringWithFormat:@"%@",cellInfo.updateTime],@"updater":[NSString stringWithFormat:@"%@",cellInfo.updater],@"userLevel":[NSString stringWithFormat:@"%@",cellInfo.userLevel],@"userLevelEn":[NSString stringWithFormat:@"%@",cellInfo.userLevelEn],@"userLevelNo":[NSString stringWithFormat:@"%@",cellInfo.userLevelNo]};
        addPositionViewController * reimburs = [[addPositionViewController alloc]initWithType:parameters Name:@"editLevel"];
        [self.navigationController pushViewController:reimburs animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self.status isEqualToString:@"position"]) {
            editPositionData *data= self.resultArray[indexPath.row];
            [self deleteEditPositionList:data];
        }else{
            editPositionData *data= self.resultArray[indexPath.section];
            [self deleteEditPositionList:data];
        }
        
    }
}


-(void)loadData{
    
    [self requestEditPositionData:self.currPage];
}

//员工职位列表、级别
-(void)requestEditPositionData:(NSInteger)page {
    //修改下载的状态
    self.isLoading = YES;
    NSDictionary * dic;
    if ([self.status isEqualToString:@"position"]) {
        dic = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)page],@"PageSize":[NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"id",@"IsAsc":@"desc"};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getjobtitles] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    }else{
        dic = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)page],@"PageSize":[NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"id",@"IsAsc":@"desc"};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getuserlevels] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    }
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

//删除员工职位、级别
-(void)deleteEditPositionList:(editPositionData*)data
{
    //修改下载的状态
    self.isLoading = YES;
    NSDictionary * dic;
    if ([self.status isEqualToString:@"position"]) {
        dic = @{@"id":[NSString stringWithFormat:@"%@",data.idd],@"jobTitle":[NSString stringWithFormat:@"%@",data.jobTitle],@"creater":[NSString stringWithFormat:@"%@",data.creater],@"jobTitleCode":[NSString stringWithFormat:@"%@",data.jobTitleCode],@"jobTitleEn":[NSString stringWithFormat:@"%@",data.jobTitleEn]};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@", deletejobtitle] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
    }else{
        //dic = @{@"id":[NSString stringWithFormat:@"%@",data.idd],@"userLevel":[NSString stringWithFormat:@"%@",data.userLevel],@"creater":[NSString stringWithFormat:@"%@",data.creater],@"description":[NSString stringWithFormat:@"%@",data.descriptino],@"userLevelEn":[NSString stringWithFormat:@"%@",data.userLevelEn]};
        dic =@{@"active":[NSString stringWithFormat:@"%@",data.active],@"companyId":[NSString stringWithFormat:@"%@",data.companyId],@"createTime":[NSString stringWithFormat:@"%@",data.createTime],@"creater":[NSString stringWithFormat:@"%@",data.creater],@"description":[NSString stringWithFormat:@"%@",data.descriptino],@"id":[NSString stringWithFormat:@"%@",data.idd],@"total":[NSString stringWithFormat:@"%@",data.total],@"updateTime":[NSString stringWithFormat:@"%@",data.updateTime],@"updater":[NSString stringWithFormat:@"%@",data.updater],@"userLevel":[NSString stringWithFormat:@"%@",data.userLevel],@"userLevelEn":[NSString stringWithFormat:@"%@",data.userLevelEn]};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@", deleteuserlevel] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
    }
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        if (serialNum ==1&&[self.status isEqualToString:@"position"]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"此职位有员工，无法删除", nil) duration:2.0];
        }else{
            NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        }
        
        return;
    }
    if (serialNum ==0) {
        NSDictionary *result = [responceDic objectForKey:@"result"];
        self.recordcount = [NSString stringWithFormat:@"%@",[result objectForKey:@"recordcount"]];
        self.totalPages = [[result objectForKey:@"totalPages"] integerValue];
        
    }
    
    //下拉刷新
    if (self.currPage == 1&&self.isLoading) {
        [self.resultArray removeAllObjects];
    }
    switch (serialNum) {
        case 0:
            
            if (self.currPage==1) {
                [self.resultArray removeAllObjects];
            }
            if (self.totalPages >= self.currPage) {
                if ([self.status isEqualToString:@"position"]) {
                    [editPositionData GetEditPositionListDictionary:responceDic Array:self.resultArray];
                }else{
                    [editPositionData GetEditUserLevealDictionary:responceDic Array:self.resultArray];
                }
            }
            [self createNOdataView];
            break;
        case 1:
            [self requestEditPositionData:1];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:2.0];
            break;
            
        default:
            break;
    }
    

    //修改下载的状态
    self.isLoading = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];

    
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];

    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}

//MARK:创建无数据视图
-(void)createNOdataView{
    NSString *tips;
    if ([self.status isEqualToString:@"position"]) {
        tips = Custing(@"您还没添加员工职位哦", nil);
    }else{
        tips = Custing(@"您还没添加级别哦", nil);
    }
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:tips hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
