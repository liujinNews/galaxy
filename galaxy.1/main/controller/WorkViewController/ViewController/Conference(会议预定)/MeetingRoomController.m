//
//  MeetingRoomController.m
//  galaxy
//
//  Created by hfk on 2017/12/21.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "MeetingRoomController.h"

@interface MeetingRoomController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *dict_resultDict;
@property (nonatomic,strong)NSMutableArray *arr_MeetingRoom;
@property (nonatomic,strong)MeetingRoomCell *cell;
@property (nonatomic, strong) UIView *View_ChooseDate;
@property (nonatomic, strong) UITextField *txf_ChooseDate;
@property (nonatomic, strong) NSString  *str_ChooseDate;
/**
 *  主视图tableView
 */
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation MeetingRoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    [self setTitle:Custing(@"选择会议室", nil) backButton:YES];
    [self createChooseDateView];
    [self createTableView];
    _arr_MeetingRoom=[NSMutableArray array];
    [self requestMeetingRoom];
}

-(void)createChooseDateView{
    _View_ChooseDate=[[UIView alloc]init];
    _View_ChooseDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view addSubview:_View_ChooseDate];
    [_View_ChooseDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
    }];
    
    _txf_ChooseDate=[[UITextField alloc]init];

    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=nil;
    NSDate *pickerDate = [NSDate date];
    NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
    pickerFormatter.timeZone = [NSTimeZone localTimeZone];
    [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *currStr= [pickerFormatter stringFromDate:pickerDate];
    model.fieldValue=currStr;
    _str_ChooseDate=currStr;
    
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ChooseDate WithContent:_txf_ChooseDate WithFormType:formViewSelectDate WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
    view.txfield_content.frame=CGRectMake(12, 0, Main_Screen_Width-12-50, 50);
    view.lab_title.hidden=YES;
    view.img_des.hidden=YES;
    view.selectBtn.frame=CGRectMake(0, 0, Main_Screen_Width-60, 50);
    __weak typeof(self) weakSelf = self;
    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
        weakSelf.str_ChooseDate = selectTime;
        [weakSelf requestMeetingRoom];
    }];
    [_View_ChooseDate addSubview:view];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width-51.5, 17, 0.5, 16)];
    line.backgroundColor=Color_GrayLight_Same_20;
    [view addSubview:line];
    
    UIButton *btn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 50, 50) action:@selector(beginSearch:) delegate:self title:Custing(@"搜索", nil) font:Font_Important_15_20 titleColor:Color_form_TextField_20];
    [view addSubview:btn];
    
}
-(void)beginSearch:(UIButton *)btn{
    NSLog(@"搜索");
    [self requestMeetingRoom];
}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor=Color_White_Same_20;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(@50);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

}
//MARK:获取审批记录
-(void)requestMeetingRoom{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",MEETINGROOMList];
    NSDictionary *parameters=@{@"StartTime":self.str_ChooseDate,@"EndTime":self.str_ChooseDate};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
    
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    _dict_resultDict=responceDic;
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
            [_arr_MeetingRoom removeAllObjects];
            [MeetingRoomModel getMeetRoomDateWithDict:_dict_resultDict withResult:_arr_MeetingRoom];
            [_tableView reloadData];
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


//MARK:tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.arr_MeetingRoom.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MeetingRoomCell cellHeightWithObj:self.arr_MeetingRoom[indexPath.section]];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]init];
    view.frame=CGRectMake(0, 0, Main_Screen_Width,10);
    view.backgroundColor=Color_White_Same_20;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"MeetingRoomCell"];
    if (_cell==nil) {
        _cell=[[MeetingRoomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MeetingRoomCell"];
    }
    if (_arr_MeetingRoom.count>0) {
        MeetingRoomModel *model=_arr_MeetingRoom[indexPath.section];
        [_cell configCellWithData:model];
    }
    return _cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_arr_MeetingRoom.count>0) {
        MeetingRoomModel *model=_arr_MeetingRoom[indexPath.section];
        MeetingRoomSureController *vc=[[MeetingRoomSureController alloc]init];
        vc.model=model;
        vc.str_date=_str_ChooseDate;
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
