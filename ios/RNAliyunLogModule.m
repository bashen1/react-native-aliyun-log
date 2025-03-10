#import "RNAliyunLogModule.h"
#import <AliyunLogObjc/AliyunLogObjc.h>

@interface RNAliyunLogModule ()

@property (nonatomic, strong) LogClient *logClient;

@end

@implementation RNAliyunLogModule

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(initAliyunLog:(NSString*)endPoint accessKeyId:(NSString*)accessKeyId accessKeySecret:(NSString*)accessKeySecret securityToken:(NSString*)securityToken project:(NSString*)project) {
  _logClient = [[LogClient alloc] initWithApp:endPoint accessKeyID:accessKeyId accessKeySecret:accessKeySecret projectName:project];
  if (securityToken) {
    [_logClient SetToken:securityToken];
  }
}

RCT_EXPORT_METHOD(postAliyunLog:(NSString*)logStore topic:(NSString*)topic source:(NSString*)source keyContents:(NSArray*)keyContents) {
  LogGroup *group = [[LogGroup alloc] initWithTopic:topic andSource:source];
  Log *log = [[Log alloc] init];
  [keyContents enumerateObjectsUsingBlock:^(NSDictionary *keyContent, NSUInteger idx, BOOL * _Nonnull stop) {
    [log PutContent:[keyContent objectForKey:@"content"] withKey:[keyContent objectForKey:@"key"]];
  }];
  [group PutLog:log];
  [_logClient PostLog:group logStoreName:logStore call:^(NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
  }];
}

@end
