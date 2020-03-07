//
//  AddPeopleViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/1/18.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "AddPeopleViewController.h"
#import "PeopleAdd_lable_btn_TableViewCell.h"
#import "PeopleAdd_label_text_TableViewCell.h"
#import "SelectViewController.h"
#import "JKAlertDialog.h"
#import "SexEditTableViewCell.h"
#import "AddDeparViewController.h"

@interface AddPeopleViewController ()<UITableViewDelegate,UITableViewDataSource,SelectViewControllerDelegate,UITextFieldDelegate,GPClientDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong)NSMutableArray *muarray;

//修改性别的弹窗。。。
@property (nonatomic, strong) JKAlertDialog *alert;
@property (nonatomic, strong) UITableView *tableview;
@property(nonatomic,strong)UITapGestureRecognizer * longPress;//长按手势

@end

@implementation AddPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:Custing(@"添加新成员", nil) backButton:YES ];
    _lc_btn_ok.constant = Main_Screen_Width;
    
    [self addMutableArray];
    
    [self.btn_btnClick setTitle:Custing(@"提交", nil) forState:UIControlStateNormal];
    [self.btn_btnDelect setTitle:Custing(@"删除", nil) forState:UIControlStateNormal];
    
    self.tab_table.delegate = self;
    self.tab_table.dataSource = self;
    self.tab_table.tableFooterView = [[UIView alloc]init];
    self.tab_table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tab_table.backgroundColor = Color_White_Same_20;
    _longPress = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    _longPress.delegate = self;
    [self.tab_table addGestureRecognizer:_longPress];
}

-(void)tapGesture:(UITapGestureRecognizer *)tapGesture{
    
    [self keyClose];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

-(void)addMutableArray
{
    if (![NSString isEqualToNull:_DeparTitle]) {
        _DeparTitle = self.userdatas.company;
        _DeparId = self.userdatas.companyId;
    }

    NSString *string= [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"{\"array\":[{\"title\":\"",Custing(@"姓名", nil),@"\",\"value\":\"\"},{\"title\":\"",Custing(@"性别", nil),@"\",\"value\":\"\"},{\"title\":\"手机\",\"value\":\"\"},{\"title\":\"",Custing(@"邮箱", nil),@"\",\"value\":\"\"},{\"title\":\"",Custing(@"部门", nil),@"\",\"value\":\"",_DeparTitle,@"\"},{\"title\":\"",Custing(@"职位", nil),@"\",\"value\":\"\"},{\"title\":\"",Custing(@"级别", nil),@"\",\"value\":\"\"},{\"title\":\"",Custing(@"成本中心", nil),@"\",\"value\":\"\"}]}"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSString dictionaryWithJsonString:string]];
    _muarray = [NSMutableArray arrayWithArray:dic[@"array"]];
}

#pragma mark - 表单代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==88) {
        return 2;
    }
//    return _muarray.count+1;
    return 1;
}

//返回两个组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag==88) {
        return 1;
    }
    return _muarray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag==88) {
        return 0;
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 88) {
        NSMutableArray *muarr = _muarray;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:muarr[1]];
        
        SexEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SexEditTableViewCell" owner:nil options:nil];
            cell = [nib lastObject];
        }
        if (indexPath.row == 0) {
            cell.lbl_label.text = Custing(@"男", nil);
            if ([dic[@"value"] isEqualToString:Custing(@"男", nil) ]) {
                cell.img_image.highlighted = YES;
            }
            if (![NSString isEqualToNull:dic[@"value"]]) {
                cell.img_image.highlighted = YES;
            }
        }
        if (indexPath.row == 1) {
            cell.lbl_label.text = Custing(@"女", nil);
            if ([dic[@"value"] isEqualToString:Custing(@"女", nil)]) {
                cell.img_image.highlighted = YES;
            }
        }
        
        return cell;
    }
    static NSString *check = @"cell";
