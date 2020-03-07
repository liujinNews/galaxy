//
//  AttendAnceManageViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/17.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AttendAnceManageViewController.h"
#import "AttendanceAddViewController.h"

@interface AttendAnceManageViewController ()<UITableViewDelegate, UITableViewDataSource,GPClientDelegate>

@property (nonatomic, strong) NSDictionary *dic_request;
@property (nonatomic, strong) NSMutableArray *muarr_Show;
@property (nonatomic, strong) UIButton *btn_content;

@end

@implementation AttendAnceManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_White_Same_20;
    [self setTitle:Custing(@"考勤管理", nil) backButton:YES];
    [self createNavRightBtn];
    [self initializeData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self requestAttendanceGetAttendances];
}

#pragma mark - function
- (void)initializeData{
    _dic_request = [NSDictionary dictionary];
    _muarr_Show  = [NSMutableArray array];
}

- (void)analysisRequestData{
    if ([_dic_request[@"result"] isKindOfClass:[NSArray class]]) {
        _muarr_Show = _dic_request[@"result"];
    }
}

-(void)createNavRightBtn{
    UIButton *rigbtn = [UIButton new];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:rigbtn title:nil titleColor:nil titleIndex:0 imageName:@"Attendance_Add" target:self action:@selector(rightbtn)];
}

- (void)createView{
    UITableView *tbv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height) style:UITableViewStylePlain];
    tbv.backgroundColor = Color_White_Same_20;
    tbv.delegate = self;
    tbv.dataSource = self;
    tbv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tbv];
    [tbv mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    if (_muarr_Show.count==0) {
        NSString *str_title = Custing(@"暂无考勤规则，", nil);
        NSString *str_content = Custing(@"请添加", nil);
        NSMutableAttributedString *attriString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str_title,str_content]];
        [attriString1 addAttribute:NSForegroundColorAttributeName value:Color_Blue_Important_20 range:NSMakeRange(str_title.length, str_content.length)];
        [attriString1 addAttribute:NSForegroundColorAttributeName value:Color_GrayDark_Same_20 range:NSMakeRange(0, str_title.length)];
        _btn_content = [GPUtils createButton:CGRectMake(0, 30, Main_Screen_Width, 30) action:nil delegate:nil title:@"" font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
        [_btn_content.titleLabel setAttributedText:attriString1];
        [_btn_content setAttributedTitle:attriString1 forState:UIControlStateNormal];
        [self.view addSubview:_btn_content];
        __weak typeof(self) weakSelf = self;
        [_btn_content bk_whenTapped:^{
            AttendanceAddViewController *add = [[AttendanceAddViewController alloc]init];
            [weakSelf.navigationController pushViewController:add animated:YES];
        }];
    }else{
        [_btn_content removeFromSuperview];
    }
}

-(void)requestAttendanceGetAttendances{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",AttendanceGetAttendances];
    NSDictionary *parameters = @{};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

-(void)requestAttendanceDeleteAttendance:(NSString *)Id{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",AttendanceDeleteAttendance];
    NSDictionary *parameters = @{@"Id":Id};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}


#pragma mark - action
-(void)rightbtn{
    AttendanceAddViewController *add = [[AttendanceAddViewController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
}

#pragma mark - Delegate
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    if ([responceDic[@"success"] intValue] == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString isEqualToNull:error]?error:Custing(@"网络请求失败", nil) duration:1.0];
        return;
    }
    if (serialNum == 0) {
        _dic_request = responceDic;
        [self analysisRequestData];
        [self createView];
    }
    if (serialNum == 1) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:1.5];
        [self performBlock:^{
            [self requestAttendanceGetAttendances];
        } afterDelay:1.5];
    }
}

//请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDictionary *dic = _muarr_Show[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.backgroundColor = Color_White_Same_20;
    NSArray *arr = dic[@"attendanceAddrs"];
    UIView *view= [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, arr.count>1?130 + arr.count*30:160)];
    view.backgroundColor = Color_form_TextFieldBackgroundColor;
    
    UILabel *lab_title = [GPUtils createLable:CGRectMake(12, 5, Main_Screen_Width-24, 35) text:[NSString stringWithIdOnNO:dic[@"name"]] font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    [view addSubview:lab_title];
    
    UIImageView *img_Date = [GPUtils createImageViewFrame:CGRectMake(12, 39, 18, 23) imageName:@"Attendance_Icon"];
    [view addSubview:img_Date];
    UILabel *lab_Date = [GPUtils createLable:CGRectMake(48, 35, Main_Screen_Width-60, 30) text:[NSString setDateListReturnString:[NSMutableArray arrayWithArray:[[NSString stringWithIdOnNO:dic[@"signDate"]] componentsSeparatedByString:@","]]] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [view addSubview:lab_Date];
    
    UIImageView *img_Time = [GPUtils createImageViewFrame:CGRectMake(12, 69, 18, 23) imageName:@"Attendance_Date"];
    [view addSubview:img_Time];
    UILabel *lab_Time = [GPUtils createLable:CGRectMake(48, 65, Main_Screen_Width-60, 30) text:[NSString stringWithFormat:@"%@-%@",dic[@"fromTime"],dic[@"toTime"]] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [view addSubview:lab_Time];
    
    UIImageView *img_Type = [GPUtils createImageViewFrame:CGRectMake(12, 99, 18, 23) imageName:@"Attendance_Type"];
    [view addSubview:img_Type];
    UILabel *lab_Type = [GPUtils createLable:CGRectMake(48, 95, Main_Screen_Width-60, 30) text:[[NSString stringWithFormat:@"%@",dic[@"type"]]isEqualToString:@"1"] ? [NSString stringWithFormat:@"%@%@%@",Custing(@"每月", nil),dic[@"fromDate"],Custing(@"号", nil)]:Custing(@"自然月", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [view addSubview:lab_Type];
    
    UIImageView *img_Address = [GPUtils createImageViewFrame:CGRectMake(12, 129, 18, 23) imageName:@"Attendance_location"];
    [view addSubview:img_Address];
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *dica = arr[i];
        UILabel *lab_Address = [GPUtils createLable:CGRectMake(48, 125+i*30, Main_Screen_Width-60, 30) text:dica[@"address"] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [view addSubview:lab_Address];
    }
    
    [cell addSubview:view];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _muarr_Show.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _muarr_Show[indexPath.row];
    NSArray *arr = dic[@"attendanceAddrs"];
    return arr.count>1?140 + arr.count*30:170;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _muarr_Show[indexPath.row];
    AttendanceAddViewController *add = [[AttendanceAddViewController alloc]init];
    add.dic = dic;
    [self.navigationController pushViewController:add animated:YES];
}

//是否可编辑
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _muarr_Show[indexPath.row];
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"删除", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [weakSelf requestAttendanceDeleteAttendance:dic[@"id"]];
    }];
    return @[deleteRowAction];
}
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(editingStyle ==UITableViewCellEditingStyleDelete) {
        
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
