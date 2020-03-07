//
//  WorkViewController.m
//  galaxy
//
//  Created by hfk on 16/4/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "WorkViewController.h"
#import "PerformanceTypeController.h"
static NSString *const CellIdentifier = @"WorkCateCell";
static NSString *const HeadViewIdentifier = @"MyCollectionHeadView";

@interface WorkViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,GPClientDelegate>

@end

@implementation WorkViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=Color_White_Same_20;
    [self setTitle:Custing(@"工作", nil)];
    [self createCollectView];
    self.WorkShowArray = [NSMutableArray arrayWithArray:@[Custing(@"审批", nil),Custing(@"工作", nil),Custing(@"应用", nil)]];
    self.WorkShowDataArray = [NSMutableArray array];
    _requestType = @"1";
    [self requestNum];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![_requestType isEqualToString:@"1"]) {
        if ([NSString isEqualToNull:self.userdatas.work_waitNum]&&[self.WorkShowArray containsObject:Custing(@"审批", nil)]&&self.WorkShowDataArray.count>0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [_collView reloadItemsAtIndexPaths:@[indexPath]];
        }
        [self requestNum];
    }
}
//MARK:创建表格视图
-(void)createCollectView{
    _layOut = [[UICollectionViewFlowLayout alloc] init];
    _layOut.minimumInteritemSpacing = 0;
    _layOut.minimumLineSpacing = 0;
    
    _collView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layOut];
    _collView.delegate = self;
    _collView.dataSource = self;
    _collView.alwaysBounceVertical=YES;
    _collView.showsVerticalScrollIndicator = NO;
    _collView.backgroundColor =Color_White_Same_20;
    [_collView registerClass:[WorkCateCell class] forCellWithReuseIdentifier:CellIdentifier];
    [_collView registerClass:[MyCollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadViewIdentifier];
    [self.view addSubview:_collView];
    [_collView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view).offset(iPhoneX ? @-83:@ -49);
    }];
}
//MARK:网络部分
//MARK:获取单据数量Work
-(void)requestNum{
    NSString *url=[NSString stringWithFormat:@"%@",WorkapprovalGetNum];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:获取微应用列表
-(void)getMicroApp{
    NSString *url=[NSString stringWithFormat:@"%@",MicroAppGet];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
//        [YXSpritesLoadingView dismiss];
//        return;
    }
    switch (serialNum) {
        case 0://待审批数量
        {
            self.userdatas.work_waitNum=[NSString stringWithFormat:@"%@",_resultDict[@"result"][@"myToDoNum"]];
            if (![_requestType isEqualToString:@"1"]&&[NSString isEqualToNull:self.userdatas.work_waitNum]&&[self.WorkShowArray containsObject:Custing(@"审批", nil)]&&self.WorkShowDataArray.count>0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [_collView reloadItemsAtIndexPaths:@[indexPath]];
            }
            if ([_requestType isEqualToString:@"1"]) {
                [self getMicroApp];
            }
            _requestType=@"0";
        }
            break;
        case 1:
        {
            [WorkShowModel getWorkPartDataByDictionary:responceDic Array:self.WorkShowDataArray WithPartArray:self.WorkShowArray];
            [_collView reloadData];
            [self createGuideViews];
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

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size=CGSizeZero;
    if (self.WorkShowDataArray.count>0) {
        WorkShowModel *model=self.WorkShowDataArray[indexPath.section][indexPath.row];
        size=[WorkCateCell ccellSizeWithObj:model];
    }
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark 设置头部视图的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size=CGSizeZero;
    if (self.WorkShowArray>0) {
        NSString *title=self.WorkShowArray[section];
        if ([title isEqualToString:Custing(@"工作", nil)]) {
            size=CGSizeMake(Main_Screen_Width, 0.5);
        }else{
            size=CGSizeMake(Main_Screen_Width, 27);
        }
    }
    return size;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        MyCollectionHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadViewIdentifier forIndexPath:indexPath];
        if (self.WorkShowArray>0) {
            NSString *title=self.WorkShowArray[indexPath.section];
            [headView configHeadViewWithTitle:title];
        }
        return headView;
    }else{
        return [[UICollectionReusableView alloc]init];
    }
}


