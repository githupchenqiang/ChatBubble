//
//  ChatTableViewCell.m
//  ChatMessage
//
//  Created by QAING CHEN on 17/2/4.
//  Copyright © 2017年 QiangChen. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.HeaderImageView = [[UIImageView alloc]init];
        self.HeaderImageView.layer.cornerRadius = 25.0f;
        self.HeaderImageView.layer.borderWidth = 1.0f;
        self.HeaderImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.HeaderImageView];
        
        self.BubbleImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.BubbleImageView];
        
        self.ContentLabel = [[UILabel alloc]init];
        self.ContentLabel.numberOfLines = 0;
        self.ContentLabel.font = [UIFont systemFontOfSize:17.0f];
        [self.BubbleImageView addSubview:self.ContentLabel];
    }
    return self;
}

- (void)refreshCell:(ChatModel *)model
{
    //计算文本宽度高度
    CGRect rect = [model.MsgString boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
    //气泡
    UIImage *image = nil;
    
    //头像
    UIImage *headerImage = nil;
    
    //模拟左边
    if (!model.isRight) {
        self.HeaderImageView.frame = CGRectMake(10, rect.size.height - 18, 50, 50);
        self.BubbleImageView.frame = CGRectMake(60, 10, rect.size.width + 20, rect.size.height + 20);
        image = [UIImage imageNamed:@"bubbleSomeone"];
        headerImage = [UIImage imageNamed:@"head.JPG"];
    }else
    {
        self.HeaderImageView.frame = CGRectMake(375 - 60, rect.size.height - 18, 50, 50);
        self.BubbleImageView.frame = CGRectMake(375 - 60 - rect.size.width - 20, 10, rect.size.width + 20, rect.size.height + 20);
        image = [UIImage imageNamed:@"bubbleMine"];
        headerImage = [UIImage imageNamed:@"head.JPG"];
    }
    
    //拉伸图片 参数1 代表从左侧到指定像素禁止拉升 该像素之后拉升.  参数2 代表从上面到指定像素禁止拉伸，该像素以下就拉伸
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    self.BubbleImageView.image = image;
    self.HeaderImageView.image = headerImage;
    
    //文本内容的frame
    self.ContentLabel.frame = CGRectMake(model.isRight ? 5 : 13, 5, rect.size.width, rect.size.height);
    self.ContentLabel.text = model.MsgString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
