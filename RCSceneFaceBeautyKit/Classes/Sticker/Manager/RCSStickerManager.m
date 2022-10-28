//
//  RCSStickerManager.m
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/10/17.
//

#import "RCSStickerManager.h"
#import <RCSceneNetworkKit/RCSNetworkKit.h>
#import "RCSBeautyEngine+Private.h"
#import "RCSNetworkConfig+FaceBeauty.h"

#define kRCSStickerDownloadTasksMaxNumber (5)

@interface RCSStickerManager ()

@property (nonatomic, strong) NSString *downloadFolder;
@property (nonatomic, strong) NSOperationQueue *downloadQueue;
@property (nonatomic, strong) RCSNetworkDataHandler *dataHandler;
@property (nonatomic, strong) RCSStickerModel *curStickItem;
@property (nonatomic, assign) BOOL isStickerAdding;

@end

@implementation RCSStickerManager

+ (instancetype)shareManager {
    static RCSStickerManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[RCSStickerManager alloc] init];
        _manager.downloadFolder = [self downloadFolder];
        _manager.isStickerAdding = NO;
    });
    return _manager;
}

#pragma mark - public method
- (void)fetchAllSticksWithCompletion:(void (^)(NSArray<RCSStickerCategoryModel *> * _Nullable categories))completion {
    if ([[NSFileManager defaultManager] fileExistsAtPath:[RCSStickerManager localJsonPath]]) {
        NSData *data = [NSData dataWithContentsOfFile:[RCSStickerManager localJsonPath]];
        NSArray<RCSStickerCategoryModel *> *categories = [NSArray yy_modelArrayWithClass:[RCSStickerCategoryModel class]
                                                                                    json:data];
        !completion ?: completion(categories);
        return ;
    }

    RCSNetworkConfig *config = [RCSNetworkConfig getStickerProsConfig];
    [self.dataHandler requestWithUrlConfig:config
                                completion:^(RCSResponseModel * _Nonnull model) {
        if (model.code != RCSResponseStatusCodeSuccess) {
            !completion ?: completion(nil);
            return;
        }
        
        NSArray<RCSStickerCategoryModel *> *categories =
        [NSArray yy_modelArrayWithClass:[RCSStickerCategoryModel class] json:model.data];
        !completion ?: completion(categories);

        /// json 存本地
        NSData *data = [NSJSONSerialization dataWithJSONObject:model.data
                                                       options:kNilOptions
                                                         error:nil];
        [data writeToFile:[RCSStickerManager localJsonPath] atomically:YES];
    }];
}

- (void)downloadItem:(RCSStickerModel *)stickItem completion:(void (^)(NSError * _Nullable error))completion {
    WeakSelf(self);
    [self.downloadQueue addOperationWithBlock:^{
        StrongSelf(weakSelf);
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        RCSNetworkConfig *config = [RCSNetworkConfig downloadStickerConfigWith:stickItem.itemId];
        NSString *downloadTargetPath = [NSString pathWithComponents:@[self.downloadFolder, stickItem.itemId]];
        
        [strongSelf.dataHandler requestWithUrlConfig:config
                                        downloadPath:downloadTargetPath
                                    downloadProgress:^(NSProgress * _Nonnull progress) {}
                                          completion:^(RCSResponseModel * _Nonnull model) {
            
            dispatch_semaphore_signal(semaphore);
            
            if (model.data) {
                NSData *data = [NSData dataWithContentsOfFile:model.data];
                stickItem.loading = NO;
                completion(nil);
            } else {
                NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:model.code userInfo:nil];
                completion(error);
            }
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
    }];
    
}

- (void)cancelDownloadingTasks {
    [self.downloadQueue cancelAllOperations];
}

- (void)loadItem:(RCSStickerModel *)model {
    NSString *filePath = [NSString pathWithComponents:@[self.downloadFolder, model.itemId]];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (isExist) {
        if (self.isStickerAdding) return ;
        
        self.curStickItem = model;
        self.isStickerAdding = YES;
        [[RCSBeautyEngine sharedInstance] addStickerWithPath:filePath name:model.itemId completion:^{
            dispatch_main_async_safe(^{
                self.isStickerAdding = NO;
            });
        }];
    } else {
        NSLog(@"贴纸道具不存在");
    }
}

- (void)releaseItem {
    self.curStickItem = nil;
    [[RCSBeautyEngine sharedInstance] removeAllSticker];
}

- (BOOL)downloadStatusOfSticker:(RCSStickerModel *)sticker {
    NSString *itemPath = [NSString pathWithComponents:@[self.downloadFolder, sticker.itemId]];
    return [[NSFileManager defaultManager] fileExistsAtPath:itemPath];
}

- (RCSStickerModel * _Nullable)currentSelectedItem {
    return self.curStickItem;
}

#pragma mark - lazy load
- (NSOperationQueue *)downloadQueue {
    if (!_downloadQueue) {
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.maxConcurrentOperationCount = kRCSStickerDownloadTasksMaxNumber;
    }
    return _downloadQueue;
}

- (RCSNetworkDataHandler *)dataHandler {
    if (!_dataHandler) {
        _dataHandler = [RCSNetworkDataHandler new];
    }
    return _dataHandler;
}

#pragma mark - local path
+ (NSString *)localJsonPath {
    return [[self downloadFolder] stringByAppendingPathComponent:@"fullStickers.json"];
}

+ (NSString *)downloadFolder {
    NSString *cachePath = [self cachesDirectoryPath];
    NSString *path = [cachePath stringByAppendingPathComponent:@"RCSStickerBundles"];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory;
    if (![manager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return path;
}

#pragma mark - helper

+ (NSString *)cachesDirectoryPath {
    static NSString *cacheDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    });
    return cacheDirectory;
}

@end
