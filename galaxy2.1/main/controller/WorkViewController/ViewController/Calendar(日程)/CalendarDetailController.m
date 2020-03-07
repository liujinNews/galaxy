//
//  CalendarDetailController.m
//  galaxy
//
//  Created by hfk on 2018/1/19.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "CalendarDetailController.h"
#import "KxMenu.h"
#import "NewCalendarController.h"
@interface CalendarDetailController ()<GPClientDelegate,UIScrollViewDelegate,ByvalDelegate>

@end

@implementation CalendarDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"日程详情", nil) backButton:YES];
    [self createScrollView];
    [self requestGetData];
}
-(void)createMoreBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *addBar = [UIBarButtonItem RootCustomNavButtonWithWithButton:btn title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"NavBarImg_AgentMore":@"NavBarImg_More" target:self action:@selector(MoreClick:)];
    self.navigationItem.rightBarButtonItem = addBar;
}
//MARK:创建主scrollView
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [self createMainView];
}

//MARK:创建主视图
-(void)createMainView{
    _View_Content=[[UIView alloc]init];
    _View_Content.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:_View_Content];
    [_View_Content makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_Notify=[[UIView alloc]init];
    _View_Notify.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:_View_Notify];
    [_View_Notify makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Content.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];

    _View_Project=[[UIView alloc]init];
    _View_Project.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:_View_Project];
    [_View_Project makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Notify.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);

    }];
    
    _View_Client=[[UIView alloc]init];
    _View_Client.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:_View_Client];
    [_View_Client makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Project.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_Supplier=[[UIView alloc]init];
    _View_Supplier.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:_View_Supplier];
    [_View_Supplier makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Client.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_Remark=[[UIView alloc]init];
    _View_Remark.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:_View_Remark];
    [_View_Remark makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Supplier.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_AttachImg=[[UIView alloc]init];
    _View_AttachImg.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
}
-(void)requestGetData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GETCaldanerDETAIL];
    NSDictionary *parameters = @{@"ScheduleId":_str_ScheduleId};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:下载成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    switch (serialNum) {
        case 0:
        {
            if ([responceDic[@"result"] isKindOfClass:[NSDictionary class]]) {
                self.dict_resultDict=responceDic[@"result"];
                if (self.int_status==1||self.int_status==3) {
                    [self createMoreBtn];
                }
                [self updateContentView];
                [self updateNotifyView];
                [self updateProjectView];
                [self updateClientView];
                [self updateSupplierView];
                [self updateRemarkView];
                [self updateAttachImgView];
                [self updateBottomView];
            }
        }
            break;
        case 1:
        {
            if ([[NSString stringWithFormat:@"%@",responceDic[@"result"]]floatValue]>0) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:1.0];
                __weak typeof(self) weakSelf = self;
                [self performBlock:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } afterDelay:1];
            }else{
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除失败", nil) duration:1.0];
            }
        }
            break;
        default:
            break;
    }
    
}

//MARK:请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{

    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
//MARK:右上角按钮
-(void)MoreClick:(UIButton *)btn{
    if ([KxMenu isShowingInView:self.view]) {
        [KxMenu dismissMenu:YES];
    }else{
        [KxMenu setTitleFont:Font_Important_15_20];
        [KxMenu setTintColor:Color_form_TextFieldBackgroundColor];
        [KxMenu setOverlayColor:[UIColor colorWithWhite:0 alpha:0.4]];
        [KxMenu setLineColor:Color_GrayLight_Same_20];
        
        NSMutableArray *menuItems=[NSMutableArray array];
        if (self.int_status==1) {
            [menuItems addObject:[KxMenuItem menuItem:Custing(@"编辑", nil) image:nil target:self action:@selector(editDetail)]];
            [menuItems addObject:[KxMenuItem menuItem:Custing(@"删除", nil) image:nil target:self action:@selector(deleteDetail)]];
            [menuItems addObject:[KxMenuItem menuItem:Custing(@"添加到iOS日历", nil) image:nil target:self action:@selector(addToCalendar)]];
        }else if (self.int_status==3){
            [menuItems addObject:[KxMenuItem menuItem:Custing(@"添加到iOS日历", nil) image:nil target:self action:@selector(addToCalendar)]];
        }
        [menuItems setValue:Color_Blue_Important_20 forKey:@"foreColor"];
        CGRect senderFrame = CGRectMake(Main_Screen_Width - (kDevice_Is_iPhone6Plus? 30: 26), NavigationbarHeight, 0, 0);
        [KxMenu showMenuInView:ApplicationDelegate.window
                      fromRect:senderFrame
                     menuItems:menuItems];
    }
}

