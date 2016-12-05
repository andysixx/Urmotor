//
//  ChatViewController.swift
//  Umotor
//
//  Created by SIX on 2016/10/19.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import JSQSystemSoundPlayer
import JSQMessagesViewController
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import Photos
import SDWebImage
import MobileCoreServices
import AVKit


class ChatViewController: JSQMessagesViewController {
    
    // MARK: Properties
    var messages = [JSQMessage]()
    var avatarDict = [String: JSQMessagesAvatarImage]()
    var convoID : String? = String()
    var receiverData : AnyObject?
    var rootRef = FIRDatabase.database().reference()
//    var userIsTypingRef: AnyObject? // 1
    let photoCache = NSCache<AnyObject, AnyObject>()
//    private var localTyping = false // 2
//    var isTyping: Bool {
//        get {
//            return localTyping
//        }
//        set {
//            // 3
//            localTyping = newValue
//            self.userIsTypingRef!.setValue(newValue)
//        }
//    }
//    private let imageURLNotSetKey = "NOTSET"
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    var Install_IDs: String?
    var Recive_ID: String?
    var ReciveName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootRef.child("user_profile").child(senderId).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            self.ReciveName = snapshot.value as? String
        })
        
        title = senderDisplayName
        let receiverID = receiverData?.object(forKey: "uid" ) as! String
        rootRef.child("user_profile").child(receiverID).child("install_id").observeSingleEvent(of: .value, with: { (snapshot) in
            self.Install_IDs = snapshot.value as? String
            print(self.Install_IDs!)
        })
        let receiverIDFive = String(receiverID.characters.prefix(5))
        let senderIDFive = String(senderId.characters.prefix(5))
        if(senderIDFive > receiverIDFive)
        {
            self.convoID = senderIDFive + receiverIDFive
            
        }
        else{
            self.convoID = receiverIDFive + senderIDFive
        
        }
        observeMessages()

    }
    func observeUser(id: String){
        FIRDatabase.database().reference().child("user_profile").child(id).observe(.value, with:{ snapshot in
            if let dict = snapshot.value as? [String:AnyObject]
            {
                let avatarUrl = dict["profile_pic_small"] as! String
                self.setupAvatar(url: avatarUrl, messageId: id)
            }
        
        })
    }
    func setupAvatar(url: String, messageId: String){
//        if url != ""{
            let fileUrl = NSURL(string: url)
            let data = NSData(contentsOf: fileUrl! as URL)
            let image = UIImage(data: data as! Data)
            let userImg = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 30)
            avatarDict[messageId] = userImg
//        }else{
//            
//        }
    
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let itemRef = rootRef.child("messagesList").child("\(self.convoID!)").childByAutoId() // 1
        let messageItem = ["text": text, "senderId": senderId, "senderName": senderDisplayName, "MediaType": "TEXT"]
        itemRef.setValue(messageItem)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        sendNotificationToUser(DisplayName: ReciveName, text: text)
        finishSendingMessage()
    }
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let sheet = UIAlertController(title: "傳送影音資訊", message: "請選擇影音資訊", preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel){ (alert: UIAlertAction) in
            
        }
        let photoLibrary = UIAlertAction(title: "相簿膠卷", style: UIAlertActionStyle.default){(alert: UIAlertAction)in
            self.getMediaFrom(type: kUTTypeImage)
        }
        let videoLibrary = UIAlertAction(title: "影片膠卷", style: UIAlertActionStyle.default){(alert: UIAlertAction)in
            self.getMediaFrom(type: kUTTypeMovie)
        }
        sheet.addAction(cancel)
        sheet.addAction(photoLibrary)
        sheet.addAction(videoLibrary)
        self.present(sheet, animated: true, completion: nil)
    }

    func getMediaFrom(type: CFString){
        
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.mediaTypes = [type as String]
        self.present(mediaPicker, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    private func addPhotoMessage(withId id: String, key: String, mediaItem: JSQPhotoMediaItem) {
        if let message = JSQMessage(senderId: id, displayName: "", media: mediaItem) {
            messages.append(message)
            
            if (mediaItem.image == nil) {
                photoMessageMap[key] = mediaItem
            }
            
            collectionView.reloadData()
        }
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
       let message = messages[indexPath.item]
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        if message.senderId == self.senderId{
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .black)
        }else{
            return bubbleFactory?.incomingMessagesBubbleImage(with: .gray)
        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]
        return avatarDict[message.senderId]
//        return JSQMessagesAvatarImageFactory.avatarImage(with: <#T##UIImage!#>, diameter: <#T##UInt#>)
    }
    func sendNotificationToUser(DisplayName: String!, text: String!)
    {//Push notifivation http request
        let url = URL(string: "https://push.kumulos.com/notifications")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let username = "30ef3730-4f04-4af0-9ea0-075bff8d9e97"
        let password = "dfPdrsuT6r2Dkkh2XKuO/KKghWPa7H+F4aaN"
        let loginString = "\(username):\(password)"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        // -u
        let dictionary:[String:Any] = ["broadcast": false, "title":ReciveName!, "message":text, "installIds":[self.Install_IDs!]]
        
        
        
        
        do {
            let data = try  JSONSerialization.data(withJSONObject: dictionary, options: [])
            let task = URLSession.shared.uploadTask(with: urlRequest, from: data, completionHandler: { (data, response, err) in
                print("erraaaa \(err.debugDescription)")
                
                
            })
            task.resume()
        }
        catch {
            
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as!JSQMessagesCollectionViewCell
        
        return cell
    }
    func observeMessages() {
        let messagesQuery = rootRef.child("messagesList/\(self.convoID!)").queryLimited(toLast: 25)
        print(messagesQuery)
        messagesQuery.observe( .childAdded , with: { (snapshot) in

        if let messageData = snapshot.value as? [String: AnyObject]{
        
            let mediaType = messageData["MediaType"] as! String
            let senderId = messageData["senderId"] as! String
            let senderName = messageData["senderName"] as! String
            self.observeUser(id: senderId)
            switch mediaType{
                case "TEXT":
                    let text = messageData["text"] as? String
                    self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, text: text))
                case "PHOTO":
                    
                    let photo = JSQPhotoMediaItem(image: nil)
                    
                    let fileUrl = messageData["fileUrl"] as! String
                    SDWebImageDownloader.shared().downloadImage(with: NSURL(string: fileUrl)! as URL!, options: [], progress: nil, completed: { (image, data, error, finished) in
                        
                        DispatchQueue.main.async {
                            photo?.image = image
                            self.collectionView.reloadData()
                        }
                    })
                    self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, media: photo))
                    if self.senderId == senderId{
                        photo?.appliesMediaViewMaskAsOutgoing = true
                    }else{
                        photo?.appliesMediaViewMaskAsOutgoing = false
                    }

                case "VIDEO":
                    let fileUrl = messageData["fileUrl"] as! String
                    let video = NSURL(string: fileUrl )
                    let videoItem = JSQVideoMediaItem(fileURL: video as URL!, isReadyToPlay: true)
                    self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, media: videoItem))
                    if self.senderId == senderId{
                        videoItem?.appliesMediaViewMaskAsOutgoing = true
                    }else{
                        videoItem?.appliesMediaViewMaskAsOutgoing = false
                    }
                default:
                    print("unknow data type")
                }
            }
             self.collectionView.reloadData()

            })
        
    }
