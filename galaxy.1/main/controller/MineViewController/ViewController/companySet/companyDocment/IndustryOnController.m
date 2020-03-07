//
//  IndustryOnController.m
//  galaxy
//
//  Created by 赵碚 on 15/12/23.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "editCompanyData.h"
#import "editCompanyCell.h"
#import "IndustryOnController.h"

@interface IndustryOnController ()<UITableViewDataSource,UITableViewDelegate,ByvalDelegate,GPClientDelegate>
@property(nonatomic,strong)UITableView *tableView;//主界面tableView

@property (nonatomic,strong)NSString * status;
@property (nonatomic,strong)NSMutableArray * companyInfo;
@property (nonatomic,strong)NSMutableArray * locationInfo;
@property (nonatomic,strong)NSMutableArray * industryInfo;
@property (nonatomic,strong)NSMutableArray * coScaleInfo;


@end

@implementation IndustryOnController
-(id)initWithType:(NSString *)type{
    self = [super init];
    if (self) {
        self.status = type;
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.status isEqualToString:@"location"]) {
        [self setTitle:Custing(@"选择地区", nil) backButton:YES ];
    }
    if ([self.status isEqualToString:@"industry"]) {
      [self setTitle:Custing(@"选择行业", nil) backButton:YES ];
    }
    if ([self.status isEqualToString:@"companySize"]) {
        [self setTitle:Custing(@"选择公司规模", nil) backButton:YES ];
    }
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self RequestIndustryInfo];

    // Do any additional setup after loading the view.
}

-(void)back:(UIButton *)btn{
    [YXSpritesLoadingView dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.status isEqualToString:@"industry"]) {
        return self.industryInfo.count;
    }else
    if ([self.status isEqualToString:@"location"]) {
        return self.locationInfo.count;
    }
    else{
        return self.coScaleInfo.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.status isEqualToString:@"industry"]) {
        editCompanyData *cellInfo = self.industryInfo[indexPath.row];
        if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.industry]]) {
            CGSize size = [cellInfo.industry sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-50, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
            return 30+size.height;
        }else{
            return 49;
        }
        
    }
    else if ([self.status isEqualToString:@"location"]){
        editCompanyData *cellInfo = self.locationInfo[indexPath.row];
        if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.provinceName]]) {
            CGSize size = [cellInfo.provinceName sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-50, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
            return 30+size.height;
        }else{
            return 49;
        }
    }
    else{
        editCompanyData *cellInfo = self.companyInfo[indexPath.row];
        if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.scale]]) {
            CGSize size = [cellInfo.scale sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-50, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
            return 30+size.height;
        }else{
            return 49;
        }
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    editCompanyCell *cell=[tableView dequeueReusableCellWithIdentifier:@"editCompanyCell"];
    if (cell==nil) {
        cell=[[editCompanyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"editCompanyCell"];
    }
    
    if ([self.status isEqualToString:@"industry"]) {
        editCompanyData *cellInfo = self.industryInfo[indexPath.row];
        [cell configIndustryViewWithCellInfo:cellInfo sting:self.dataStr];
        
    }
    else if ([self.status isEqualToString:@"location"]){
        editCompanyData *cellInfo = self.locationInfo[indexPath.row];
        [cell configLocationViewWithCellInfo:cellInfo sting:self.dataStr];
        
    }
    else{
        editCompanyData *cellInfo = self.coScaleInfo[indexPath.row];
        [cell configCoscaleViewWithCellInfo:cellInfo sting:self.dataStr];
        
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.status isEqualToString:@"industry"]) {
        editCompanyData *cellInfo = self.industryInfo[indexPath.row];
        self.cuanDic =@{@"id":cellInfo.industryid,@"industry":cellInfo.industry};
    }
    else if ([self.status isEqualToString:@"location"]){
        editCompanyData *cellInfo = self.locationInfo[indexPath.row];
        self.cuanDic =@{@"id":cellInfo.provinceCode,@"location":cellInfo.provinceName};
    }
    else{
        editCompanyData *cellInfo = self.coScaleInfo[indexPath.row];
        self.cuanDic = @{@"id":cellInfo.coid,@"scale":cellInfo.scale};
    }
    [self.delegate companyIndustryClickedLoadBtn:self.cuanDic type:self.status];
    [self.navigationController popViewControllerAnimated:YES];
    
}


//获取我的企业表单数据
-(void)RequestIndustryInfo{
    
    [[GPClient shareGPClient]RequestByGetWithPath:[NSString stringWithFormat:@"%@",getcompanyget] Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    
    switch (serialNum) {
        case 0://
            self.locationInfo = [NSMutableArray array];
            self.industryInfo = [NSMutableArray array];
            self.coScaleInfo  = [NSMutableArray array];
            [editCompanyData GeteditCompanyDictionary:responceDic Array:self.companyInfo Array:self.locationInfo Array:self.industryInfo Array:self.coScaleInfo];
            [self.tableView reloadData];
            break;
        default:
            break;
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
