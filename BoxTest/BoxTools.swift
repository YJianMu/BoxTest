//
//  BoxTools.swift
//  BoxTest
//
//  Created by YJianMu on 2021/1/16.
//  Copyright © 2021 YJianMu. All rights reserved.
//

import UIKit
import BoxSDK
import AuthenticationServices

@objcMembers

class BoxFileModel: NSObject {
    
    public var name: String = ""
    public var id: String = ""
    public var size: UInt64 = 0
    public var modifyDate: Date = Date()
    public var fileExtension: String = ""
    public var file: Bool = false
    
}

/// Box工具
class BoxTools: NSObject, ASWebAuthenticationPresentationContextProviding {
    
    /// 单例
    @objc static let sharedInstance = BoxTools()
    private override init() {}
    
    private var sdk: BoxSDK!
    private var client: BoxClient!
    
    /// 初始化BoxSDK
    /// - Parameters:
    ///   - clientId: clientId description
    ///   - clientSecret: clientSecret description
    @objc public func initBoxSDK(clientId: String, clientSecret: String) -> Void {
        
        sdk = BoxSDK(clientId: clientId, clientSecret: clientSecret)
        
    }
    
    
    typealias resultsBlock = (Bool, Error?) -> Void
    /// box授权登陆
    /// - Parameter resultsBlock: resultsBlock description
    @objc public func boxOAuthClient(resultsBlock : @escaping resultsBlock) -> Void {
        
        if #available(iOS 13, *) {
            sdk.getOAuth2Client(tokenStore: KeychainTokenStore(), context:self) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(client):
                        self?.client = client
                        resultsBlock(true, nil);
                    case let .failure(error):
                        resultsBlock(false, error);
                    }
                }
            }
        } else {
            sdk.getOAuth2Client(tokenStore: KeychainTokenStore()) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(client):
                        self?.client = client
                        resultsBlock(true, nil);
                    case let .failure(error):
                        print("error in getOAuth2Client: \(error)")
                        resultsBlock(false, error);
                    }
                }
            }
        }
        
    }
    
    
    /// 退出登陆
    @objc public func logout() -> Void {
        
        client.destroy() { result in
//            guard case .success = result else {
//                print("Tokens could not be revoked!")
//                return
//            }
//            print("Tokens were successfully revoked")
        }
        
    }
    
    
    
    typealias FolderItemsBlock = (Array<BoxFileModel>, Error?) -> Void
    
    /// 获取文件夹中的文件
    /// - Parameters:
    ///   - folderId: 文件id，root文件id未 "0"
    ///   - resultsBlock: resultsBlock description
    @objc public func getBoxFolderItems(
        
        folderId: String,
        resultsBlock : @escaping FolderItemsBlock) -> Void {
        
        client.folders.listItems(
            folderId: folderId,
            usemarker: true,
            fields: ["modified_at", "name", "extension", "size"]
        ){ [weak self] result in
            guard self != nil else {return}
            
            switch result {
            case let .success(items):
                
                var folderItems: [BoxFileModel] = []
                
                for _ in 1...MAXINTERP {
                    items.next { result in
                        switch result {
                        case let .success(item):
                            
                            let fileModel = BoxFileModel.init()
                            
                            if case let .file(file) = item {
                                fileModel.name = file.name ?? ""
                                fileModel.id = file.id
                                fileModel.size = UInt64(file.size ?? 0)
                                fileModel.modifyDate = file.modifiedAt ?? Date()
                                fileModel.fileExtension = file.extension ?? "";
                                fileModel.file = true
                            }
                            else if case let .folder(folder) = item {
                                fileModel.name = folder.name ?? ""
                                fileModel.id = folder.id
                                fileModel.size = UInt64(folder.size ?? 0)
                                fileModel.modifyDate = folder.modifiedAt ?? Date()
                                fileModel.file = false
                            }
                            
                            folderItems.append(fileModel)
                            
                        case let .failure(error):
                            DispatchQueue.main.async {
                                resultsBlock(folderItems, error)
                            }
                            return
                        }
                    }
                }
                
            case let .failure(error):
                DispatchQueue.main.async {
                    resultsBlock([], error)
                }
            }
        }
    }
    
    
    /// 下载文件
    /// - Parameters:
    ///   - fileId: 文件id
    ///   - localPath: 存放地址
    ///   - resultsBlock: resultsBlock description
    @objc public func downloadFile(
        
        fileId: String,
        localPath: URL,
        resultsBlock : @escaping resultsBlock) -> Void {
        
        client.files.download(fileId: fileId, destinationURL: localPath) {result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    resultsBlock(true, nil);
                case let .failure(error):
                    resultsBlock(false, error);
                }
            }
        }
        
        // To cancel download
        //task.cancel()
        
    }
    
    
    
    @available(iOS 13.0, *)
    internal func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first ?? ASPresentationAnchor()
    }
    
}