//    override func textViewDidChange(_ textView: UITextView) {
//        super.textViewDidChange(textView)
//        // If the text is not empty, the user is typing
//        isTyping = textView.text != ""
//        print(isTyping)
//    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let message = messages[indexPath.item]
        if message.isMediaMessage{
            if let mediaItem = message.media as? JSQVideoMediaItem{
                let player = AVPlayer(url: mediaItem.fileURL)
                let playViewController = AVPlayerViewController()
                playViewController.player = player
                self.present(playViewController, animated: true, completion: nil)
            }
        }

    }
//    private func observeTyping() {
//        let typingIndicatorRef = rootRef.child("messages/\(self.convoID!)").child("typingIndicator")
//        userIsTypingRef = typingIndicatorRef.child(byAppendingPath: senderId)
//        userIsTypingRef?.onDisconnectRemoveValue()
//        let userIsTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqual(toValue: true)
//        
//        userIsTypingQuery.observe(.value, with: {(snapshot:FIRDataSnapshot) in
//            
//            if snapshot.childrenCount == 1 && self.isTyping{
//                return
//            }
//             self.showTypingIndicator = snapshot.childrenCount > 0
//            self.scrollToBottom(animated: true)
//            
//        })
//    }
    
    func sendMedia(picture: UIImage?, video: NSURL?){
      print(FIRStorage.storage().reference())
        
        if let picture = picture{
            let filePath = "\(senderId!)/\(NSDate.timeIntervalSinceReferenceDate)"
            print(filePath)
            let data = UIImageJPEGRepresentation(picture, 1)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpg"
            FIRStorage.storage().reference().child(filePath).put(data!, metadata: metadata) {(metadata,err) in
                if err != nil{
                    //                print(err?.localizedDescription)
                    return
                }
                //            print(metadata)
                let fileUrl =  metadata!.downloadURLs![0].absoluteString
                let itemRef = self.rootRef.child("messagesList").child("\(self.convoID!)").childByAutoId() // 1
                let messageItem = ["fileUrl": fileUrl, "senderId": self.senderId, "senderName": self.senderDisplayName, "MediaType": "PHOTO"]
                itemRef.setValue(messageItem) // 3
                self.sendNotificationToUser(DisplayName: self.ReciveName, text: "向您傳送圖片")
            }
        }else if let video = video{
        
            let filePath = "\(senderId!)/\(NSDate.timeIntervalSinceReferenceDate)"
            print(filePath)
            let data = NSData(contentsOf: video as URL)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "video/mp4"
            FIRStorage.storage().reference().child(filePath).put(data! as Data, metadata: metadata) {(metadata,err) in
                if err != nil{
                    //                print(err?.localizedDescription)
                    return
                }
                //            print(metadata)
                let fileUrl =  metadata!.downloadURLs![0].absoluteString
                let itemRef = self.rootRef.child("messagesList").child("\(self.convoID!)").childByAutoId() // 1
                let messageItem = ["fileUrl": fileUrl, "senderId": self.senderId, "senderName": self.senderDisplayName, "MediaType": "VIDEO"]
                itemRef.setValue(messageItem) // 3
                self.sendNotificationToUser(DisplayName: self.ReciveName, text: "向您傳送影片")
                
            }
        
        }
        
    }
}

// MARK: Image Picker Delegate
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage{
            sendMedia(picture: picture, video: nil)
            
        }
        else if let video = info[UIImagePickerControllerMediaURL] as? URL{
            sendMedia(picture: nil, video: video as NSURL?)
            
        }
        self.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
    
}
