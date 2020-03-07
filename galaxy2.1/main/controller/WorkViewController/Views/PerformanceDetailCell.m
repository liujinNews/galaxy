//
//  PerformanceDetailCell.m
//  galaxy
//
//  Created by hfk on 2018/1/24.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "PerformanceDetailCell.h"
#import "PerformanceDetail.h"
@implementation PerformanceDetailCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellAccessoryNone;
        [self createView];
    }
    return self;
}

-(void)createView{
    if (!_view_Segment) {
        _view_Segment=[[UIView alloc]init];
        _view_Segment.backgroundColor=Color_White_Same_20;
        [self.contentView addSubview:_view_Segment];
    }
    [_view_Segment makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.bottom);
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.height.equalTo(@0);
    }];
    
    if (!_lab_SelfTitle) {
        _lab_SelfTitle=[GPUtils createLable:CGRectZero text:Custing(@"自评分 : ", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_SelfTitle];
    }
    CGSize size1=[self getSizeWithString:Custing(@"自评分 : ", nil)];
    [_lab_SelfTitle makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view_Segment.top);
        make.left.equalTo(self.contentView.left).offset(@12);
        make.size.equalTo(CGSizeMake(size1.width, 40));
    }];
    
    if (!_lab_SelfScore) {
        _lab_SelfScore=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Orange_Weak_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_SelfScore];
    }
    [_lab_SelfScore makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view_Segment.top);
        make.left.equalTo(self.lab_SelfTitle.right);
        make.size.equalTo(CGSizeMake(34, 40));
    }];
    
    if (!_img_ScoreLine) {
        _img_ScoreLine=[GPUtils createImageViewFrame:CGRectZero imageName:nil];
        _img_ScoreLine.backgroundColor=Color_GrayLight_Same_20;
        [self.contentView addSubview:_img_ScoreLine];
    }
    [_img_ScoreLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_SelfScore.right);
        make.bottom.equalTo(self.view_Segment.top).offset(@-14);
        make.size.equalTo(CGSizeMake(0.5, 12));
    }];
    
    
    if (!_lab_LeaderTitle) {
        _lab_LeaderTitle=[GPUtils createLable:CGRectZero text:Custing(@"领导评分 : ", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_LeaderTitle];
    }
    CGSize size2=[self getSizeWithString:Custing(@"领导评分 : ", nil)];
    [_lab_LeaderTitle makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view_Segment.top);
        make.left.equalTo(self.img_ScoreLine.right).offset(@12);
        make.size.equalTo(CGSizeMake(size2.width, 40));
    }];
    
    
    if (!_lab_LeaderScore) {
        _lab_LeaderScore=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Green_Weak_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_LeaderScore];
    }
    
    [_lab_LeaderScore makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view_Segment.top);
        make.left.equalTo(self.lab_LeaderTitle.right);
        make.size.equalTo(CGSizeMake(34, 40));
    }];

    
    if (!_btn_ScoreSelect) {
        _btn_ScoreSelect=[GPUtils createButton:CGRectZero action:@selector(ScoreClick:) delegate:self title:Custing(@"分数>", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
        _btn_ScoreSelect.titleLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:_btn_ScoreSelect];
    }
    [_btn_ScoreSelect makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view_Segment.top);
        make.right.equalTo(self.contentView.right).offset(@-12);
        make.size.equalTo(CGSizeMake(50, 40));
    }];
    
    
    if (!_img_BottomLine) {
        _img_BottomLine=[GPUtils createImageViewFrame:CGRectZero imageName:nil];
        _img_BottomLine.backgroundColor=Color_GrayLight_Same_20;
        [self.contentView addSubview:_img_BottomLine];
    }
    [_img_BottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(@12);
        make.bottom.equalTo(self.view_Segment.top).offset(@-40);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-12, 0.5));
    }];
    
    
    if (!_lab_Weigth) {
        _lab_Weigth=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_Weigth];
    }
    [_lab_Weigth makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.img_BottomLine.top).offset(@-30);
        make.left.equalTo(self.contentView.left).offset(@12);
        make.size.equalTo(CGSizeMake(100, 20));
    }];


    if (!_lab_Content) {
        _lab_Content=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        _lab_Content.numberOfLines=0;
        [self.contentView addSubview:_lab_Content];
    }
    
    [_lab_Content makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(@14);
        make.left.equalTo(self.contentView.left).offset(@12);
        make.right.equalTo(self.contentView.right).offset(@-12);
        make.bottom.equalTo(self.lab_Weigth.top).offset(@-7);
    }];
}