#pragma mark - CollectionView Delegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.WorkShowDataArray.count>0) {
        return self.WorkShowDataArray.count;
    }else{
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.WorkShowDataArray.count>0) {
        NSMutableArray *arr=self.WorkShowDataArray[section];
        return arr.count;
    }else{
        return 0;
    }
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (self.WorkShowDataArray.count>0) {
        [_cell configCcellWithArrat:self.WorkShowDataArray WithindexPath:indexPath];
    }
    return _cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WorkShowModel *model = self.WorkShowDataArray[indexPath.section][indexPath.row];
    if (model.appType==1) {
        if ([model.appName isEqualToString:Custing(@"我的审批", nil)]) {
            if (self.userdatas.SystemType==1 && self.userdatas.bool_AgentHasApprove == NO) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"您没有审批权限哦", nil) duration:1.5];
                return;
            }else{
                //我的审批
                MyApproveViewController * approval = [[MyApproveViewController alloc]initWithType:@"0"];
                [self.navigationController pushViewController:approval animated:YES];
            }
        }else if ([model.appName isEqualToString:Custing(@"我的申请",nil)]){
            //我的申请
            MyApplyViewController * myV = [[MyApplyViewController alloc]initWithType:@"1"];
            [self.navigationController pushViewController:myV animated:YES];
        }
    }else if (model.appType==2){
        if ([[VoiceDataManger sharedManager]isH5FlowFormWithFlowCode:model.appFlowCode]) {
            NSString *pushController = [[VoiceDataManger sharedManager]getControllerNameWithFlowCode:model.appFlowCode][@"pushController"];
            
            NSDictionary *flowName = [VoiceDataManger getFlowShowInfo:model.appFlowGuid][@"Title"];
            NSDictionary *dict1 = @{@"flowGuid":model.appFlowGuid,@"taskId":@"",@"procId":@"",@"token":self.userdatas.token,@"flowName":flowName,@"userId":self.userdatas.userId,@"pageType":@1};
            
            RootFlowWebViewController *vc = [[RootFlowWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@%@%@",[UrlKeyManager getFormH5URL:XB_FormH5New],pushController,[[NSString transformToJsonWithOutEnter:dict1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
            vc.str_flowCode = model.appFlowCode;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.appFlowCode isEqualToString:@"F0022"]) {
            PerformanceTypeController *vc = [[PerformanceTypeController alloc]init];
            vc.flowGuid = model.appFlowGuid;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSString *pushController = [[VoiceDataManger sharedManager]getControllerNameWithFlowCode:model.appFlowCode][@"pushController"];
            Class cls = NSClassFromString(pushController);
            UIViewController *vc = [[cls alloc] init];
            vc.pushFlowGuid = model.appFlowGuid;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (model.appType==3){
        if (self.userdatas.SystemType==1) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"代理模式不可进入", nil) duration:1.5];
            return;
        }else{
            if ([model.appFlowCode isEqualToString:@"Report"]) {
                ReportFormMainController * personnal = [[ReportFormMainController alloc]init];
                [self.navigationController pushViewController:personnal animated:YES];
            }else if ([model.appFlowCode isEqualToString:@"Pay"]){
                PayMentApproveController *pay=[[PayMentApproveController alloc]init];
                [self.navigationController pushViewController:pay animated:YES];
            }else if ([model.appFlowCode isEqualToString:@"CashAdvance"]){
                BorrowRecordViewController * borrow = [[BorrowRecordViewController alloc]init];
                [self.navigationController pushViewController: borrow animated:YES];
            }else if ([model.appFlowCode isEqualToString:@"InvoiceMgr"]){
                InvoiceManagerController *vc=[[InvoiceManagerController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([model.appFlowCode isEqualToString:@"Attendance"]){
                AttendanceViewController *vc=[[AttendanceViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([model.appFlowCode isEqualToString:@"Schedule"]){
                CalendarMainController *vc=[[CalendarMainController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([model.appFlowCode isEqualToString:@"Announcement"]){
                AnnouncementListController *vc=[[AnnouncementListController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else if (model.appType==4){
        if ([NSString isEqualToNull:model.appUrl]) {
            MicroAppViewController * MicroApp = [[MicroAppViewController alloc]init];
            MicroApp.JumpModel=model;
            MicroApp.isClick=YES;
            [self.navigationController pushViewController:MicroApp animated:YES];
        }
    }
}


//MARK:创建节假日判断
-(void)createGuideViews{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"WorkGuide"]isEqualToString:@"1"]) {
        //        [self createNewView];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"WorkGuide"];
    }
}

//MARK:节假日导航页
-(void)createNewView{
    _GuideView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    _GuideView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.6];
    _GuideView.userInteractionEnabled=YES;
    
    UIWindow *window=[[[UIApplication sharedApplication] delegate]window];
    [window addSubview:_GuideView];
    
    UIImageView *guide=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,80,80)];
    guide.center=CGPointMake(Main_Screen_Width/4, NavigationbarHeight+27+Main_Screen_Width*0.36/2);
    guide.image=[UIImage imageNamed:@"Work_guideImage"];
    [_GuideView addSubview:guide];
    
    
    UIImageView *guide2=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,160,110)];
    guide2.center=CGPointMake(Main_Screen_Width/4+55, NavigationbarHeight+122+Main_Screen_Width*0.36/2);
    guide2.image=[UIImage imageNamed:@"Work_guideTitle"];
    [_GuideView addSubview:guide2];
    
    
    UIImageView *fork=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,127,67)];
    fork.center=CGPointMake(Main_Screen_Width/2, Main_Screen_Height/2+Main_Screen_Width/2);
    fork.image=[UIImage imageNamed:@"Work_guideKnow"];
    [_GuideView addSubview:fork];
    
    UIButton *btn=[GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 40) action:@selector(tapFestival:) delegate:self];
    btn.center=CGPointMake(Main_Screen_Width/2, Main_Screen_Height/2+Main_Screen_Width/2);
    [_GuideView addSubview:btn];
}
-(void)tapFestival:(UIButton *)btn{
    [_GuideView removeFromSuperview];
    _GuideView=nil;
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