//下次添加时候用
//    NSLog(@"%ld",(long)indexPath.row);
//    if (indexPath.row == _muarray.count )
//    {
//        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44)];
//        UIButton *btn = [GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 44) action:@selector(addcell_click:) delegate:self title:@"添加职位和部门" font:Font_cellContent_16 titleColor:Color_form_TextFieldBackgroundColor];
//        [btn setBackgroundColor:[UIColor blueColor]];
//        [cell addSubview:btn];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消点击的灰色
//        return cell;
//    }
//    else
//    {
        PeopleAdd_label_text_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:check];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PeopleAdd_label_text_TableViewCell" owner:self options:nil];
            cell = [nib lastObject];
        }
        cell.dic = _muarray[indexPath.section];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消点击的灰色
        cell.txf_textField.tag = indexPath.section;
        if (indexPath.section==0) {
            [cell.txf_textField becomeFirstResponder];
        }
        cell.txf_textField.delegate = self;
        UIButton *btn;
        if ([cell.dic[@"title"] isEqualToString:Custing(@"手机", nil)]) {
            cell.txf_textField.keyboardType =UIKeyboardTypeNumberPad;
        }
        if ([cell.dic[@"title"] isEqualToString:Custing(@"级别", nil)]) {
            cell.txf_textField.userInteractionEnabled = NO;
            cell.img_rightImage.hidden = NO;
            btn = [GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 44) action:@selector(level_click:) delegate:self title:nil font:Font_cellContent_16 titleColor:[UIColor clearColor]];
            cell.txf_textField.textAlignment = NSTextAlignmentRight;
//            [cell.txf_textField setValue:Color_Blue_Important_20 forKeyPath:@"_placeholderLabel.textColor"];
        }
        if ([cell.dic[@"title"] isEqualToString:Custing(@"性别", nil)]) {
            cell.img_rightImage.hidden = NO;
            cell.txf_textField.userInteractionEnabled = NO;
            btn = [GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 44) action:@selector(sex_click:) delegate:self title:nil font:Font_cellContent_16 titleColor:[UIColor clearColor]];
            cell.txf_textField.textAlignment = NSTextAlignmentRight;
//            [cell.txf_textField setValue:Color_Blue_Important_20 forKeyPath:@"_placeholderLabel.textColor"];
        }
        if ([cell.dic[@"title"] isEqualToString:Custing(@"职位", nil)]) {
            cell.img_rightImage.hidden = NO;
            cell.txf_textField.userInteractionEnabled = NO;
            btn = [GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 44) action:@selector(position_click:) delegate:self title:nil font:Font_cellContent_16 titleColor:[UIColor clearColor]];
            cell.txf_textField.textAlignment = NSTextAlignmentRight;
//            [cell.txf_textField setValue:Color_Blue_Important_20 forKeyPath:@"_placeholderLabel.textColor"];
        }
        if ([cell.dic[@"title"] isEqualToString:Custing(@"部门", nil)]) {
            cell.img_rightImage.hidden = YES;
            cell.txf_textField.userInteractionEnabled = NO;
            btn = [GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 44) action:@selector(department_click:) delegate:self title:nil font:Font_cellContent_16 titleColor:[UIColor clearColor]];
            cell.txf_textField.textAlignment = NSTextAlignmentRight;
//            [cell.txf_textField setValue:Color_Blue_Important_20 forKeyPath:@"_placeholderLabel.textColor"];
        }
        if ([cell.dic[@"title"] isEqualToString:Custing(@"成本中心", nil)])
        {
            cell.img_rightImage.hidden = NO;
            cell.txf_textField.userInteractionEnabled = NO;
            btn = [GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 44) action:@selector(cost_click:) delegate:self title:nil font:Font_cellContent_16 titleColor:[UIColor clearColor]];
            cell.txf_textField.textAlignment = NSTextAlignmentRight;
//            [cell.txf_textField setValue:Color_Blue_Important_20 forKeyPath:@"_placeholderLabel.textColor"];
        }
        [cell addSubview:btn];
        return cell;
//    }
//    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.alert dismiss];
    if (tableView.tag == 88) {
        NSMutableArray *muarr = _muarray;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:muarr[1]];
        [dic setObject:indexPath.row==0?Custing(@"男", nil):Custing(@"女",nil) forKey:@"value"];
        muarr[1] = dic;
        _muarray = muarr;
    }
    [_tab_table reloadData];
}

