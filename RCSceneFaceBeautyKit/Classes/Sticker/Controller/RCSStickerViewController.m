//
//  RCSStickerViewController.m
//  RCSceneFaceBeautyKit-RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/10/17.
//

#import "RCSStickerViewController.h"
#import "RCSStickerView.h"
#import "RCSStickerManager.h"

@interface RCSStickerViewController ()<RCSStickerViewDelegate>

@property (nonatomic, strong) RCSStickerView *stickerView;
@property (nonatomic, strong) UIControl *removeControl;
@property (nonatomic, strong) UITapGestureRecognizer *removeTap;

@end

@implementation RCSStickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];

    [self.view addSubview:self.removeControl];
    [self.removeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];

    [self.view addSubview:self.stickerView];
    [self.stickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_equalTo(310);
    }];
    
    [self loadFullSticker];

}

- (void)dealloc {
    [[RCSStickerManager shareManager] cancelDownloadingTasks];
}

- (void)loadFullSticker {
    [[RCSStickerManager shareManager] fetchAllSticksWithCompletion:^(NSArray<RCSStickerCategoryModel *> * _Nullable categories) {
        if (!categories) return;
        
        [self.stickerView loadFullData:categories];
        
    }];
}

- (void)removeVC {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - sticker view delegate
- (void)releaseSticker {
    [[RCSStickerManager shareManager] releaseItem];
}

- (void)addStickerWithModel:(RCSStickerModel *)model complition:(nonnull void (^)(BOOL))complition {
    
    if ([[RCSStickerManager shareManager] downloadStatusOfSticker:model]) {
        [[RCSStickerManager shareManager] loadItem:model];
        !complition ?: complition(YES);
        return ;
    }
    [[RCSStickerManager shareManager] downloadItem:model
                                        completion:^(NSError * _Nullable error) {
        if (error) {
            !complition ?: complition(NO);
            return ;
        }
        [[RCSStickerManager shareManager] loadItem:model];
        !complition ?: complition(YES);
    }];
}

#pragma mark - lazy load
- (RCSStickerView *)stickerView {
    if (!_stickerView) {
        _stickerView = [RCSStickerView new];
        _stickerView.backgroundColor = [UIColor clearColor];
        _stickerView.delegate = self;
        
        // 毛玻璃效果
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.alpha = 1.0;
        [_stickerView insertSubview:effectview atIndex:0];
        [effectview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    return _stickerView;
}

- (UIControl *)removeControl {
    if (!_removeControl) {
        _removeControl = [UIControl new];

        [_removeControl addTarget:self action:@selector(removeVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeControl;
}


@end
