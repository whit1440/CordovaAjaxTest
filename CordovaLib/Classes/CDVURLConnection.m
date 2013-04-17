#import "CDVURLConnection.h"

@implementation CDVURLConnection
@synthesize request;
@synthesize data;
@synthesize delegate;
@synthesize response;

// Set the delegate, add the header so the CDVURLProtocol knows not to handle this request,
// Create the NSURLConnection with self delegation.
- (void)startWithRequest:(NSURLRequest *)r delegate:(id)d
{
    delegate = d;
    self.request = [r mutableCopy];
    [request setValue:@"Handled" forHTTPHeaderField:@"ar"];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    // just for good measure
    [connection start];
}

// When Auth Challenge is recieved, we will not give a prompt to the user (like a browser would)
// but rather we will let the JS layer decide what to do with the challenge. If an auth challenge is
// received but does not have a 401 status, do the default thing.
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

// Tell delegate that we failed and pass back the response, data, and error
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate connectionResponse:response data:self.data error:error];
}

// Save the response, init the data
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)r
{
    response = r;
    data = [NSMutableData data];
}

// Collect the data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)gotData
{
    [data appendData:gotData];
}

// Tell delegate that we're done and pass back the response, data, and nil error
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.delegate connectionResponse:response data:self.data error:nil];
}

// Make sure that we can even attempt to authenticate against the space.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
}

@end
