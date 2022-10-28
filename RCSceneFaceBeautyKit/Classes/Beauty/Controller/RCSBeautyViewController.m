//
//  RCSBeautyViewController.m
//  Pods-RCSceneFaceBeautyKit_Example
//
//  Created by 彭蕾 on 2022/9/15.
//

#import "RCSBeautyViewController.h"
#import "RCSBeautyView.h"

@interface RCSBeautyViewController ()

@property (nonatomic, strong) RCSBeautyView *beautyView;
@property (nonatomic, strong) UIControl *removeControl;
@property (nonatomic, strong) UITapGestureRecognizer *removeTap;

@end

@implementation RCSBeautyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];

    [self.view addSubview:self.removeControl];
    [self.removeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];

    [self.view addSubview:self.beautyView];
    [self.beautyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_equalTo(210);
    }];
}

- (void)removeVC {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (RCSBeautyView *)beautyView {
    if (!_beautyView) {
        _beautyView = [RCSBeautyView new];
        _beautyView.backgroundColor = [UIColor blackColor];
    }
    return _beautyView;
}

- (UIControl *)removeControl {
    if (!_removeControl) {
        _removeControl = [UIControl new];

        [_removeControl addTarget:self action:@selector(removeVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeControl;
}

@end
