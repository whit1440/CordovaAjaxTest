#import "CDVURLConnection.h"

@implementation CDVURLConnection
@synthesize request;
@synthesize data;
@synthesize delegate;
@synthesize response;

- (void)startWithRequest:(NSURLRequest *)r delegate:(id)d
{
    delegate = d;
    self.request = [r mutableCopy];
    [request setValue:@"Handled" forHTTPHeaderField:@"ar"];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSHTTPURLResponse* resp = (NSHTTPURLResponse* )[challenge failureResponse];
    if([resp statusCode] == 401){
        [self connection:connection didReceiveResponse:resp];
        [self connectionDidFinishLoading:connection];
    } else{
        [[challenge sender] performDefaultHandlingForAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate connectionResponse:response data:self.data error:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)r
{
    response = r;
    data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)gotData
{
    [data appendData:gotData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.delegate connectionResponse:response data:self.data error:nil];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
}

@end
