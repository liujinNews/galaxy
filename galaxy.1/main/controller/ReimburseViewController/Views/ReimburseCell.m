//
//  ReimburseCell.m
//  galaxy
//
//  Created by hfk on 16/4/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ReimburseCell.h"

@implementation ReimburseCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_form_TextFieldBackgroundColor;
        if (!self.userdatas) {
            self.userdatas = [userData shareUserData];
        }
        //        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    if (selected) {
        
    }
}

- (void)configSectionZeroWithrRow:(NSInteger)row withTolMoney:(NSString *)money withNote:(NSDictionary *)noteDict{
    [self createMainView];
    if (row==0) {
        self.mainView.frame=CGRectMake(0, 0, Main_Screen_Width, 74);

        _iconImageView.image=[UIImage imageNamed:@"Reimburse_Amount"];
        _iconImageView.center=CGPointMake(38, 37);
        
        
        _titleLabel.frame=CGRectMake(68, 27,100, 18);
        //        _titleLabel.backgroundColor=[UIColor redColor];
        _titleLabel.text=Custing(@"未提交费用", nil);
        
//        _descriptionLabel.frame=CGRectMake(X(_titleLabel), 32+HEIGHT(_titleLabel), 180, 14);
//        _descriptionLabel.text=Custing(@"未报销的金额汇总", nil);
        
        
        _moneyLabel=[GPUtils createLable:CGRectMake(168,32,Main_Screen_Width-183, 20) text:[GPUtils transformNsNumber:money] font:Font_Amount_21_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
        [self.mainView addSubview:_moneyLabel];
        //        _moneyLabel.backgroundColor=[UIColor cyanColor];
        
        _linkImageView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 1, 16) imageName:nil];
        _linkImageView.center=CGPointMake(38, 66);
        _linkImageView.image = [UIImage imageNamed:@"Work_HeadBlue"];
        _linkImageView.backgroundColor=Color_Blue_Important_20;
        [self.mainView addSubview:_linkImageView];
        
    }else if (row==1){
        if ([NSString isEqualToNull:noteDict[@"expenseType"]]) {
            CGSize size = [noteDict[@"expenseType"] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-205, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            self.mainView.frame=CGRectMake(0, 0, Main_Screen_Width, 35+size.height);
        }else{
            self.mainView.frame=CGRectMake(0, 0, Main_Screen_Width, 62);
            
        }
        
        _iconImageView.frame= CGRectMake(0, 0, 18, 18);
        _iconImageView.center=CGPointMake(38, 26);
        _iconImageView.image=[UIImage imageNamed:@"Reimburse_Circle"];
        
        
        _moneyLabel=[GPUtils createLable:CGRectMake(Main_Screen_Width-135, 20, 120, 12) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        
        [self.mainView addSubview:_moneyLabel];
        
        if ([NSString isEqualToNull:noteDict[@"amount"]]) {
            _moneyLabel.text=[GPUtils transformNsNumber:noteDict[@"amount"]];
            //            _moneyLabel.backgroundColor=[UIColor blueColor];
        }else{
            _moneyLabel.text=@"0.00";
        }
        
        _currCodeLabel=[GPUtils createLable:CGRectMake(Main_Screen_Width-135, 30, 120, 12) text:([NSString isEqualToNull:[NSString stringWithFormat:@"%@",noteDict[@"currencyCode"]]]&&![[NSString stringWithFormat:@"%@",noteDict[@"currencyCode"]]isEqualToString:@"CNY"])?[NSString stringWithFormat:@"%@",noteDict[@"currencyCode"]]:@"" font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        [self.mainView addSubview:_currCodeLabel];
        
        if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",noteDict[@"currencyCode"]]]&&![[NSString stringWithFormat:@"%@",noteDict[@"currencyCode"]]isEqualToString:@"CNY"]) {
            _currCodeLabel=[GPUtils createLable:CGRectMake(Main_Screen_Width-135, 30, 120, 12) text:[NSString stringWithFormat:@"%@",noteDict[@"currencyCode"]] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
            [self.mainView addSubview:_currCodeLabel];
            
            _moneyLabel.frame=CGRectMake(Main_Screen_Width-135, 15, 120, 12);
        }
        
        
        _titleLabel.frame=CGRectMake(68, 10, 150, 18);
        //        _titleLabel.backgroundColor=[UIColor cyanColor];
        if ([NSString isEqualToNull:noteDict[@"expenseType"]]) {
            _titleLabel.text=noteDict[@"expenseType"];
            CGSize size = [noteDict[@"expenseType"] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-205, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            _titleLabel.numberOfLines=0;
            _titleLabel.frame=CGRectMake(68, 10, Main_Screen_Width-205, size.height);
        }else{
            _titleLabel.text=Custing(@"还没有添加消费记录", nil);
            _titleLabel.numberOfLines=2;
            _titleLabel.frame=CGRectMake(68, 10, 150, 36);
            self.userInteractionEnabled=NO;
        }
        
        _titleLabel.textColor=Color_GrayDark_Same_20;
        
//        NSLog(@"%@",noteDict[@"expenseType"]);
        
        _descriptionLabel.frame=CGRectMake(X(_titleLabel), 15+HEIGHT(_titleLabel), 180, 14);
        if ([NSString isEqualToNull:noteDict[@"expenseDate"]]) {
            _descriptionLabel.text=noteDict[@"expenseDate"];
        }
        _linkImageView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 1, 18) imageName:nil];
        _linkImageView.center=CGPointMake(38, 8);
        _linkImageView.image = [UIImage imageNamed:@"Work_HeadBlue"];
        _linkImageView.backgroundColor=Color_Blue_Important_20;
        [self.mainView addSubview:_linkImageView];
    }
    
    [self createLineViewWithRows:2 WithIndex:row];
}

- (void)configSectionOtherWithrIndexPath:(NSIndexPath*)index WithShowArray:(NSMutableArray *)showArray{
    
    [self createMainView];
    self.mainView.frame=CGRectMake(0, 0, Main_Screen_Width, 70);
    
   NSString *flowKey = [NSString stringWithFormat:@"%@",showArray[index.row]];
   NSDictionary *dict = [VoiceDataManger getFlowShowInfo:flowKey];
    if (!dict) {
        return;
    }
    _iconImageView.image=[UIImage imageNamed:dict[@"EnterImage"]];
    _titleLabel.text=dict[@"Title"];
    _descriptionLabel.text=dict[@"Description"];
    if ([dict[@"IsNew"]floatValue]==1) {
        _NewMarkImgView.image=[UIImage imageNamed:@"Reimburse_New"];
    }

    [self createLineShowViewWithRows:showArray.count WithIndex:index.row];
    
    _clickImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,20, 20)];
    _clickImageView.center=CGPointMake(Main_Screen_Width-18, 35);
    _clickImageView.image =[UIImage imageNamed:@"skipImage"];
    [self.mainView addSubview:_clickImageView];
}


