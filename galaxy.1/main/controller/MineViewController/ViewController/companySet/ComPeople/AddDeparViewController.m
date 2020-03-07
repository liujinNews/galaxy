//
//  AddDeparViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/1/20.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "AddDeparViewController.h"
#import "AddDeparTableViewCell.h"

@interface AddDeparViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,GPClientDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong)NSMutableArray *muarray;
@property(nonatomic,strong)UITapGestureRecognizer * longPress;//长按手势
@end

@implementation AddDeparViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_type isEqualToString:@"1"]) {
        [self setTitle:Custing(@"管理部门", nil) backButton:YES ];
        _lc_btn_delete.constant = Main_Screen_Width/2;
    }
    else
    {
        [self setTitle:Custing(@"添加子部门", nil) backButton:YES ];
        _lc_btn_delete.constant = Main_Screen_Width;
    }
    [self.btn_addClick setTitle:Custing(@"保存", nil) forState:UIControlStateNormal];
    [self.btn_deleteBtn setTitle:Custing(@"删除", nil) forState:UIControlStateNormal];
    
    [self addMutableArray];
    self.tab_table.delegate = self;
    self.tab_table.dataSource = self;
    self.tab_table.tableFooterView = [[UIView alloc]init];
    self.tab_table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tab_table.backgroundColor = Color_White_Same_20;
    
    _longPress = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    _longPress.delegate = self;
    [self.tab_table addGestureRecognizer:_longPress];
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
    NSString *string= [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@",@"{\"array\":[{\"title\":\"",Custing(@"部门名称：", nil),@"\",\"value\":\"",_NowDeparName,@"\"},{\"title\":\"",Custing(@"上级部门：",nil),@"\",\"value\":\"",_DeparTitle,@"\"},{\"title\":\"",Custing(@"公司：",nil),@"\",\"value\":0}]}"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSString dictionaryWithJsonString:string]];
    _muarray = [NSMutableArray arrayWithArray:dic[@"array"]];
}

#pragma mark - 表单代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//返回两个组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *check = @"cell";
//    AddDeparTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:check];
//    if (!cell) {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddDeparTableViewCell" owner:self options:nil];
//        cell = [nib lastObject];
//    }
    AddDeparTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"AddDeparTableViewCell" owner:self options:nil] lastObject];
    cell.dic = _muarray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消点击的灰色
    cell.txf_textfield.tag = indexPath.section;
    if (indexPath.section==0&&![_type isEqualToString:@"1"]) {
        //[cell.txf_textfield becomeFirstResponder];
    }
    
    if ([cell.dic[@"title"] isEqualToString:Custing(@"部门名称", nil)]) {
        cell.txf_textfield.placeholder = Custing(@"请输入部门名称", nil);
        if ([NSString isEqualToNull:cell.dic[@"value"]]) {
            cell.txf_textfield.text = cell.dic[@"value"];
        }
    }

    cell.txf_textfield.delegate = self;
    if (indexPath.section == 1) {
        cell.txf_textfield.userInteractionEnabled = NO;
    }
    if (indexPath.section == 2) {
        cell.txf_textfield.hidden = YES;
        UISwitch *swi = [[UISwitch alloc]initWithFrame:CGRectMake(Main_Screen_Width-66, 6, 51, 31)];
        [swi addTarget:self action:@selector(switchOn:) forControlEvents:UIControlEventValueChanged];
//        swi.tintColor = Color_Blue_Important_20;
        if (_isBranch==1) {
            swi.on = YES;
        }
        swi.onTintColor = Color_Blue_Important_20;
        [cell addSubview:swi];
    }
    return cell;
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
    if ([string isEqualToString:@" "]) {
        return NO;
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
    NSMutableArray *muarr = _muarray;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:muarr[textField.tag]];
    [dic setObject:textField.text forKey:@"value"];
    muarr[textField.tag] = dic;
    _muarray = muarr;
}


#pragma mark - 点击事件
- (IBAction)btn_addClick:(id)sender
{
    if (![_type isEqualToString:@"1"]) {
        if (![NSString isEqualToNull:_muarray[0][@"value"]])
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"部门名称必填", nil) duration:1.0];
            return;
        }
        _btn_addClick.userInteractionEnabled = NO;
        
        [self.view endEditing:YES];
        
        NSMutableDictionary *Dic = [[NSMutableDictionary alloc]init];
        
        [Dic setObject:_DeparId forKey:@"ParentId"];
        
        [Dic setObject:[NSString isEqualToNull:_DeparCode]?_DeparCode:[NSNull null] forKey:@"ParentCode"];
        [Dic setObject:[NSString isEqualToNull:_muarray[0][@"value"]]?_muarray[0][@"value"]:[NSNull null] forKey:@"GroupName"];
        [Dic setObject:[NSString isEqualToNull:_DeparLevel]?_DeparLevel:@"" forKey:@"GroupLevel"];
        [Dic setObject:@"" forKey:@"GroupCode"];
        [Dic setObject:_muarray[2][@"value"] forKey:@"IsBranch"];
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",addgroup] Parameters:Dic Delegate:self SerialNum:1 IfUserCache:NO];
    }
    else
    {
        if (![NSString isEqualToNull:_muarray[0][@"value"]])
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"部门名称必填", nil) duration:1.0];
            return;
        }
        _btn_addClick.userInteractionEnabled = NO;
        _btn_deleteBtn.userInteractionEnabled = NO;
        [self.view endEditing:YES];
        
        NSMutableDictionary *Dic = [[NSMutableDictionary alloc]init];
        
        [Dic setObject:_NowDeparId forKey:@"GroupId"];
        
        [Dic setObject:_muarray[0][@"value"] forKey:@"GroupName"];
        [Dic setObject:_muarray[2][@"value"] forKey:@"IsBranch"];
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",renamegroup] Parameters:Dic Delegate:self SerialNum:2 IfUserCache:NO];
    }
}

- (IBAction)btn_delete_click:(UIButton *)sender {
    _btn_addClick.userInteractionEnabled = NO;
    _btn_deleteBtn.userInteractionEnabled = NO;
    [self.view endEditing:YES];
    
    NSMutableDictionary *Dic = [[NSMutableDictionary alloc]init];
    
    [Dic setObject:_NowDeparId forKey:@"GroupId"];
    
    [Dic setObject:_muarray[0][@"value"] forKey:@"GroupName"];
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",deletegroup] Parameters:Dic Delegate:self SerialNum:3 IfUserCache:NO];
}

-(void)switchOn:(UISwitch *)swi
{
    NSMutableArray *muarr = _muarray;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:muarr[2]];
    [dic setObject:swi.isOn==YES?@"1":@"0" forKey:@"value"];
    muarr[2] = dic;
    _muarray = muarr;
}


-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    NSString *success = [NSString stringWithFormat:@"%@",responceDic[@"success"]];
    if (![success isEqualToString:@"1"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:responceDic[@"msg"] duration:1.0];
        _btn_addClick.userInteractionEnabled = YES;
        return;
    }
    else
    {
        if (serialNum == 1) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"添加成功", nil) duration:1.0];
            [self performBlock:^{
                [self Navback];
            } afterDelay:1.0f];
        }
        else if (serialNum == 2)
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"修改成功", nil) duration:1.0];
            [self performBlock:^{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
            } afterDelay:1.0f];
        }
        else if (serialNum == 3)
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:1.0];
            [self performBlock:^{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
            } afterDelay:1.0f];
        }
    }
}


//点击键盘收回
-(void)tapGesture:(UITapGestureRecognizer *)tapGesture{

    [self keyClose];
    
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
