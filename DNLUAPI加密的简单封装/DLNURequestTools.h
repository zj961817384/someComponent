//
//  DLNURequestTools.h
//  
//
//  Created by zzzzz on 2017/4/26.
//
//

///文档在：https://www.zybuluo.com/z903221074/note/339940

#import <Foundation/Foundation.h>

@interface DLNURequestTools : NSObject


@property (nonatomic, copy) NSString *apiKey;//API-KEY
@property (nonatomic, copy) NSString *secretKey;//SECRET_KEY
@property (nonatomic, copy) NSString *nonce;//NONCE

+ (DLNURequestTools *)shareDLNURequestTools;


/**
 加密要传输的参数

 @param dic 要传的参数 类型为字典NSDictionary
 @return 加密之后的字符串
 */
- (NSString *)encryptMsg:(NSDictionary *)dic;

/**
 构造args_sign
 
 @param dic 要传输的数据的字典
 @return 构造出来的字符串
 */
- (NSString *)createArgsSign:(NSDictionary *)dic;
/**
 获取当前时间时间戳
 
 @return 当前时间戳字符串
 */
- (NSString *)getTimeInterval;

/**
 md5加密
 
 @param orignString 要加密的字符串
 @return 加密之后的字符串
 */
- (NSString *)md5HexDigest:(NSString *)orignString;

/**
 AES/CBC/NoPadding 加密
 
 @param plainText 要加密的字符串
 @param gKey key
 @param gIv iv
 @return 加密之后的字符串
 */
- (NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)gKey iv:(NSString *)gIv;

/**
 AES/CBC/NoPadding 解密
 
 @param encryptText 要解密的字符串
 @param gKey key
 @param gIv iv
 @return 解密之后的字符串
 */
- (NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)gKey iv:(NSString *)gIv;

/**
 将string按位转化成data (必须是满足)
 
 @param str 要转换的字符串
 @return 转化出来的data
 */
- (NSData *)createDataFromString:(NSString *)str;

/**
 将data按位转化成string
 
 @param data 要转化的data
 @return 转化出来的string
 */
- (NSString *)createStringFromData:(NSData *)data;

/**
 获取aes128的key
 
 @return 获取到的key
 */
- (NSString *)getKey;

/**
 获取aes128 cec的iv
 
 @return 获取到的iv
 */
- (NSString *)getIv:(NSDictionary *)dic;

/**
 哈希校验生成字符串
 
 @param input 要校验的字符串
 @return 生成的字符串
 */
- (NSString *)sha1:(NSString *)input;

/**
 生成msg_signature
 
 @param parameters 请求的参数
 @param timeInterval 时间戳
 @return 生成的msg_signature
 */
- (NSString *)createMsgSignature:(NSDictionary *)parameters timeInterval:(NSString *)timeInterval;




@end