-(void)createMainView{
    self.userInteractionEnabled=YES;
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]init];
    [self.contentView addSubview:self.mainView];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    _iconImageView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 42, 42) imageName:nil];
    _iconImageView.center=CGPointMake(38,35);
    //    _iconImageView.backgroundColor=[UIColor redColor];
    [self.mainView addSubview:_iconImageView];
    
    _NewMarkImgView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 42, 10) imageName:nil];
    _NewMarkImgView.center=CGPointMake(38,51);
    //    _iconImageView.backgroundColor=[UIColor redColor];
    [self.mainView addSubview:_NewMarkImgView];
    
    _titleLabel=[GPUtils createLable:CGRectMake(68, 15, Main_Screen_Width-83, 18) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:_titleLabel];
    
    _descriptionLabel=[GPUtils createLable:CGRectMake(X(_titleLabel), 15+HEIGHT(_titleLabel), Main_Screen_Width-X(_titleLabel)-48, 28) text:nil font:Font_Same_11_20  textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    _descriptionLabel.numberOfLines=2;
    //    _descriptionLabel.backgroundColor=[UIColor redColor];
    [self.mainView addSubview:_descriptionLabel];
    
}

-(void)createLineViewWithRows:(NSInteger)rowNum WithIndex:(NSInteger)index{
    if (rowNum>1) {
        if(index+1<rowNum){
            _lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(68, HEIGHT(self.mainView)-0.5, Main_Screen_Width-68, 0.5)];
            _lineImageView.backgroundColor=Color_GrayLight_Same_20;
            [self.mainView addSubview:_lineImageView];
        }
    }
}

-(void)createLineShowViewWithRows:(NSInteger)rowNum WithIndex:(NSInteger)index{
    if (rowNum>1) {
        if(index+1<rowNum){
            _lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(68, HEIGHT(self.mainView)-0.5, Main_Screen_Width-68, 0.5)];
            _lineImageView.backgroundColor=Color_GrayLight_Same_20;
            [self.mainView addSubview:_lineImageView];
        }else if (index+1==rowNum){
            _lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, HEIGHT(self.mainView)-0.5, Main_Screen_Width, 0.5)];
            _lineImageView.backgroundColor=Color_GrayLight_Same_20;
            [self.mainView addSubview:_lineImageView];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
