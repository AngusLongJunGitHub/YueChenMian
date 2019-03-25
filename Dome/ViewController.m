//
//  ViewController.m
//  Dome
//
//  Created by 革绿信息 on 2019/3/25.
//  Copyright © 2019年 com. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"


#define kJSONUrlString @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=1&category_id="
@interface ViewController ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate,NSURLConnectionDownloadDelegate>
@property(nonatomic,retain)NSMutableData *data;
@end

@implementation ViewController

/*
要使用常规的AFN网络访问

1. AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

所有的网络请求,均有manager发起

2. 需要注意的是,默认提交请求的数据是二进制的,返回格式是JSON

1> 如果提交数据是JSON的,需要将请求格式设置为AFJSONRequestSerializer
2> 如果返回格式不是JSON的,

3. 请求格式

AFHTTPRequestSerializer            二进制格式
AFJSONRequestSerializer            JSON
AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)

4. 返回格式

AFHTTPResponseSerializer           二进制格式
AFJSONResponseSerializer           JSON
AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
AFXMLDocumentResponseSerializer (Mac OS X)
AFPropertyListResponseSerializer   PList
AFImageResponseSerializer          Image
AFCompoundResponseSerializer       组合
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self jsonGetRequest];
}
//对JSON Get方式的请求方式

- (void)jsonGetRequest
{   //NSDictionary *param=@{};
    
    //初始化一个data
    
    self.data=[[NSMutableData alloc]init];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //设置接收格式
    session.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置请求格式
    session.requestSerializer=[AFJSONRequestSerializer serializer];
    //session.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    //get方法请求数据
    [session GET:kJSONUrlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功%@,",task);
     
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@,",task);
    }];
    //获取队列中有多少个请求
    NSInteger count = session.operationQueue.operationCount;
    NSLog(@"count = %ld",count);
    
    NSURLConnection *connetion=[[NSURLConnection alloc]init];
    
    [connetion setDelegateQueue:[[NSOperationQueue alloc]init]];
    
    [connetion start];
//    [session POST:kJSONUrlString parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"成功%@,",task);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"失败%@,",task);
//    }];
    
    

    
    //取消队列中所有的请求
    
    [session.operationQueue cancelAllOperations];
    
}

//代理方法：接收到服务器的响应执行
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"接收到服务器的响应");
}

//代理方法：接收到数据的时候执行
//注意:但数据比较大的时候可能多次执行
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}
//代理方法：数据下载完成了
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{

    NSString *str=[[NSString alloc]initWithData:_data encoding:NSUTF8StringEncoding];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"str=%@",str);
    NSArray *applist=dic[@"applications"];
    for (NSMutableDictionary *appdic in applist) {
        NSLog(@"name=%@",appdic[@"name"]);
    }
}
//代理方法：数据下载失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error = %@",error);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