-(void)updateContentView{
    NSInteger height=0;
    NSString *title=[NSString isEqualToNull:_dict_resultDict[@"subject"]]?_dict_resultDict[@"subject"]:@"";
    CGSize size = [title sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    if (size.height>24) {
        height+=size.height;
    }else{
        height+=20;
    }
    
    [_View_Content updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height+80));
    }];
    
    UILabel *titleLab=[GPUtils createLable:CGRectMake(12, 12, Main_Screen_Width-24, height) text:title font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLab.numberOfLines=0;
    [_View_Content addSubview:titleLab];
    
    UIImageView *locImg=[GPUtils createImageViewFrame:CGRectMake(12, 12+height+10, 14, 14) imageName:@"Travel_Place"];
    [_View_Content addSubview:locImg];
    NSString *adress=[NSString isEqualToNull:_dict_resultDict[@"address"]]?_dict_resultDict[@"address"]:@"";
    UILabel *addressLab=[GPUtils createLable:CGRectMake(36, 12+height+8, Main_Screen_Width-12-36, 15) text:adress font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [_View_Content addSubview:addressLab];
    
    UIImageView *timeImg=[GPUtils createImageViewFrame:CGRectMake(12, 12+height+8+14+15, 14, 14) imageName:@"Travel_Time"];
    [_View_Content addSubview:timeImg];
    NSString *time=[GPUtils getSelectResultWithArray:@[_dict_resultDict[@"startTimeStr"],_dict_resultDict[@"endTimeStr"]] WithCompare:@" - "];
    UILabel *timeLab=[GPUtils createLable:CGRectMake(36, 12+height+8+14+14, Main_Screen_Width-12-36, 15) text:time font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [_View_Content addSubview:timeLab];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, height+70, Main_Screen_Width, 10)];
    line.backgroundColor=Color_White_Same_20;
    [_View_Content addSubview:line];
}

-(void)updateNotifyView{
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"知会", nil);
    model.fieldValue=[NSString isEqualToNull:_dict_resultDict[@"notifyUserName"]]?[NSString stringWithFormat:@"%@",_dict_resultDict[@"notifyUserName"]]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_Notify addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Notify updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

-(void)updateProjectView{
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"项目", nil);
    model.fieldValue=[NSString isEqualToNull:_dict_resultDict[@"projName"]]?[NSString stringWithFormat:@"%@",_dict_resultDict[@"projName"]]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_Project addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Project updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateClientView{
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"客户", nil);
    model.fieldValue=[NSString isEqualToNull:_dict_resultDict[@"clientName"]]?[NSString stringWithFormat:@"%@",_dict_resultDict[@"clientName"]]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_Client addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Client updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

-(void)updateSupplierView{
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"供应商", nil);
    model.fieldValue=[NSString isEqualToNull:_dict_resultDict[@"supplierName"]]?[NSString stringWithFormat:@"%@",_dict_resultDict[@"supplierName"]]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_Supplier addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Supplier updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateRemarkView{
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"备注", nil);
    model.fieldValue=[NSString isEqualToNull:_dict_resultDict[@"remark"]]?[NSString stringWithFormat:@"%@",_dict_resultDict[@"remark"]]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_Remark addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Remark updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新采购图片
-(void)updateAttachImgView{
    if ([NSString isEqualToNull:_dict_resultDict[@"attachments"]]) {
        NSMutableArray *arr_totalFileArray=[NSMutableArray array];
        NSMutableArray *arr_imagesArray=[NSMutableArray array];
        NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",_dict_resultDict[@"attachments"]]];
        for (NSDictionary *dict in array) {
            [arr_totalFileArray addObject:dict];
        }
        [GPUtils updateImageDataWithTotalArray:arr_totalFileArray WithImageArray:arr_imagesArray WithMaxCount:5];
        
        EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:3 withModel:nil];
        view.maxCount=5;
        [_View_AttachImg addSubview:view];
        [view updateWithTotalArray:arr_totalFileArray WithImgArray:arr_imagesArray];

    }
}
-(void)updateBottomView{
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_AttachImg.bottom).offset(10);
    }];
}

-(void)deleteDetail{
    __weak typeof(self) weakSelf = self;
    [UIAlertView bk_showAlertViewWithTitle:Custing(@"提示", nil) message:Custing(@"确定删除日程?",nil) cancelButtonTitle:Custing(@"取消",nil) otherButtonTitles:@[Custing(@"确定",nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
            NSString *url=[NSString stringWithFormat:@"%@",CaldanerDelete];
            NSDictionary *parameters = @{@"Id":[NSString isEqualToNull:weakSelf.dict_resultDict[@"id"]]?[NSString stringWithFormat:@"%@",weakSelf.dict_resultDict[@"id"]]:@""};
            [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:weakSelf SerialNum:1 IfUserCache:NO];
        }
    }];
}
-(void)editDetail{
    NewCalendarController *vc=[[NewCalendarController alloc]init];
    vc.resultDict=self.dict_resultDict;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)addToCalendar{
//    [UIAlertView bk_showAlertViewWithTitle:Custing(@"提示", nil) message:Custing(@"是否将内容添加到日历？",nil) cancelButtonTitle:Custing(@"取消",nil) otherButtonTitles:@[Custing(@"确定",nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//        if (buttonIndex == 1) {
//        }
//    }];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *fromdate=[NSDate date];
    NSDate *enddate=[NSDate date];;
    if ([NSString isEqualToNull:_dict_resultDict[@"startTimeStr"]]) {
        fromdate=[format dateFromString:[NSString stringWithFormat:@"%@",_dict_resultDict[@"startTimeStr"]]];
    }
    if ([NSString isEqualToNull:_dict_resultDict[@"endTimeStr"]]) {
        enddate=[format dateFromString:[NSString stringWithFormat:@"%@",_dict_resultDict[@"endTimeStr"]]];
    }
    [[EventCalendar alloc]createEventCalendarTitle:Custing(@"日程", nil) location:[NSString isEqualToNull:_dict_resultDict[@"subject"]]?_dict_resultDict[@"subject"]:@"" startDate:fromdate endDate:enddate allDay:NO alarmArray:nil];

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
