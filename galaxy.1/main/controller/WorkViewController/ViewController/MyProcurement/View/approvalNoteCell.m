//
//  approvalNoteCell.m
//  galaxy
//
//  Created by hfk on 15/10/30.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "approvalNoteCell.h"

@implementation approvalNoteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)configViewWithModel:(approvalNoteModel *)model withCount:(NSInteger )count withIndex:(NSInteger)index
{
    NSInteger rowHeight=[approvalNoteCell NoteHeight:model];
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, rowHeight)];
    self.mainView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:self.mainView];
    
    //张三(开始)
    if ([NSString isEqualToNull:model.nodeName]) {
        self.approvalNameLabel=[GPUtils createLable:CGRectMake(40, 15, Main_Screen_Width-150, 20) text:[NSString stringWithFormat:@"%@ (%@)",model.handlerUserName,model.nodeName ] font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
        [self.mainView addSubview:self.approvalNameLabel];
    }else{
        self.approvalNameLabel=[GPUtils createLable:CGRectMake(40, 15, Main_Screen_Width-150, 20) text:[NSString stringWithFormat:@"%@",model.handlerUserName ] font:Font_Important_15_20 textColor:Color_CellDark_Same_28  textAlignment:NSTextAlignmentLeft];
        [self.mainView addSubview:self.approvalNameLabel];
    }
//    self.approvalNameLabel.backgroundColor=[UIColor cyanColor];
    
    //提交
    self.resultLabel=[GPUtils createLable:CGRectMake(Main_Screen_Width-15-60, 18, 60, 20) text:model.actionLinkName font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
//    self.resultLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:self.resultLabel];
    //    stepImgView
    if (index==0) {
        self.resultLabel.textColor=[UIColor clearColor];
    }else {
        self.resultLabel.textColor=Color_GrayDark_Same_20;
    }
    
    _stateImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 17, 17)];
    _stateImgView.center=CGPointMake(19,24);
    [self.mainView addSubview:_stateImgView];
    if (index==0) {
        _stateImgView.image=[UIImage imageNamed:@"share_Finish"];
    }else{
        _stateImgView.image=[UIImage imageNamed:@"share_Already"];
    }
    
//    if (index!=count-1) {
//        _lineView=[[UIView alloc]initWithFrame:CGRectMake(40, rowHeight-1, Main_Screen_Width-72, 1)];
//        _lineView.backgroundColor=Color_GrayLight_Same_20;
//        [self.mainView addSubview:_lineView];
//    }
    
    if (count>1) {
        if (index==0) {
            UIImageView *lineImage1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, rowHeight-X(_stateImgView)-HEIGHT(_stateImgView))];
            lineImage1.center=CGPointMake(19, rowHeight/2+X(_stateImgView)/2+HEIGHT(_stateImgView)/2+4);
            lineImage1.backgroundColor=Color_GrayLight_Same_20;
            [self.mainView addSubview:lineImage1];
        }else{
            UIImageView *lineImage1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 18)];
            lineImage1.center=CGPointMake(19, 8);
            lineImage1.backgroundColor=Color_GrayLight_Same_20;
            [self.mainView addSubview:lineImage1];
            if (index!=count-1) {
                UIImageView *lineImage2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, rowHeight-X(_stateImgView)-HEIGHT(_stateImgView))];
                lineImage2.center=CGPointMake(19, rowHeight/2+X(_stateImgView)/2+HEIGHT(_stateImgView)/2+4);
                lineImage2.backgroundColor=Color_GrayLight_Same_20;
                [self.mainView addSubview:lineImage2];
            }
        }
    }
    
    if ([NSString isEqualToNull:model.comment]) {
        self.opinionLabel=[GPUtils createLable:CGRectMake(40, 40, Main_Screen_Width-55, 14) text:model.comment font:Font_Same_12_20 textColor:Color_Red_Weak_20 textAlignment:NSTextAlignmentLeft];
        self.opinionLabel.numberOfLines=0;
//        if ([model.actionLinkName isEqualToString:Custing(@"同意", nil)]) {
//            self.opinionLabel.textColor=Color_GrayDark_Same_20;
//        }
        CGSize size = [model.comment sizeCalculateWithFont:self.opinionLabel.font constrainedToSize:CGSizeMake(self.opinionLabel.frame.size.width, 10000) lineBreakMode:self.opinionLabel.lineBreakMode];
        self.opinionLabel.frame = CGRectMake(40,40,Main_Screen_Width-55,size.height);
        self.opinionLabel.text=model.comment;
        //        self.opinionLabel.backgroundColor=Color_GrayLight_Same_20;
        [self.mainView addSubview:self.opinionLabel];
        
        //时间
        self.dataLabel=[GPUtils createLable:CGRectMake(40,rowHeight-25, 115, 12) text:model.finishDate font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.mainView addSubview:self.dataLabel];
        
    }else{
        //时间
        self.dataLabel=[GPUtils createLable:CGRectMake(40, rowHeight-25, 115, 18) text:model.finishDate font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.mainView addSubview:self.dataLabel];
    }
}
+(CGFloat)NoteHeight:(id)object{
    approvalNoteModel *model=(approvalNoteModel *)object;
    if ([NSString isEqualToNull:model.comment]) {
        CGSize size = [model.comment sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-106, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
      return  75+size.height;
        //        NSLog(@"%f",size.height);
    }else{
        return 70;
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
