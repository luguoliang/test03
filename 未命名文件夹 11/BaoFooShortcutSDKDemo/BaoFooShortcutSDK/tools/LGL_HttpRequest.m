//
//  LGL_HttpRequest.m
//  ManagedFuns2.0Demo
//
//  Created by 路国良 on 16/3/23.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "LGL_HttpRequest.h"
#import "MBProgressHUD.h"
@interface LGL_HttpRequest()<NSXMLParserDelegate>{
    NSMutableString *_element;
    NSMutableDictionary*_resultsDict;
    NSMutableData*_receiveData;
}
@end
@implementation LGL_HttpRequest
- (instancetype)init
{
    self = [super init];
    if (self) {
        _element = @"".mutableCopy;
        _resultsDict = @{}.mutableCopy;

    }
    return self;
}
-(void)postRequest:(NSString *)postString urlString:(NSURL *)url{
    if (!postString.length) {
        return;
    }
    else{
        NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        NSMutableURLRequest * urlRequest=[NSMutableURLRequest requestWithURL:url];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        urlRequest.timeoutInterval = 20;
        NSURLConnection* urlConn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        [urlConn start];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    NSLog(@"%@",[res allHeaderFields]);
    _receiveData = [NSMutableData data];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];
    //xml解析
    [self xmlParsing:_receiveData];
}
-(void)connection:(NSURLConnection *)connection
 didFailWithError:(NSError *)error
{
    [_delegate fail:@"网络连接有问题哦，请检查网路后再试"];
}
-(void)xmlParsing:(NSMutableData*)data
{
    NSXMLParser *parse=[[NSXMLParser alloc] initWithData:data];
    [parse setDelegate:self];
    [parse parse];
}
#pragma mark - xmlparsing
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"开始解析");
}
//开始处理xml数据（把整个xml遍历一遍，识别元素节点名称）
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
}
//获取文本节点里存储的信息数据
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [_element setString:@""];
    [_element appendString:string];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSString *str = [[NSString alloc] initWithString:_element];
    if ([elementName isEqualToString:@"code"]) {
        NSLog(@"creator=%@",str);
        [_resultsDict addEntriesFromDictionary:@{@"code":str}];
    }
    if ([elementName isEqualToString:@"msg"]) {
        NSLog(@"msg=%@",str);
        [_resultsDict addEntriesFromDictionary:@{@"msg":str}];
    }
    if ([elementName isEqualToString:@"sign"]) {
        NSLog(@"sign=%@",str);
        [_resultsDict addEntriesFromDictionary:@{@"sign":str}];
    }
    if ([elementName isEqualToString:@"crs"]) {
        NSLog(@"crs = %@",str);
    }
    if ([elementName isEqualToString:@"order_id"]) {
        NSLog(@"order_id = %@",str);
        [_resultsDict addEntriesFromDictionary:@{@"order_id":str}];
    }
}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"解析完成");
    NSLog(@"_resultDict = %@",_resultsDict);
    if ([[_resultsDict objectForKey:@"code"] isEqualToString:@"CSD000"]) {
        [_delegate sucessfull:_resultsDict[@"order_id"]];
    }
    else
    {
        [_delegate fail:_resultsDict[@"msg"]];
    }
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"%@",[parseError description]);
    [_delegate fail:@"解析出错，请查看返回数据"];
}

@end
