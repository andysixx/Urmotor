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

class ChatViewController: JSQMessagesViewController {
    
    // MARK: Properties
    var messages = [JSQMessage]()

    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    var convoID : String? = String()
    var receiverData : AnyObject?
    var rootRef = FIRDatabase.database().reference()
    
    var userIsTypingRef: AnyObject? // 1
    private var localTyping = false // 2
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            // 3
            localTyping = newValue
            self.userIsTypingRef!.setValue(newValue)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = senderDisplayName
        setupBubbles()
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        let receiverID = receiverData?.object(forKey: "uid" ) as! String
        let receiverIDFive = String(receiverID.characters.prefix(5))
        let senderIDFive = String(senderId.characters.prefix(5))
        if(senderIDFive > receiverIDFive)
        {
            self.convoID = senderIDFive + receiverIDFive
            
        }
        else{
            self.convoID = receiverIDFive + senderIDFive
        
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        // messages from someone else
//        addMessage(id: "foo", text: "Hey person!")
//        // messages sent from local sender
//        addMessage(id: senderId, text: "Yo!")
//        addMessage(id: senderId, text: "I like turtles!")
//        // animates the receiving of a new message on the view
//        finishReceivingMessage()
        observeMessages()
        observeTyping()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!{
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        
        outgoingBubbleImageView = factory?.outgoingMessagesBubbleImage(
            with: UIColor.jsq_messageBubbleBlue())
        incomingBubbleImageView = factory?.incomingMessagesBubbleImage(
            with: UIColor.jsq_messageBubbleLightGray())
    }

    override public func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
            as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.white
        } else {
            cell.textView!.textColor = UIColor.black
        }
        
        return cell
    }
    
    func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: "", text: text)
        messages.append(message!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
//    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
//        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
//        //ex: self.messages.append(message!)
//        self.finishSendingMessage()
//    }
   override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let itemRef = rootRef.child("messages").child("\(self.convoID!)").childByAutoId() // 1
        let messageItem = [ // 2
            "text": text,
            "senderId": senderId
        ]
        itemRef.setValue(messageItem) // 3
        // 4
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        isTyping = false
        // 5
        finishSendingMessage()
    }
    private func observeMessages() {
        // 1
//        let messagesQuery = messageRef.queryLimitedToLast(25)

        let messagesQuery = rootRef.child("messages/\(self.convoID!)").queryLimited(toLast: 25)
        print(messagesQuery)
        // 2
        messagesQuery.observe( .childAdded , with: { (snapshot) in
            // 3
            print(snapshot)
            let id = snapshot.value as? NSDictionary
            if(id?.object(forKey: "senderId") != nil){
                let usided = id?.object(forKey: "senderId") as! String
                let chat_text = id?.object(forKey: "text") as! String
            //            let id = snapshot.value["senderId"] as! String
//            let text = snapshot.value(forKey: "text") as! String
            
            // 4
                self.addMessage(id: usided, text: chat_text)
            
            // 5
            self.finishReceivingMessage()
                
            }
        })
        
    }

    
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        isTyping = textView.text != ""
        print(isTyping)
    }
    
    private func observeTyping() {
        let typingIndicatorRef = rootRef.child("messages/\(self.convoID!)").child("typingIndicator")
        userIsTypingRef = typingIndicatorRef.child(byAppendingPath: senderId)
        userIsTypingRef?.onDisconnectRemoveValue()
        
        let userIsTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqual(toValue: true)
        
        userIsTypingQuery.observe(.value, with: {(snapshot:FIRDataSnapshot) in
            
            if snapshot.childrenCount == 1 && self.isTyping{
                return
            }
             self.showTypingIndicator = snapshot.childrenCount > 0
            self.scrollToBottom(animated: true)
            
        })
    }
}
