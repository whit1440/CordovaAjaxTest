#import <Foundation/Foundation.h>

@class CDVURLConnection;
@protocol ConnectionDelegate

- (void)connectionResponse:(NSURLResponse*)response data:(NSData*)data error:(NSError*)error;

@end

@interface CDVURLConnection : NSObject {}
@property (nonatomic) NSMutableURLRequest* request;
@property (nonatomic) NSURLResponse* response;
@property (nonatomic) NSMutableData* data;
@property (nonatomic) IBOutlet id <ConnectionDelegate> delegate;
- (void)startWithRequest:(NSURLRequest*)r delegate:(id)delegate;
@end