-(void)configCellWithDataArray:(NSMutableArray *)dateArray WithType:(NSInteger)type{

    _int_type=type;
    _arr_data=dateArray;
    
    PerformanceDetail *model=_arr_data[self.IndexPath.section];
    NSMutableArray *arr=model.performanceDetailItem;
    self.subModel=arr[self.IndexPath.row];
    
    [_view_Segment updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.IndexPath.row==arr.count-1 ? 0:10));
    }];
    
    _lab_Weigth.text=[NSString stringWithFormat:@"%@%@",Custing(@"权重:", nil),[NSString isEqualToNull:self.subModel.itemWeight]?self.subModel.itemWeight:@""];
    
    self.lab_Content.text=[NSString isEqualToNull:self.subModel.itemName]?[NSString stringWithFormat:@"%@",self.subModel.itemName]:@"";
    
    if (_int_type==1) {
        [_img_ScoreLine updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        [_lab_LeaderTitle updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        [_lab_LeaderScore updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        self.lab_SelfScore.text=[NSString isEqualToNull:self.subModel.selfScore]?[NSString stringWithFormat:@"%@",self.subModel.selfScore]:@"0";
    }else if (_int_type==2){
        [_img_ScoreLine updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        [_lab_SelfTitle updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        [_lab_SelfScore updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        [_lab_LeaderTitle updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.img_ScoreLine.right);
        }];
        self.lab_LeaderScore.text=[NSString isEqualToNull:self.subModel.leaderScore]?[NSString stringWithFormat:@"%@",self.subModel.leaderScore]:@"0";
        
    }else if (_int_type==3){
        self.lab_SelfScore.text=[NSString isEqualToNull:self.subModel.selfScore]?[NSString stringWithFormat:@"%@",self.subModel.selfScore]:@"0";
        self.lab_LeaderScore.text=[NSString isEqualToNull:self.subModel.leaderScore]?[NSString stringWithFormat:@"%@",self.subModel.leaderScore]:@"0";
        
    }else if (_int_type==4){
        [_img_ScoreLine updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        [_lab_LeaderTitle updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        [_lab_LeaderScore updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        [_btn_ScoreSelect updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        self.lab_SelfScore.text=[NSString isEqualToNull:self.subModel.selfScore]?[NSString stringWithFormat:@"%@",self.subModel.selfScore]:@"0";
    }else if (_int_type==5){
        [_img_ScoreLine updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        [_lab_SelfTitle updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        [_lab_SelfScore updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        [_lab_LeaderTitle updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.img_ScoreLine.right);
        }];
        [_btn_ScoreSelect updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        self.lab_LeaderScore.text=[NSString isEqualToNull:self.subModel.leaderScore]?[NSString stringWithFormat:@"%@",self.subModel.leaderScore]:@"0";
    }else if (_int_type==6){
        [_btn_ScoreSelect updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        self.lab_SelfScore.text=[NSString isEqualToNull:self.subModel.selfScore]?[NSString stringWithFormat:@"%@",self.subModel.selfScore]:@"0";
        self.lab_LeaderScore.text=[NSString isEqualToNull:self.subModel.leaderScore]?[NSString stringWithFormat:@"%@",self.subModel.leaderScore]:@"0";
    }
}

-(void)ScoreClick:(id)obj{
    UIViewController *vc=[GPUtils getCurrentVC];
    [vc.view endEditing:YES];
    STOnePickView *picker = [[STOnePickView alloc]init];
    __weak typeof(self) weakSelf = self;
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
        if (weakSelf.int_type==1&&![weakSelf.subModel.selfScore isEqualToString:[NSString stringWithFormat:@"%@",Model.Type]]) {
            weakSelf.subModel.selfScore=[NSString stringWithFormat:@"%@",Model.Type];
            weakSelf.lab_SelfScore.text=[NSString stringWithFormat:@"%@",Model.Type];
            if (weakSelf.ScoreChangeBlock) {
                self.ScoreChangeBlock(weakSelf.int_type);
            }
        }else if ((weakSelf.int_type==2||weakSelf.int_type==3)&&![weakSelf.subModel.leaderScore isEqualToString:[NSString stringWithFormat:@"%@",Model.Type]]){
            weakSelf.subModel.leaderScore=[NSString stringWithFormat:@"%@",Model.Type];
            weakSelf.lab_LeaderScore.text=[NSString stringWithFormat:@"%@",Model.Type];
            if (weakSelf.ScoreChangeBlock) {
                self.ScoreChangeBlock(weakSelf.int_type);
            }
        }
    }];
    picker.typeTitle=Custing(@"分数", nil);
    [self getScoreArray];
    picker.DateSourceArray=[NSMutableArray arrayWithArray:_arr_score];
    STOnePickModel *model=[[STOnePickModel alloc]init];
    if (_int_type==1) {
        model.Type=[NSString stringWithFormat:@"%@",self.subModel.selfScore];
    }else if (_int_type==2||_int_type==3){
        model.Type=[NSString stringWithFormat:@"%@",self.subModel.leaderScore];
    }
    picker.Model=model;
    [picker UpdatePickUI];
    [picker setContentMode:STPickerContentModeBottom];
    [picker show];

}

+ (CGFloat)cellHeightWithObj:(id)obj IsLast:(BOOL)isLast{
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[PerformanceDetailSub class]]) {
        PerformanceDetailSub *task = (PerformanceDetailSub *)obj;
        cellHeight+=(isLast ? 95:105);
        CGSize size = [task.itemName sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if (size.height>20) {
            cellHeight += size.height;
        }else{
            cellHeight += 20;
        }
    }
    return cellHeight;
}

-(CGSize)getSizeWithString:(NSString *)str{
   return [str sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(1000, 1000) lineBreakMode:NSLineBreakByCharWrapping];
}

//MARK:获取分数数组
-(void)getScoreArray{
    _arr_score=[NSMutableArray array];
    for (NSInteger i=1; i<=[self.subModel.stdScore floatValue]; i++) {
        STOnePickModel *model=[[STOnePickModel alloc]init];
        model.Type=[NSString stringWithFormat:@"%ld",i];
        [_arr_score addObject:model];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
