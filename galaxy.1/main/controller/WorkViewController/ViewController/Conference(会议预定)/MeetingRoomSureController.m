//
//  MeetingRoomSureController.m
//  galaxy
//
//  Created by hfk on 2017/12/22.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "MeetingRoomSureController.h"
@interface MeetingRoomSureController ()
@property (nonatomic,strong)UITextField *txf_start;
@property (nonatomic,strong)UITextField *txf_end;
@property (nonatomic,strong)NSString *str_startTime;
@property (nonatomic,strong)NSString *str_endTime;

@end

@implementation MeetingRoomSureController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"预订会议室", nil) backButton:YES];
    self.view.backgroundColor=Color_White_Same_20;
    [self createSure];
    [self createView];

}
-(void)createSure{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"确定", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Color_Blue_Important_20 titleIndex:0 imageName:nil target:self action:@selector(Sure:)];
}
-(void)createView{
    
    UIView *View_Name=[[UIView alloc]init];
    View_Name.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view addSubview:View_Name];
    [View_Name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
    }];
    UITextField *txf_name=[[UITextField alloc]init];
    SubmitFormView *nameview=[[SubmitFormView alloc]initBaseView:View_Name WithContent:txf_name WithFormType:formViewShowText WithSegmentType:lineViewNone WithString:Custing(@"会议室名称", nil) WithTips:nil WithInfodict:@{@"value1":self.model.name}];
    [View_Name addSubview:nameview];
    

    UIView *View_Date=[[UIView alloc]init];
    View_Date.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view addSubview:View_Date];
    [View_Date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_Name.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
    }];
    UITextField *txf_Date=[[UITextField alloc]init];
    SubmitFormView *dateview=[[SubmitFormView alloc]initBaseView:View_Date WithContent:txf_Date WithFormType:formViewShowText WithSegmentType:lineViewNoneLine WithString:Custing(@"会议日期", nil) WithTips:nil WithInfodict:@{@"value1":self.str_date}];
    [View_Date addSubview:dateview];
    
    UIView *View_Start=[[UIView alloc]init];
    View_Start.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view addSubview:View_Start];
    [View_Start mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_Date.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
    }];
    _txf_start=[[UITextField alloc]init];
    SubmitFormView *startview=[[SubmitFormView alloc]initBaseView:View_Start WithContent:_txf_start WithFormType:formViewSelectTime WithSegmentType:lineViewNoneLine WithString:Custing(@"开始", nil) WithInfodict:nil WithTips:Custing(@"请选择开始时间", nil) WithNumLimit:0];
    [View_Start addSubview:startview];

    
    UIView *View_End=[[UIView alloc]init];
    View_End.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view addSubview:View_End];
    [View_End mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_Start.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
    }];
    _txf_end=[[UITextField alloc]init];
    SubmitFormView *endview=[[SubmitFormView alloc]initBaseView:View_End WithContent:_txf_end WithFormType:formViewSelectTime WithSegmentType:lineViewNoneLine WithString:Custing(@"结束", nil) WithInfodict:nil WithTips:Custing(@"请选择结束时间", nil) WithNumLimit:0];
    [View_End addSubview:endview];
    
    if (_model.meetingBookings.count>0) {
        MeetingDuringView *view_MeetingDuringView=[[MeetingDuringView alloc]initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        [self.view addSubview:view_MeetingDuringView];
        
        NSInteger row =ceilf((float)(_model.meetingBookings.count)/3);
        [view_MeetingDuringView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(View_End.bottom).offset(@10);
            make.left.equalTo(self.view.left);
            make.right.equalTo(self.view.right);
            make.height.equalTo(@(30+26*row));
        }];
        [view_MeetingDuringView configMeetingDuringViewData:_model.meetingBookings WithType:2];
    }
}

-(void)Sure:(UIButton *)btn{
    if (self.txf_start.text.length==0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择开始", nil) duration:2.0];
        return;
    }
    if (self.txf_end.text.length==0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择结束", nil) duration:2.0];
        return;
    }
    if ([NSDate CompareDateStartTime:self.txf_start.text endTime:self.txf_end.text WithFormatter:@"HH:mm"]<=0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择正确的会议时间", nil) duration:2.0];
        return;
    }
    for (MeetingRoomSubModel *model in self.model.meetingBookings) {
        if (!([NSDate CompareDateStartTime:self.txf_end.text endTime:model.startTimeStr WithFormatter:@"HH:mm"]>0||[NSDate CompareDateStartTime:model.endTimeStr endTime:self.txf_start.text WithFormatter:@"HH:mm"]>0)) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前选择的时间段冲突,请重新选择", nil) duration:2.0];
            return;
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"GETROOMIDADNTIME" object:self userInfo:@{@"RoomId":_model.Id,@"RoomName":_model.name,@"FromTime":[NSString stringWithFormat:@"%@ %@",self.str_date,self.txf_start.text],@"ToTime":[NSString stringWithFormat:@"%@ %@",self.str_date,self.txf_end.text]}];
    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
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