//增加行点击
-(void)addcell_click:(UIButton *)btn
{
    [self keyClose];
}

//成本中心点击
-(void)cost_click:(UIButton *)btn
{
    [self keyClose];
    SelectViewController *select = [[SelectViewController alloc]init];
    select.type = 2;
    select.delegate = self;
    [self.navigationController pushViewController:select animated:YES];
}

//级别点击
-(void)level_click:(UIButton *)btn
{
    [self keyClose];
    NSLog(@"level_click");
    SelectViewController *select = [[SelectViewController alloc]init];
    select.type = 0;
    select.delegate = self;
    [self.navigationController pushViewController:select animated:YES];
}

//性别点击
-(void)sex_click:(UIButton *)btn
{
    [self keyClose];
    self.alert = [[JKAlertDialog alloc]initWithTitle:Custing(@"选择性别", nil) message:@"" canDismis:YES];
    self.tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 270, 120) style:UITableViewStylePlain];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.tableFooterView = [[UIView alloc]init];
    self.tableview.tag = 88;
    self.alert.contentView =  self.tableview;
    [self.alert show];
}

//职位点击
-(void)position_click:(UIButton *)btn
{
    [self keyClose];
    SelectViewController *select = [[SelectViewController alloc]init];
    select.type = 1;
    select.delegate = self;
    [self.navigationController pushViewController:select animated:YES];
}

//部门点击
-(void)department_click:(UIButton *)btn
{
    [self keyClose];
    
    
}

//提交点击
- (IBAction)add_click:(UIButton *)sender {
    _btn_btnClick.userInteractionEnabled = NO;
    [self.view endEditing:YES];
    NSMutableDictionary *Dic = [[NSMutableDictionary alloc]init];
    if (![NSString isEqualToNull:_muarray[0][@"value"]]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"姓名为必填内容", nil) duration:1.0];
        _btn_btnClick.userInteractionEnabled = YES;
        return;
    }
    
    [Dic setObject:_muarray[0][@"value"] forKey:@"userdspname"];
    
    
    //验证性别
    NSString *str_sex = _muarray[1][@"value"];
    if (![NSString isEqualToNull:str_sex]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请选择性别", nil)];
        _btn_btnClick.userInteractionEnabled = YES;
        return;
    }
    
    if (![NSString isEqualToNull:_muarray[2][@"value"]]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请确认手机内容是否填写正确", nil) duration:1.0];
        _btn_btnClick.userInteractionEnabled = YES;
        return;
    }
    
    NSString *i = _muarray[2][@"value"];
        if (i.length != 11) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil) duration:1.5];
            _btn_btnClick.userInteractionEnabled = YES;
            return;
            
        }
        NSString *phoneRegex = @"^1[0-9]{10}$";
        NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        if (![phonePredicate evaluateWithObject:_muarray[2][@"value"]]) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil)];
            _btn_btnClick.userInteractionEnabled = YES;
            return;
        }
    
    [Dic setObject:[NSString isEqualToNull:_muarray[2][@"value"]]?_muarray[2][@"value"]:[NSNull null] forKey:@"mobile"];
    
    //验证邮箱
    NSString *str_email = _muarray[3][@"value"];
    if ([NSString isEqualToNull:str_email]) {
        if (str_email.length >40) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"邮箱不能超过40位", nil) duration:1.5];
            _btn_btnClick.userInteractionEnabled = YES;
            return;
        }
        
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailPredicate evaluateWithObject:str_email]) {//邮箱地址不正确吧？
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"输入邮箱信息不正确，请重新输入。", nil)];
            _btn_btnClick.userInteractionEnabled = YES;
            return;
        }
    }
    
    [Dic setObject:[NSString isEqualToNull:_muarray[3][@"value"]]?_muarray[3][@"value"]:[NSNull null] forKey:@"email"];
    [Dic setObject:[NSString isEqualToNull:_muarray[6][@"id"]]?_muarray[6][@"id"]:[NSNull null] forKey:@"userlevel"];
    [Dic setObject:[NSString isEqualToNull:_muarray[7][@"id"]]?_muarray[7][@"id"]:[NSNull null] forKey:@"costcenter"];
    [Dic setObject:[_muarray[1][@"value"] isEqualToString:@"女"]?@"1":@"0" forKey:@"gender"];
    
    
    NSMutableDictionary *mbdic = [[NSMutableDictionary alloc]init];
    [mbdic setObject:_DeparId forKey:@"groupid"];
    [mbdic setObject:_muarray[5][@"id"]?_muarray[5][@"id"]:[NSNull null] forKey:@"jobtitlecode"];
    [mbdic setObject:_muarray[5][@"value"] forKey:@"jobtitle"];
    NSMutableArray *mbarr = [[NSMutableArray alloc]init];
    [mbarr addObject:mbdic];
    [Dic setObject:mbarr forKey:@"groupmbrs"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSDictionary *adddic = @{@"Mbrs":stri};
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",addmbr] Parameters:adddic Delegate:self SerialNum:1 IfUserCache:NO];
}

