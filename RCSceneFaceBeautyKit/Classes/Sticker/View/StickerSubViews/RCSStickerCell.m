//
//  RCSStickerCell.m
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/10/17.
//

#import "RCSStickerCell.h"
#import <SDWebImage/SDWebImage.h>
#import "RCSStickerManager.h"
#import "RCSBeautyNetworkConfig.h"

@interface RCSStickerCell ()

@property (nonatomic, strong) UIView *selectedTipView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *downloadIcon;
@property (nonatomic, strong) UIImageView *loadImage;

@end

@implementation RCSStickerCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    [self addSubview:self.selectedTipView];
    [self.selectedTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(4);
    }];
    
    [self addSubview:self.downloadIcon];
    [self.downloadIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.inset(4);
        make.width.height.mas_equalTo(12);
    }];
    
    [self addSubview:self.loadImage];
    [self.loadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
}

- (void)setModel:(RCSStickerModel *)model {
    _model = model;
    
    NSString *fullImgUrl = [[RCSBeautyNetworkConfig baseUrl] stringByAppendingPathComponent: model.imgUrl];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:fullImgUrl]
                      placeholderImage:RCSBeautyImageNamed(@"sticker_placeholder")];
    
    self.selected = [model.itemId isEqualToString:[RCSStickerManager shareManager].currentSelectedItem.itemId];
    
    if ([[RCSStickerManager shareManager] downloadStatusOfSticker:model]) {
        self.imageView.alpha = 1.0 ;
        self.downloadIcon.hidden = YES ;
        self.loadImage.hidden = YES ;
    } else {
        if (model.isLoading) {
            self.downloadIcon.hidden = YES;
            self.loadImage.hidden = NO ;
            self.imageView.alpha = 0.5 ;
            [self startLoadingAnimation];
        } else {
            self.imageView.alpha = 1.0 ;
            self.downloadIcon.hidden = NO;
            self.loadImage.hidden = YES ;
        }
    }
}

#pragma mark - Animation
- (void)startLoadingAnimation {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0;
    animation.toValue = @(M_PI * 2);
    animation.repeatCount = MAXFLOAT;
    animation.duration = 1 ;
    [self.loadImage.layer addAnimation:animation forKey:nil];
}

- (void)stopLoadingAnimation {
    [self.loadImage.layer removeAllAnimations];
}

#pragma mark - Setters
- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.selectedTipView.layer.borderWidth = 1.5;
        self.selectedTipView.layer.borderColor = [UIColor rcs_colorWithHex:0x1FB2FF].CGColor;
    } else {
        self.selectedTipView.layer.borderWidth = 0;
        self.selectedTipView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

#pragma mark - Getters
- (UIView *)selectedTipView {
    if (!_selectedTipView) {
        _selectedTipView = [UIView new];
        
        _selectedTipView.backgroundColor = [UIColor clearColor];
        _selectedTipView.layer.masksToBounds = YES;
        _selectedTipView.layer.cornerRadius = 25.5;
        
    }
    return _selectedTipView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        
        _imageView.image = RCSBeautyImageNamed(@"sticker_placeholder");
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 22;
    }
    return _imageView;
}

- (UIImageView *)downloadIcon {
    if (!_downloadIcon) {
        _downloadIcon = [UIImageView new];
        
        _downloadIcon.image = RCSBeautyImageNamed(@"sticker_download");
    }
    return _downloadIcon;
}

- (UIImageView *)loadImage {
    if (!_loadImage) {
        _loadImage = [UIImageView new];
        
        _loadImage.image = RCSBeautyImageNamed(@"sticker_refresh");
        _loadImage.hidden = YES;
    }
    return _loadImage;
}

@end
