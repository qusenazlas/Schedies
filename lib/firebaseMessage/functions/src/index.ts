import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

admin.initializeApp()

// const db = admin.firestore()
const fcm = admin.messaging()
let token: string[] = []
export const toSendTopicToDevices = functions.firestore
  .document('Events/{eventId}')
  .onCreate(async (snapshot) => {
    const event = snapshot.data()

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New event coming',
        body: `You have new event is a ${event.topic}`,
        icon:
          'https://firebasestorage.googleapis.com/v0/b/schedie-2.appspot.com/o/logo.png?alt=media&token=1146c83c-bc87-4926-aa0f-4d09fa3816f9',
      },
      data: {
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
        sound: 'default',
        status: '/wrapper',
        screen: '/wrapper',
      },
    }

    token = event.uidList
    return fcm.sendToDevice(token, payload)
  })

export const toSendChatToDevices = functions.firestore
  .document('Chat/{chatId}/{messageCollectId}/{messageId}')
  .onCreate(async (snapshot) => {
    const chat = snapshot.data()

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: `New message from ${chat.name}`,
        body: `You have new message "${chat.message}"`,
        icon:
          'https://firebasestorage.googleapis.com/v0/b/schedie-2.appspot.com/o/logo.png?alt=media&token=1146c83c-bc87-4926-aa0f-4d09fa3816f9',
      },
      data: {
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
        sound: 'default',
        status: '/chat',
        screen: '/chat',
      },
    }

    token = chat.fcmList
    return fcm.sendToDevice(token, payload)
  })