- (IBAction)btn_delect_click:(id)sender {
    
}


-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);

    [YXSpritesLoadingView dismiss];
    NSString *success = [NSString stringWithFormat:@"%@",responceDic[@"success"]];
    if (![success isEqualToString:@"1"]) {
        _btn_btnClick.userInteractionEnabled = YES;
        return;
    }
    else
    {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"添加成功", nil) duration:1.0];
        [self performBlock:^{
            [self Navback];
        } afterDelay:1.0f];
        
    }
}

#pragma mark -代理
-(void)SelectViewControllerClickedLoadBtn:(SelectDataModel *)selectmodel
{
    if ([NSString isEqualToNull:selectmodel.jobTitle]) {
        NSMutableArray *muarr = _muarray;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:muarr[5]];
        [dic setObject:selectmodel.jobTitle forKey:@"value"];
        [dic setObject:selectmodel.jobTitleCode forKey:@"id"];
        muarr[5] = dic;
        _muarray = muarr;
    }
    if ([NSString isEqualToNull:selectmodel.userLevel]) {
        NSMutableArray *muarr = _muarray;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:muarr[6]];
        [dic setObject:selectmodel.userLevel forKey:@"value"];
        [dic setObject:selectmodel.ids forKey:@"id"];
        muarr[6] = dic;
        _muarray = muarr;
    }
    if ([NSString isEqualToNull:selectmodel.costCenter]) {
        NSMutableArray *muarr = _muarray;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:muarr[7]];
        [dic setObject:selectmodel.costCenter forKey:@"value"];
        [dic setObject:selectmodel.ids forKey:@"id"];
        muarr[7] = dic;
        _muarray = muarr;
    }
    [_tab_table reloadData];
}
#pragma mark -代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }

    if (textField.tag == 2) {
        if (textField.text.length > 10) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"手机号码不能超过11位", nil) duration:1.5];
            _btn_btnClick.userInteractionEnabled = YES;
            return NO;
        }
        NSString *emailRegex = @"[0-9]{10}$";
        NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailPredicate evaluateWithObject:textField.text]) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:@"请输入正确的手机号"];
            return NO;
        }
    }
    
    NSMutableArray *muarr = _muarray;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:muarr[textField.tag]];
    [dic setObject:textField.text forKey:@"value"];
    muarr[textField.tag] = dic;
    _muarray = muarr;
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 2) {
        if (textField.text.length != 11) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil) duration:1.5];
            _btn_btnClick.userInteractionEnabled = YES;
            return;
        }
        NSString *emailRegex = @"^1[0-9]{10}$";
        NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailPredicate evaluateWithObject:textField.text]) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil)];
            _btn_btnClick.userInteractionEnabled = YES;
            return;
        }
    }
    
    NSMutableArray *muarr = _muarray;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:muarr[textField.tag]];
    [dic setObject:textField.text forKey:@"value"];
    muarr[textField.tag] = dic;
    _muarray = muarr;
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [_nameTextField resignFirstResponder];
 
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
